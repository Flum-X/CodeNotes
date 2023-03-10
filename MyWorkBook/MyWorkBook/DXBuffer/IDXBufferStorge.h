//
//  IDXBufferStorge.h
//  MyWorkBook
//
//  Created by yuqing on 2023/3/10.
//

#ifndef IDXBufferStorge_h
#define IDXBufferStorge_h

/// 缓冲池仓库协议
@protocol IDXBufferStorage <NSObject>

@required
/// 输入
- (void)put:(id)obj;
/// 输出
- (id)get;
/// 丢弃
- (id)discard;
/// 清空仓库
- (void)clear;
/// 当前仓库内的数据量
@property (nonatomic, readonly) NSUInteger count;

@end

#endif /* IDXBufferStorge_h */
