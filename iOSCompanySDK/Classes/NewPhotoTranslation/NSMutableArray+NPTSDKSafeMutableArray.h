////  NSMutableArray+NPTSDKSafeMutableArray.h
//  iOSCompanySDK



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSMutableArray (NPTSDKSafeMutableArray)




#pragma mark - NSMubaleArray可变数组分类添加方法
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



@end

NS_ASSUME_NONNULL_END


