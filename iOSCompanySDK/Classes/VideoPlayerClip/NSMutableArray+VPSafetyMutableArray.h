////  NSMutableArray+VPSafetyMutableArray.h
//  iOSCompanySDK
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (VPSafetyMutableArray)

// 取元素
- (id)vpSafetyMutableArrayObjectAtIndex:(NSUInteger)index;

// 插入指定位置元素
- (void)vpSafetyMutableArrayInsertObjectVerify:(id)object atIndex:(NSInteger)index;
// 可变数组添加元素
- (void)vpSafetyMutableArrayAddObjectVerify:(id)object;

// 可变数组移除元素-匹配对象
- (void)vpSafetyMutableArrayDeleteWithObject:(id)object;
// 可变数组移除元素-使用index
- (void)vpSafetyMutableArrayDeleteWithIndex:(NSUInteger)index;








@end

NS_ASSUME_NONNULL_END



