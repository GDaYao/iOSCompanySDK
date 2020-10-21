////  NSArray+BASDKSafetyArray.m
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import "NSArray+BASDKSafetyArray.h"

@implementation NSArray (BASDKSafetyArray)

/** func: 取数据-index
 */
- (id)BASDKSafetyArrayObjectAtIndexVerify:(NSUInteger)index {
    if (index < self.count) {
        return[self objectAtIndex:index];
    }
    return nil;
}


@end

