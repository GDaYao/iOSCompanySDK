////  NSMutableArray+RCSDKMuArray.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import "NSMutableArray+RCSDKMuArray.h"


@implementation NSMutableArray (RCSDKMuArray)


// 取元素
- (id)RCSDKSafetyMuArrObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

// 元素插入指定位置
- (void)RCSDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
// 可变数组添加元素
- (void)RCSDKSafetyMuArrAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}
// 可变数组移除元素
- (void)RCSDKSafetyMuArrDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}
// 可变数组移除元素-使用index
- (void)RCSDKSafetyMuArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}





@end



