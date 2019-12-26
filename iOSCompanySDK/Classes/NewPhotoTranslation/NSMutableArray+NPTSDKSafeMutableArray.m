////  NSMutableArray+NPTSDKSafeMutableArray.m
//  iOSCompanySDK
//


#import "NSMutableArray+NPTSDKSafeMutableArray.h"



@implementation NSMutableArray (NPTSDKSafeMutableArray)


#pragma mark - 可变数组插入数据
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

#pragma mark - 可变数组移除数据
- (void)nptsdkSafetyMutableArrDeleteWithObject:(id)object {
    if (object) {
        [self removeObject:object];
    }
}
- (void)nptsdkSafetyMutableArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];        
    }
}


#pragma mark - 可变数组取数据
- (id)nptsdkSafetyMutableArrObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}



@end


