////  NWFSystemMgr.h
//  
//
//  Created on 2019/8/15.
//  
//


/** func: 系统方法使用
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWFSystemMgr : NSObject


#pragma mark - get app config

/*获取当前App的版本号信息*/
+ (NSString *)getAppVersion;
/*获取当前App的build版本号信息*/
+ (NSString *)getAppBuildVersion;
/*获取当前App的包名信息*/
+ (NSString *)getAppBundleId;
/*获取当前App的名称信息*/
+ (NSString *)getAppDisplayName;

// 获取设备型号
+ (NSString*)getDeviceTypeInNWF;
// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersionInNWF;

// save public service token
+ (void)setNWfKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getNwfKeyChainPublicServiceToken;
// 获取当前设备的UDID-存储到KeyChain中
+ (NSString *)getDeviceUDIDValueFromKeychainInNWF;
// get current设备的idfa
+ (NSString *)nwfGetDeviceIDFA;

// 获取手机品牌
+ (NSString *)nwfGetDeviceBand;
// 获取网络名称
+ (NSString *)nwfGetDeviceNetworkStatus;

// 运营商名称
+ (NSString *)getDeviceCarrierName;
// 运营商
+ (NSString *)getDeviceCarrier;
// 地区
+ (NSString *)getDeviceRegion;
// 设备运行系统名称 -- 即iOS
+ (NSString *)getDeviceOSName;
/* 当前设备名称--即用户可在设置中自定义的名称     */
+ (NSString *)getDeviceName;


#pragma mark - get system languages/ 获的当前系统使用语言
/**
 多语言适配中使用，有些地区因为使用语言相通但是语言代码不同，如zh-Hans，还有zh_Hans-CN则只使用前面匹配即可
 
 @return 返回多语言代码.
 */
+ (NSString*)getPreferredLanguage;



@end

NS_ASSUME_NONNULL_END
