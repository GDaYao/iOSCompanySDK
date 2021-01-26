////  NSArray+VCSDKSafetyArray.m
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import "NSArray+VCSDKSafetyArray.h"

@implementation NSArray (VCSDKSafetyArray)




- (id)VCSDKSafetyArrayObjectAtIndexVerify:(NSUInteger)arrayIndex  {
    if (arrayIndex < self.count) {
        return [self objectAtIndex:arrayIndex];
    }
    return nil;
}




@end


