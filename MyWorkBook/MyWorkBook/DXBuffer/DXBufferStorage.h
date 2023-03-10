//
//  DXBufferStorage.h
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

#import <Foundation/Foundation.h>
#import "IDXBufferStorge.h"

NS_ASSUME_NONNULL_BEGIN

/// 缓冲池仓库基类
@interface DXBufferStorage<__covariant T> : NSObject <IDXBufferStorage>

- (void)put:(T)obj;
- (T _Nullable)get;
- (T _Nullable)discard;
- (void)clear;

@end

/// 双向链表
@interface DXLinkedNode<__covariant T> : NSObject

@property (nonatomic, weak, nullable) DXLinkedNode<T> *pre;
@property (nonatomic, strong, nullable) DXLinkedNode<T> *next;

/// 节点
@property (nonatomic, strong, nullable) T node;

@end

/// 队列，先进先出
@interface DXQueueStorage<T> : DXBufferStorage<T> @end

/// 栈，先进后出
@interface DXStackStorage<T> : DXBufferStorage<T> @end

/// 带优先级的对象协议
@protocol IDXPriorityObject;

/// 带优先级的缓冲池，优先级高的先出
@interface DXPriorityStorage<T: id<IDXPriorityObject>> : DXBufferStorage<T> @end

/// 带优先级的对象协议
@protocol IDXPriorityObject <NSObject>

@required
/// 优先级
@property (nonatomic) NSInteger priority;

@end

NS_ASSUME_NONNULL_END
