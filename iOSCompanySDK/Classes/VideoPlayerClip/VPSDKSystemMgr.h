////  VPSDKSystemMgr.h
//  iOSCompanySDK
//
//  Created on 2020/4/24.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VPSDKSystemMgr : NSObject

#pragma mark - get app config
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;
+ (NSString *)getAppBundleId;
+ (NSString *)getAppDisplayName;
// 获取当前设备的UDID-存储到KeyChain中
+ (NSString *)getDeviceUDIDValueFromKeychain;
// get current设备的idfa
+ (NSString *)getDeviceIDFA;
// 获取手机品牌
+ (NSString *)getDeviceBand;
// 获取网络名称
+ (NSString *)getDeviceNetworkStatus;
// 获取设备型号
+ (NSString*)getDeviceType;
// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersion;


#pragma mark - get system languages
+ (NSString*)getPreferredLanguage;


@end

NS_ASSUME_NONNULL_END


