////  NWFSystemMgr.m
//  iOSCompanySDK
//
//  Created on 2019/8/15.
//  
//

#import "NWFSystemMgr.h"

@implementation NWFSystemMgr

#pragma mark - get app config
/*获取当前App的版本号信息*/
+ (NSString *)getAppVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
/*获取当前App的build版本号信息*/
+ (NSString *)getAppBuildVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}
/*获取当前App的包名信息*/
+ (NSString *)getAppBundleId {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}
/*获取当前App的名称信息*/
+ (NSString *)getAppDisplayName {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}



#pragma mark - get system languages
/**   en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ...... */
+ (NSString*)getPreferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if (preferredLang.length>=2) {
        if( [[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"en"]  ){
            return @"en";
        }
    }
    if (preferredLang.length>=7) {
        if( [[preferredLang substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"zh-Hans"]  ){
            return @"zh-Hans";
        }
    }
    if (preferredLang.length>=7) {
        if( [[preferredLang substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"zh-Hant"]  ){
            return @"zh-Hant";
        }
    }
    if (preferredLang.length>=2) {
        if( [[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ja"]  ){
            return @"ja";
        }
    }
    // NSLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
}


@end
