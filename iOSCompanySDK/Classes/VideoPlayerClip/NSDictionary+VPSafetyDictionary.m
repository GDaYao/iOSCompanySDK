////  NSDictionary+VPSafetyDictionary.m
//  iOSCompanySDK
//

#import "NSDictionary+VPSafetyDictionary.h"



@implementation NSDictionary (VPSafetyDictionary)


// 取字典元素
- (id)vpSafetyObjectForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id object = [self objectForKey:key];
        return object;
    }else{
        return nil;
    }
}



@end


