////  NSMutableArray+VRSDKSafetyMuArray.m
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

#import "NSMutableArray+VRSDKSafetyMuArray.h"


@implementation NSMutableArray (VRSDKSafetyMuArray)


// 取元素
- (id)vrsdkSafetyMuArrObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

// 元素插入指定位置
- (void)vrsdkSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
// 添加元素
- (void)vrsdkSafetyMuArrAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}
// TODO: 移除元素
- (void)vrsdkSafetyMuArrDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}
// 使用index
- (void)vrsdkSafetyMuArrDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}





@end
