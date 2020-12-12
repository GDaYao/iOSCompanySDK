
#import "CWSystemMgr.h"
#import "CWKeychainItemWrapper.h"

// 获取当前设备型号名称
#import "sys/utsname.h"


#import <AdSupport/AdSupport.h>


#import "CWReachability.h"


#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#define kCWKeychainItemIdentifier  @"CWKeychainItemIdentifier"



@implementation CWSystemMgr

#pragma mark - get app config
+ (NSString *)getAppVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)getAppBuildVersion {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleVersion"];
}
+ (NSString *)getAppBundleId {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleIdentifier"];
}
+ (NSString *)getAppDisplayName {
    NSBundle *currentBundle = [NSBundle mainBundle];
    NSDictionary *infoDictionary = [currentBundle infoDictionary];
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (appName.length==0 || appName ==nil) {
        appName =    [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    }
    return appName;
}


#pragma mark - get device config
+ (NSString *)getDeviceUDIDValueFromKeychain {
    CWKeychainItemWrapper *keyChainWrapper = [[CWKeychainItemWrapper alloc] initCWWithIdentifier:kCWKeychainItemIdentifier accessGroup:nil];
    NSString *udidvalue = [keyChainWrapper cwObjectForKey:(__bridge id)kSecAttrLabel];
    if ( udidvalue.length != 0 ) {
        return udidvalue;
    }else{
        NSString *udidstr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keyChainWrapper cwSetObject:udidstr forKey:(__bridge id)kSecAttrLabel];
        return udidstr;
    }
}
+ (NSString *)getIDFAValueFromKeychain {
    CWKeychainItemWrapper *keyChainWrapper = [[CWKeychainItemWrapper alloc]initCWWithIdentifier:kCWKeychainItemIdentifier accessGroup:nil];
    NSString *idfaValue = [keyChainWrapper cwObjectForKey:(__bridge id)kSecAttrAccount];
    if ( idfaValue.length != 0 ) {
        return idfaValue;
    }else{
        NSString *idfastr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [keyChainWrapper cwSetObject:idfastr forKey:(__bridge id)kSecAttrAccount];
        return idfastr;
    }
}
// save public service token
+ (void)setCwKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject {
    
    CWKeychainItemWrapper *keychain = [[CWKeychainItemWrapper alloc]initCWWithIdentifier:kCWKeychainItemIdentifier accessGroup:nil];
    NSString *keychainValue = [keychain cwObjectForKey:(__bridge id)kSecAttrService];
    if (keychainValue.length != 0) {
    }else{
        [keychain cwSetObject:saveObject forKey:(__bridge id)kSecAttrService];
    }
}
+ (NSString *)getCwKeyChainPublicServiceToken {
    CWKeychainItemWrapper *keychain = [[CWKeychainItemWrapper alloc]initCWWithIdentifier:kCWKeychainItemIdentifier accessGroup:nil];
    if ([keychain cwObjectForKey:(__bridge id)kSecAttrService]) {
        NSString * valueStr = [keychain cwObjectForKey:(__bridge id)kSecAttrService];
        return valueStr;
    }
    return @"";
}



// need import  "sys/utsname.h"
+ (NSString *)getDeviceModel {
    NSString *platform = nil;
    struct utsname systemInfo;
    uname(&systemInfo);
    platform = [NSString stringWithCString:systemInfo.machine
                                  encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@",platform];
}


+ (NSString*)getDeviceType {
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
    
    // iPhone 11 ++
    if([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE(2ed generation)";
    
    // iPhone 12 ++
    if([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12  Pro";
    if([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12  Pro Max";
    
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
    }else{
        return @"en";
    }
    return preferredLang;
}

// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}
// 当前设备名称
+ (NSString *)getDeviceName {
    return [[UIDevice currentDevice] name];
}
// 获取手机品牌
+ (NSString *)getDeviceBand {
    return [[UIDevice currentDevice] model];
}
+ (NSString *)getDeviceLocalizedModel {
    return [[UIDevice currentDevice] localizedModel];
}
// 设备运行系统名称 -- iOS
+ (NSString *)getDeviceSystemName {
    return [[UIDevice currentDevice] systemName];
}



// 运营商名称
+ (NSString *)getDeviceCarrierName {
    CTTelephonyNetworkInfo *info = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if(!carrier){
        return  @"";
    }
    NSString *carrierName = [carrier carrierName];
    if( [self isCWHaveString:carrierName] == NO ){
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
    if ( [self isCWHaveString:mobileCountryCode] == NO ) {
        mobileCountryCode = @"";
    }
    NSString *mobileNetworkCode = carrier.mobileNetworkCode;
    if ([self isCWHaveString:mobileCountryCode] == NO ) {
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



// 获取网络名称
+ (NSString *)cwGetDeviceNetworkStatus
{
    NSString *netconnType = @"";
    
    CWReachability *reach = [CWReachability reachabilityWithHostName:@"www.apple.com"];
    
    switch ([reach currentReachabilityStatus]) {
        case CWNotReachable:// 没有网络
        {
            
            netconnType = @"no network";
        }
            break;
            
        case CWReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
            
        case CWReachableViaWWAN: // 手机自带网络
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

+ (BOOL)isCWHaveString:(NSString *)cwstring {
    if (cwstring == nil || cwstring == NULL){
        return NO;
    }
    if ([cwstring isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([cwstring isEqualToString:@""]       ||
        [cwstring isEqualToString:@"null"]   ||
        [cwstring isEqualToString:@"<NULL>"] ||
        [cwstring isEqualToString:@"<null>"] ||
        [cwstring isEqualToString:@"NULL"]   ||
        [cwstring isEqualToString:@"nil"]    ||
        [cwstring isEqualToString:@"(null)"] ) {
        return NO;
    }
    if ([[cwstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}



@end



