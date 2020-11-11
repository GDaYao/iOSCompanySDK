////  NSDictionary+BASDKDictionary.m
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import "NSDictionary+BASDKDictionary.h"

@implementation NSDictionary (BASDKDictionary)


- (id)BASDKDicSafetyObjectForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id object = [self objectForKey:key];
        return object;
    }else{
        return nil;
    }
}





@end


