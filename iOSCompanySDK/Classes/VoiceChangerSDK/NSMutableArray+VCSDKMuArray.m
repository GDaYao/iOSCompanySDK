////  NSMutableArray+VCSDKMuArray.m
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import "NSMutableArray+VCSDKMuArray.h"


@implementation NSMutableArray (VCSDKMuArray)


- (id)VCSDKSafetyMuArrObjectAtIndex:(NSUInteger)arrIndex {
    if (self.count>arrIndex) {
        return [self objectAtIndex:arrIndex];
    }
    return nil;
}

- (void)VCSDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}

- (void)VCSDKSafetyMuArrAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}
- (void)VCSDKSafetyMuArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}
- (void)VCSDKSafetyMuArrDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}







@end



