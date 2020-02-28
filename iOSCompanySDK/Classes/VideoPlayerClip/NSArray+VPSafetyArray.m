////  NSArray+VPSafetyArray.m
//  iOSCompanySDK
//
//  Created on 2020/2/28.
//  
//

#import "NSArray+VPSafetyArray.h"


@implementation NSArray (VPSafetyArray)


/** func: 取数组--index.
 *
 */
- (id)vpSafetyArrayObjectAtIndexVerify:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}



@end


