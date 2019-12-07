////  NSArray+NPTSDKSafeArray.h
//  iOSCompanySDK
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface NSArray (NPTSDKSafeArray)

#pragma mark - NSArray数组分类添加方法
/**
 为数组分类添加的方法  可以在应用中直接调用 可以防止数组越界导致的crash

 @param index 传入的取值下标
 @return id类型的数据
 */
- (id)nptsdkSafetyArrayObjectAtIndexVerify:(NSUInteger)index;
- (id)nptsdkSafetyArrayObjectAtIndexedSubscriptVerify:(NSUInteger)idx;




@end

NS_ASSUME_NONNULL_END
