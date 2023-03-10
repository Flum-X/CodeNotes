//
//  DXBuffer.h
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

#import <Foundation/Foundation.h>
#import "DXBufferStorage.h"

NS_ASSUME_NONNULL_BEGIN

/// 缓冲丢弃选项
typedef NS_ENUM(NSInteger, DXBufferDiscardOption) {
    /// 自动。根据 IDXBufferStorage 协议丢弃
    DXBufferDiscardOptionAuto = 0,
    /// 丢弃最新数据，即当前 receive 的数据丢弃
    DXBufferDiscardOptionNew = 1
};

/// 缓冲器配置
@interface DXBufferConfig : NSObject <NSCopying>

/// 回调周期，最小值为 1/60 ，即每秒60次。默认 1/60。
@property (nonatomic) NSTimeInterval T;

/// 缓冲池大小。0表示无限制，默认为0。当设置了缓冲池大小时，会根据丢弃规则，丢弃相应的数据
@property (nonatomic) NSUInteger bufferSize;

/// 丢弃规则。默认为Auto
@property (nonatomic) DXBufferDiscardOption discardOption;

/// 回调线程，默认为主线程
@property (nonatomic, strong) dispatch_queue_t completionQueue;

@end

/// 缓冲器
@interface DXBuffer<__covariant T> : NSObject

/// 初始化
- (instancetype)initWithStorage:(__kindof DXBufferStorage<T> *)storage
                         config:(DXBufferConfig *)config;

/// 配置。当 buffer 处于运行状态时，不允许修改 config。可以调用 pause/stop 后修改 config，然后 resume/start 重启
@property (nonatomic, strong, readonly) DXBufferConfig *config;

/// 当前仓库内的数量
@property (nonatomic, readonly) NSUInteger count;

/// 启动
- (void)start;
/// 暂停。回调暂停，接收正常
- (void)pause;
/// 继续。
- (void)resume;
/// 停止。回调和接收都停止，并清空 storage。需要调用 start 重启
- (void)stop;

/// 接收新数据
- (void)receive:(T)obj;
/// 批量获取
/// @param count 获取的数量
- (NSArray<T> *)get:(NSUInteger)count;
/// 获取所有
- (NSArray<T> *)getAll;

/// 回调
@property (nonatomic, copy, nullable) void (^completion)(T obj);
/// Just for RAC
@property (nonatomic, weak, readonly) T obj;

@end

NS_ASSUME_NONNULL_END
