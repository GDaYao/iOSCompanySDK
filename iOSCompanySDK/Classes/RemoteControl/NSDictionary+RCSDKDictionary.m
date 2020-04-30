////  NSDictionary+RCSDKDictionary.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import "NSDictionary+RCSDKDictionary.h"

@implementation NSDictionary (RCSDKDictionary)


// 取字典元素
- (id)RCSDKDicSafetyObjectForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id object = [self objectForKey:key];
        return object;
    }else{
        return nil;
    }
}





@end


