////  NPTSDKSystemMgr.h
//  iOSCompanySDK
//  Created on 2019/11/15.
//

/** func: system mgr.
 *
 */




#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPTSDKSystemMgr : NSObject



+ (NSString *)nptGetAppVersion;
+ (NSString *)nptGetAppBundleId;
+ (NSString *)nptGetAppDisplayName;

+ (NSString *)nptsdkGetDeviceUDIDValueFromKeychain;
+ (NSString *)nptsdkGetDeviceIDFA;

+ (NSString *)nptsdkGetDeviceNetworkStatus;

// 获取设备型号
+ (NSString*)nptsdkGetDeviceType;

// 设备品牌
+ (NSString *)nptsdkGetDeviceBand;

// 获取当前设备操作系统版本号
+ (NSString *)nptsdkGetDeviceOSVersion;

// 获取系统语言码
+ (NSString*)nptsdkGetPreferredLanguage;

@end

NS_ASSUME_NONNULL_END
