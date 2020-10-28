////  BASDKSystemMgr.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BASDKSystemMgr : NSObject

// get app config
+ (NSString *)getAppBundleId;
+ (NSString *)getAppDisplayName;
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;
// 获取手机品牌
+ (NSString *)getDeviceBand;
// 获取当前设备的操作系统版本号
+ (NSString *)getDeviceOSVersion;


#pragma mark - 获取UDID + idfa
// 获取当前设备的UDID-存储到KeyChain中
+ (NSString *)getDeviceUDIDValueFromKeychain;
// get current设备的idfa
+ (NSString *)getDeviceIDFA;
// save public service token
+ (void)setKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getKeyChainPublicServiceToken;


#pragma mark - 获取网络类型
+ (NSString *)getDeviceNetworkStatus;
#pragma mark -  获取设备型号
+ (NSString*)getDeviceType;



@end

NS_ASSUME_NONNULL_END
