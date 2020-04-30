////  NSMutableArray+RCSDKMuArray.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (RCSDKMuArray)

// 取元素
- (id)RCSDKSafetyMuArrObjectAtIndex:(NSUInteger)index;
// 元素插入指定位置
- (void)RCSDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
// 可变数组添加元素
- (void)RCSDKSafetyMuArrAddObjectVerify:(id)object;
// 可变数组移除元素
- (void)RCSDKSafetyMuArrDeleteWithObject:(id)object;
// 可变数组移除元素-使用index
- (void)RCSDKSafetyMuArrDeleteWithIndex:(NSUInteger)index;



@end

NS_ASSUME_NONNULL_END


