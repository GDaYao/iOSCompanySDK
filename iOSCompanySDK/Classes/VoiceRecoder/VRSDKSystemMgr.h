////  VRSDKSystemMgr.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//


/** func: system mgr
 *
 *
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VRSDKSystemMgr : NSObject


// get app config
+ (NSString *)getAppBundleId;
+ (NSString *)getAppDisplayName;
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;

// 获取手机品牌
+ (NSString *)getDeviceBand;
// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersion;


// 运营商名称
+ (NSString *)getDeviceCarrierName;
// 运营商
+ (NSString *)getDeviceCarrier;
// 地区
+ (NSString *)getDeviceRegion;
// 设备运行系统名称 -- 即iOS
+ (NSString *)getDeviceOSName;
// 当前设备名称--即用户可在设置中自定义的名称     
+ (NSString *)getDeviceName;


// save public service token
+ (void)setKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getKeyChainPublicServiceToken;

//  get system languages
+ (NSString*)getPreferredLanguage;

// 获取当前设备的UDID-存储到KeyChain中
+ (NSString *)getDeviceUDIDValueFromKeychain;

// get current设备的idfa
+ (NSString *)getDeviceIDFA;

// 获取网络类型
+ (NSString *)getDeviceNetworkStatus;


// 获取设备型号
+ (NSString*)getDeviceType;


@end

NS_ASSUME_NONNULL_END



