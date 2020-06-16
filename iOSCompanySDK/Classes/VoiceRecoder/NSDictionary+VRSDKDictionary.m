////  NSDictionary+VRSDKDictionary.m
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

#import "NSDictionary+VRSDKDictionary.h"

@implementation NSDictionary (VRSDKDictionary)


// 字典取字典元素
- (id)vrsdkDicSafetyObjectForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id object = [self objectForKey:key];
        return object;
    }else{
        return nil;
    }
}



@end
