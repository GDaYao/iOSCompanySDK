////  NSMutableArray+BASDKMuArray.m
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import "NSMutableArray+BASDKMuArray.h"


@implementation NSMutableArray (BASDKMuArray)


- (id)BASDKSafetyMuArrObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}
- (void)BASDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}

- (void)BASDKSafetyMuArrAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}
- (void)BASDKSafetyMuArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}
- (void)BASDKSafetyMuArrDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}





@end



