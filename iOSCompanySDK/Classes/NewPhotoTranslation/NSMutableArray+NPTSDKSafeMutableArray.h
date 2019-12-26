////  NSMutableArray+NPTSDKSafeMutableArray.h
//  iOSCompanySDK



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSMutableArray (NPTSDKSafeMutableArray)




#pragma mark - 可变数组插入数据
/**
 数组中插入数据

 @param object 数据
 @param index 下标
 */
- (void)nptsdkSafetyMutableArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
/**
 数组中添加数据

 @param object 数据
 */
- (void)nptsdkSafetyMutableArrAddObjectVerify:(id)object;


#pragma mark - 可变数组移除数据
- (void)nptsdkSafetyMutableArrDeleteWithObject:(id)object;
- (void)nptsdkSafetyMutableArrDeleteWithIndex:(NSUInteger)index;

#pragma mark - 可变数组取数据
- (id)nptsdkSafetyMutableArrObjectAtIndex:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END


