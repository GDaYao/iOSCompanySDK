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


+ (BOOL)VCSDKClassObjectIsNull:(id)judgeClassObject {
    if ( (judgeClassObject==nil) || (judgeClassObject ==NULL) ) {
        return YES;
    }
    
    if ( [judgeClassObject isKindOfClass:[NSNull class] ] ) {
        return YES;
    }
    
    NSString *str = NSStringFromClass([judgeClassObject class]);
    if ([str isEqualToString:@""]       ||
        [str isEqualToString:@"null"]   ||
        [str isEqualToString:@"<NULL>"] ||
        [str isEqualToString:@"<null>"] ||
        [str isEqualToString:@"NULL"]   ||
        [str isEqualToString:@"nil"]    ||
        [str isEqualToString:@"(null)"] ) {
        return YES;
    }
    return NO;
}




@end
