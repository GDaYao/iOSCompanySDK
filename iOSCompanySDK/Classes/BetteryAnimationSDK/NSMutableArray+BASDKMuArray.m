////  NSMutableArray+BASDKMuArray.m
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import "NSMutableArray+BASDKMuArray.h"


@implementation NSMutableArray (BASDKMuArray)


// 取元素
- (id)BASDKSafetyMuArrObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

// 元素插入指定位置
- (void)BASDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
// 可变数组添加元素
- (void)BASDKSafetyMuArrAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}
// 可变数组移除元素
- (void)BASDKSafetyMuArrDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}
// 可变数组移除元素-使用index
- (void)BASDKSafetyMuArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}





@end



