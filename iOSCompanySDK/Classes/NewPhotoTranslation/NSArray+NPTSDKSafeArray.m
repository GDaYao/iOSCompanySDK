////  NSArray+NPTSDKSafeArray.m
//  iOSCompanySDK



#import "NSArray+NPTSDKSafeArray.h"


@implementation NSArray (NPTSDKSafeArray)


#pragma mark - 安全数组方法使用
- (id)nptsdkSafetyArrayObjectAtIndexVerify:(NSUInteger)index {
    if (index < self.count) {
           return [self objectAtIndex:index];
       }else{
           return nil;
       }
}
- (id)nptsdkSafetyArrayObjectAtIndexedSubscriptVerify:(NSUInteger)idx {
    if (idx < self.count) {
           return [self objectAtIndexedSubscript:idx];
       }else{
           return nil;
       }
}






@end
