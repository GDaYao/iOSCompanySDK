////  NSMutableArray+NPTSDKSafeMutableArray.m
//  iOSCompanySDK
//


#import "NSMutableArray+NPTSDKSafeMutableArray.h"



@implementation NSMutableArray (NPTSDKSafeMutableArray)


#pragma mark - 可变数组防越界分类方法
/**
 *  数组中插入数据
 */
- (void)nptsdkSafetyMutableArrInsertObjectVerify:(id)object atIndex:(NSInteger)index{
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
/**
 *  数组中添加数据
 */
- (void)nptsdkSafetyMutableArrAddObjectVerify:(id)object{
    if (object) {
        [self addObject:object];
    }
}



@end


