////  NSMutableArray+VPSafetyMutableArray.m
//  iOSCompanySDK
//

#import "NSMutableArray+VPSafetyMutableArray.h"



@implementation NSMutableArray (VPSafetyMutableArray)


// 取元素
- (id)vpSafetyMutableArrayObjectAtIndex:(NSUInteger)index {
    if (self.count>index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

// 插入指定位置元素
- (void)vpSafetyMutableArrayInsertObjectVerify:(id)object atIndex:(NSInteger)index {
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
// 可变数组添加元素
- (void)vpSafetyMutableArrayAddObjectVerify:(id)object {
    if (object) {
        [self addObject:object];
    }
}

// 可变数组移除元素-匹配对象
- (void)vpSafetyMutableArrayDeleteWithObject:(id)object {
    if (object && [self containsObject:object]) {
        [self removeObject:object];
    }
}
// 可变数组移除元素-使用index
- (void)vpSafetyMutableArrayDeleteWithIndex:(NSUInteger)index {
    if (self.count>index) {
        [self removeObjectAtIndex:index];
    }
}



@end

