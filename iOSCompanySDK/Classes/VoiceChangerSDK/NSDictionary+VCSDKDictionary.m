////  NSDictionary+VCSDKDictionary.m
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import "NSDictionary+VCSDKDictionary.h"

@implementation NSDictionary (VCSDKDictionary)


- (id)VCSDKSafetyDictionaryObjectForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id object = [self objectForKey:key];
        return object;
    }else{
        return nil;
    }
}

@end
