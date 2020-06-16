////  NSArray+VRSDKSafetyArray.m
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

#import "NSArray+VRSDKSafetyArray.h"

@implementation NSArray (VRSDKSafetyArray)



/// get array data
/// @param index array index
- (id)vrsdkSafetyArrayObjectAtIndexVerify:(NSUInteger)index {
    if (index < self.count ) {
        return [self objectAtIndex:index];
    }
    return nil;
}




@end
