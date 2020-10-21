////  NSMutableArray+BASDKMuArray.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (BASDKMuArray)

// 取元素
- (id)BASDKSafetyMuArrObjectAtIndex:(NSUInteger)index;
// 元素插入指定位置
- (void)BASDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
// 可变数组添加元素
- (void)BASDKSafetyMuArrAddObjectVerify:(id)object;
// 可变数组移除元素
- (void)BASDKSafetyMuArrDeleteWithObject:(id)object;
// 可变数组移除元素-使用index
- (void)BASDKSafetyMuArrDeleteWithIndex:(NSUInteger)index;



@end

NS_ASSUME_NONNULL_END


