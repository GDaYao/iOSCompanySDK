////  NWFSystemMgr.m
//  iOSCompanySDK
//
//  Created on 2019/8/15.
//  
//

#import "NWFSystemMgr.h"
#import "NWFKeychainItemWrapper.h"

// use get idfa
#import <AdSupport/AdSupport.h>

// 获取当前设备型号名称
#import "sys/utsname.h"

@implementation NWFSystemMgr

#pragma mark - get app config
//获取当前App的版本号信息
+ (NSString *)getAppVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
// 获取当前App的build版本号信息
+ (NSString *)getAppBuildVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}
// 获取当前App的包名信息
+ (NSString *)getAppBundleId {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}
// garbage code
+ (void)addGarbageTextCodeInPublicNNNNNModel {
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFour = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIView *view = [[UIView alloc]init];
    [view addSubview:testBtn];
    [view addSubview:testBtnTwo];
    [view addSubview:testBtnThree];
    [view addSubview:testBtnFour];
    [view addSubview:testBtnFive];
    
}
// 获取当前App的名称信息
+ (NSString *)getAppDisplayName {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}


/* 获取当前设备的UDID-存储到KeyChain中  */
+ (NSString *)getDeviceUDIDValueFromKeychainInNWF {
    NSString *identifier = @"GetUDIDIdentifierInNWF";
    NWFKeychainItemWrapper *keyChainWrapper = [[NWFKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    NSArray *UUID = [keyChainWrapper objectForKey:(__bridge id)kSecValueData];
    if (UUID == nil || UUID.count == 0) {
        UUID = @[ [[[UIDevice currentDevice] identifierForVendor] UUIDString] ];
        [keyChainWrapper setObject:UUID forKey:(__bridge id)kSecValueData];
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return UUID[0];
}

// get current设备的idfa
+ (NSString *)nwfGetDeviceIDFA {
    
    NSString *nwfIdentifier = @"NWFKeychainItemWrapper_idfa";
    NWFKeychainItemWrapper *keyChainWrapper = [[NWFKeychainItemWrapper alloc]initWithIdentifier:nwfIdentifier accessGroup:nil];
    NSArray *user = [keyChainWrapper objectForKey:(__bridge id)kSecValueRef];
    if (user == nil || user.count == 0)
    {
        [keyChainWrapper setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]
                     forKey:(__bridge id)kSecValueRef];
        return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    else
    {
        return user[0];
    }
}



// 获取设备型号
+ (NSString*)getDeviceTypeInNWF {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    if([platform isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
    if([platform isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
    if([platform isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
    if([platform isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
    
    if([platform isEqualToString:@"iPod1,1"]) return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return@"iPhone Simulator";
    
    return platform;
    
}
// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersionInNWF {
    return [[UIDevice currentDevice] systemVersion];
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
