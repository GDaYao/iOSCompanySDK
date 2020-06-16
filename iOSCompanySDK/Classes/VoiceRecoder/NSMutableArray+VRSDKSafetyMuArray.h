////  NSMutableArray+VRSDKSafetyMuArray.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//


/** func: get NSMutableArray safety data.
 *
 *
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (VRSDKSafetyMuArray)

// 取元素
- (id)vrsdkSafetyMuArrObjectAtIndex:(NSUInteger)index;
// 元素插入指定位置
- (void)vrsdkSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
// 添加元素
- (void)vrsdkSafetyMuArrAddObjectVerify:(id)object;


// TODO: 移除元素
- (void)vrsdkSafetyMuArrDeleteWithObject:(id)object;
// 使用index
- (void)vrsdkSafetyMuArrDeleteWithIndex:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END
