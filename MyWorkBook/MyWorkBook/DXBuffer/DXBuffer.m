//
//  DXBuffer.m
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

#import "DXBuffer.h"

static const NSTimeInterval _DXBufferConfigMinT = 1.0 / 60;

@implementation DXBufferConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _T = _DXBufferConfigMinT;
        _bufferSize = 0;
        _discardOption = DXBufferDiscardOptionAuto;
        _completionQueue = dispatch_get_main_queue();
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DXBufferConfig *copy = DXBufferConfig.new;
    copy.T               = self.T;
    copy.bufferSize      = self.bufferSize;
    copy.discardOption   = self.discardOption;
    copy.completionQueue = self.completionQueue;
    return copy;
}

@end

@interface DXBuffer ()

/// 仓库
@property (nonatomic, strong) id<IDXBufferStorage> storage;

@property (nonatomic, weak) id obj;
/// 是否处于活跃中
@property (nonatomic) BOOL active;
@property (nonatomic) BOOL isPause;
@property (nonatomic) BOOL suspend;

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, strong) dispatch_queue_t putQueue;
@property (nonatomic, strong) dispatch_queue_t getQueue;
@property (nonatomic, weak) dispatch_block_t mission;

@end

@implementation DXBuffer

@synthesize config = _config;

- (instancetype)initWithStorage:(__kindof DXBufferStorage *)storage
                         config:(DXBufferConfig *)config {
    NSAssert(storage && config, @"Storage & Config SHOULD NOT be nil!");
    self = [super init];
    if (self) {
        _storage = storage;
        _config = config.copy;
        _putQueue = dispatch_queue_create("com.party.buffer.put.queue", DISPATCH_QUEUE_SERIAL);
        _getQueue = dispatch_queue_create("com.party.buffer.get.queue", DISPATCH_QUEUE_SERIAL);
        _lock = dispatch_semaphore_create(1);
        _suspend = YES;
        if (_config.T < _DXBufferConfigMinT) { _config.T = _DXBufferConfigMinT; }
        if (!_config.completionQueue) { _config.completionQueue = dispatch_get_main_queue(); }
    }
    return self;
}

- (DXBufferConfig *)config {
    if (!self.active || self.isPause) { return _config; }
    return _config.copy;
}

- (NSUInteger)count { return self.storage.count; }

#define _SYNC_2_MAIN_SAFE(...) if (NSThread.isMainThread) {  __VA_ARGS__ } else { dispatch_sync(dispatch_get_main_queue(), ^{ __VA_ARGS__ }); }

- (void)start { _SYNC_2_MAIN_SAFE([self _start];) }
- (void)pause { _SYNC_2_MAIN_SAFE([self _pause];) }
- (void)resume { _SYNC_2_MAIN_SAFE([self _resume];) }
- (void)stop { _SYNC_2_MAIN_SAFE([self _stop];) }

- (void)receive:(id)obj {
    dispatch_async(self.putQueue, ^{
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        [self _receive:obj];
        dispatch_semaphore_signal(self.lock);
    });
}

- (NSArray *)get:(NSUInteger)count {
    NSMutableArray *array = NSMutableArray.new;
    dispatch_sync(self.getQueue, ^{
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        for (NSInteger i = 0; i < count; i++) {
            id obj = [self.storage get];
            if (!obj) { break; }
            [array addObject:obj];
        }
        dispatch_semaphore_signal(self.lock);
    });
    return array.copy;
}

- (NSArray *)getAll {
    return [self get:NSUIntegerMax];
}

#pragma mark - Private
- (void)_start {
    if (self.active) { return; }
    self.active = YES;
    self.isPause = NO;
    [self _autoGet];
}

- (void)_pause {
    if (!self.active || self.isPause) { return; }
    self.isPause = YES;
    self.suspend = YES;
    if (self.mission) { dispatch_cancel(self.mission); }
}

- (void)_resume {
    if (!self.active || !self.isPause) { return; }
    self.isPause = NO;
    dispatch_async(self.getQueue, ^{
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        if (self.config.bufferSize > 0) {
            // 检查重启时，是否修改了 bufferSize
            while (self.storage.count > self.config.bufferSize) {
                [self.storage discard];
            }
        }
        [self _getIfCan];
        dispatch_semaphore_signal(self.lock);
    });
}

- (void)_stop {
    if (!self.active) { return; }
    self.active = NO;
    self.isPause = YES;
    self.suspend = YES;
    if (self.mission) { dispatch_cancel(self.mission); }
    dispatch_async(self.getQueue, ^{
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        [self.storage clear];
        dispatch_semaphore_signal(self.lock);
    });
}

- (void)_pull {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    [self _get];
    dispatch_semaphore_signal(self.lock);
}

- (void)_get {
    if (!self.active || self.isPause) { self.suspend = YES; return; }
    
    // 当次如果已经没有数据处理，则挂起线程
    if (self.storage.count <= 0) {
        self.suspend = YES;
        return;
    }
    
    id obj = [self.storage get];
    dispatch_async(self.config.completionQueue, ^{
        if (self.completion) { self.completion(obj); }
        self.obj = obj;
    });
    // 当次处理完后，不关心仓库中是否还有数据，挂起线程的判断交给下次任务处理
    dispatch_block_t mission = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [self _pull];
    });
    self.mission = mission;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.config.T * NSEC_PER_SEC)), self.getQueue, mission);
}

- (void)_getIfCan {
    if (!self.suspend || self.isPause) { return; }
    self.suspend = NO;
    [self _get];
}

- (void)_autoGet {
    dispatch_async(self.getQueue, ^{
        dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
        [self _getIfCan];
        dispatch_semaphore_signal(self.lock);
    });
}

- (void)_receive:(id)obj {
    if (!self.active) { return; }
    if (self.config.bufferSize <= 0 || self.storage.count < self.config.bufferSize) {
        [self.storage put:obj];
    } else {
        // 设置了缓冲池大小限制且缓冲池超过了限制
        switch (self.config.discardOption) {
            case DXBufferDiscardOptionAuto: {
                [self.storage put:obj];
                [self.storage discard];
                break;
            }
            case DXBufferDiscardOptionNew: {
                break;
            }
        }
    }
    
    [self _autoGet];
}

@end
