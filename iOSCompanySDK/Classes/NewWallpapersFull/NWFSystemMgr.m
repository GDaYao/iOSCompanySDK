
//  NWFSystemMgr.m
//  
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

// judge network status
#import "NWFReachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


#define kNwfInKeychainItemIndentifier @"NwfInKeychainItemIndentifier"

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
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (appName.length==0 || appName ==nil) {
        appName =    [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    }
    return appName;
}

// save public service token
+ (void)setNWfKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject {
    
    NWFKeychainItemWrapper *keychain = [[NWFKeychainItemWrapper alloc]initWithIdentifier:kNwfInKeychainItemIndentifier accessGroup:nil];
    NSString *keychainValue = [keychain objectForKey:(__bridge id)kSecAttrService];
    if (keychainValue.length != 0) {
    }else{
        [keychain setObject:saveObject forKey:(__bridge id)kSecAttrService];
    }
}
+ (NSString *)getNwfKeyChainPublicServiceToken {
    NWFKeychainItemWrapper *keychain = [[NWFKeychainItemWrapper alloc]initWithIdentifier:kNwfInKeychainItemIndentifier accessGroup:nil];
    if ([keychain objectForKey:(__bridge id)kSecAttrService]) {
        NSString * valueStr = [keychain objectForKey:(__bridge id)kSecAttrService];
        return valueStr;
    }
    return @"";
}

/* 获取当前设备的UDID-存储到KeyChain中  */
+ (NSString *)getDeviceUDIDValueFromKeychainInNWF {
    NWFKeychainItemWrapper *keychain = [[NWFKeychainItemWrapper alloc]initWithIdentifier:kNwfInKeychainItemIndentifier accessGroup:nil];
    NSString *udidvalue = [keychain objectForKey:(__bridge id)kSecAttrLabel];
    if ( udidvalue.length != 0 ) {
        return udidvalue;
    }else{
        NSString *udidstr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keychain setObject:udidstr forKey:(__bridge id)kSecAttrLabel];
        return udidstr;
    }
}
// get current设备的idfa
+ (NSString *)nwfGetDeviceIDFA {
    NWFKeychainItemWrapper *keychain = [[NWFKeychainItemWrapper alloc]initWithIdentifier:kNwfInKeychainItemIndentifier accessGroup:nil];
    NSString *idfaValue = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    if ( idfaValue.length != 0 ) {
        return idfaValue;
    }else{
        NSString *idfastr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [keychain setObject:idfastr forKey:(__bridge id)kSecAttrAccount];
        return idfastr;
    }
}

// 获取手机品牌
+ (NSString *)nwfGetDeviceBand {
    return [[UIDevice currentDevice]model];
}

// 获取网络名称
+ (NSString *)nwfGetDeviceNetworkStatus
{
    NSString *netconnType = @"";
    
    NWFReachability *reach = [NWFReachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case NWFNotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case NWFReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case NWFReachableViaWWAN: // 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            
            NSString *currentStatus = info.currentRadioAccessTechnology;
            
            if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]) {
                
                netconnType = @"GPRS";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]) {
                
                netconnType = @"2.75G EDGE";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
                
                netconnType = @"3.5G HSDPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
                
                netconnType = @"3.5G HSUPA";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
                
                netconnType = @"2G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
                
                netconnType = @"3G";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
                
                netconnType = @"HRPD";
            }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
                
                netconnType = @"4G";
            }
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
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


// 运营商名称
+ (NSString *)getDeviceCarrierName {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if(!carrier){
        return  @"";
    }
    NSString *carrierName = [carrier carrierName];
    if( [self isHaveString:carrierName] == NO ){
        return @"";
    }
    return carrierName;
}
// 运营商
+ (NSString *)getDeviceCarrier {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if(!carrier){
        return  @"";
    }
    NSString *mobileCountryCode = carrier.mobileCountryCode;
    if ( [self isHaveString:mobileCountryCode] == NO ) {
        mobileCountryCode = @"";
    }
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
    if ([self isHaveString:mobileCountryCode] == NO ) {
        mobileNetworkCode  = @"";
    }
    return  [NSString stringWithFormat:@"%@%@",mobileCountryCode,mobileNetworkCode];
}
// 地区
+ (NSString *)getDeviceRegion {
    // iOS 获取设备当前地区的代码
    NSString *region = [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier];
    NSArray * strArr = [region componentsSeparatedByString:@"_"];
    if (strArr.count>1) {
        return strArr[1];
    }else{
        return strArr[0];
    }
}

// 设备运行系统名称 -- 即iOS
+ (NSString *)getDeviceOSName {
    return [[UIDevice currentDevice] systemName];
}
/* 当前设备名称--即用户可在设置中自定义的名称     */
+ (NSString *)getDeviceName {
    return [[UIDevice currentDevice] name];
}

+ (BOOL)isHaveString:(NSString *)string {
    if (string == nil || string == NULL){
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([string isEqualToString:@""]       ||
        [string isEqualToString:@"null"]   ||
        [string isEqualToString:@"<NULL>"] ||
        [string isEqualToString:@"<null>"] ||
        [string isEqualToString:@"NULL"]   ||
        [string isEqualToString:@"nil"]    ||
        [string isEqualToString:@"(null)"] ) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

#pragma mark - get system languages
/**   en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ...... */
+ (NSString*)getPreferredLanguage {
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    if ( (preferredLang.length>=2) && ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"en"]) ) {
        return @"en";
    }else if ((preferredLang.length>=7) && ([[preferredLang substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"zh-Hans"]) ) {
        return @"zh-Hans";
    } else if ((preferredLang.length>=7) && ([[preferredLang substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"zh-Hant"]) ) {
        return @"zh-Hant";
    }else if ((preferredLang.length>=2)&& ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ja"]) ) {
        return @"ja";
    }else if ((preferredLang.length>=2)&& ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ko"]) ) {
        return @"ko";
    }else if ((preferredLang.length>=2)&& ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"ru"]) ) {
        return @"ru";
    }else if ((preferredLang.length>=2)&& ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"de"]) ) {
        return @"de";
    }else if ((preferredLang.length>=2)&& ([[preferredLang substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"fr"]) ) {
        return @"fr";
    }
    else{
        return @"en";
    }
    return preferredLang;
}




@end


