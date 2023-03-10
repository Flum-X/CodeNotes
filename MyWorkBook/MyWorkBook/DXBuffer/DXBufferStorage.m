//
//  DXBufferStorage.m
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

#import "DXBufferStorage.h"

@interface DXBufferStorage () {
@protected
    NSUInteger _count;
}
@end

@implementation DXBufferStorage

@synthesize count = _count;

- (void)put:(id)obj { NSAssert(NO, @"Subclass should implement！"); }

- (id)get {
    NSAssert(NO, @"Subclass should implement！");
    return nil;
}

- (id)discard {
    NSAssert(NO, @"Subclass should implement！");
    return nil;
}

- (void)clear { NSAssert(NO, @"Subclass should implement！"); }

@end

@implementation DXLinkedNode @end

#pragma mark - Queue
@interface DXQueueStorage<T> ()

/// 头指针
@property (nonatomic, strong) DXLinkedNode *head;
/// 尾指针
@property (nonatomic, strong) DXLinkedNode *tail;

@end

@implementation DXQueueStorage

- (void)put:(id)obj {
    DXLinkedNode *node = DXLinkedNode.new;
    node.node = obj;
    node.pre = self.tail;
    self.tail.next = node;
    self.tail = node;
    _count++;
    if (!self.head) {
        self.head = self.tail;
    }
}

- (id)get {
    if (!self.head) { return nil; }
    id obj = self.head.node;
    _count--;
    if (self.head == self.tail) {
        self.head = nil;
        self.tail = nil;
    } else {
        self.head = self.head.next;
        self.head.pre = nil;
    }
    return obj;
}

- (id)discard { return [self get]; }

- (void)clear {
    while ((self.head = self.head.next)) {}
    self.head = nil; self.tail = nil; _count = 0;
}

- (void)dealloc { [self clear]; }

@end

#pragma mark - Stack
@interface DXStackStorage<T> ()

/// 头指针
@property (nonatomic, strong) DXLinkedNode *head;
/// 尾指针
@property (nonatomic, strong) DXLinkedNode *tail;

@end

@implementation DXStackStorage

- (void)put:(id)obj {
    DXLinkedNode *node = DXLinkedNode.new;
    node.node = obj;
    node.pre = self.tail;
    self.tail.next = node;
    self.tail = node;
    _count++;
    if (!self.head) {
        self.head = self.tail;
    }
}

- (id)get {
    if (!self.tail) { return nil; }
    id obj = self.tail.node;
    _count--;
    if (self.head == self.tail) {
        self.head = nil;
        self.tail = nil;
    } else {
        self.tail = self.tail.pre;
        self.tail.next = nil;
    }
    return obj;
}

- (id)discard { return [self get]; }

- (void)clear {
    while ((self.head = self.head.next)) {}
    self.head = nil; self.tail = nil; _count = 0;
}

- (void)dealloc { [self clear]; }

@end

#pragma mark - Priority
@interface DXPriorityStorage <T: id<IDXPriorityObject>> ()

/// 按照优先级升序排列。每次返回最后一个对象。
@property (nonatomic, strong) NSMutableArray<T> *storage;

@end

@implementation DXPriorityStorage

- (instancetype)init {
    self = [super init];
    if (self) { _storage = NSMutableArray.new; }
    return self;
}

- (void)put:(id<IDXPriorityObject>)obj {
    NSInteger r = self.storage.count - 1, l = 0;
    NSInteger m = (l + r) / 2;
    while (l <= r) {
        id<IDXPriorityObject> mo = self.storage[m];
        if (mo.priority == obj.priority) { break; }
        if (mo.priority < obj.priority) {
            l = m + 1;
        } else {
            r = m - 1;
        }
        m = (l + r) / 2;
    }
    if (l > r) { m = l; }
    [self.storage insertObject:obj
                       atIndex:m];
}

- (id)get {
    id obj = self.storage.lastObject;
    if (self.storage.count > 0) { [self.storage removeObjectAtIndex:(self.storage.count - 1)]; }
    return obj;
}

- (id)discard {
    id obj = self.storage.firstObject;
    if (self.storage.count > 0) { [self.storage removeObjectAtIndex:0]; }
    return obj;
}

- (void)clear { [self.storage removeAllObjects]; }

- (NSUInteger)count { return self.storage.count; }

@end
