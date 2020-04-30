////  NSArray+RCSDKSafetyArray.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//


#import "NSArray+RCSDKSafetyArray.h"



@implementation NSArray (RCSDKSafetyArray)


/** func: 取数据-index
 */
- (id)RCSDKSafetyArrayObjectAtIndexVerify:(NSUInteger)index {
    if (index < self.count) {
        return[self objectAtIndex:index];
    }
    return nil;
}








@end



