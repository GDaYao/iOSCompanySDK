////  BASDKSystemMgr.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BASDKSystemMgr : NSObject


+ (NSString *)getAppBundleId;
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;
+ (NSString *)getAppDsisplayNameWithIsInternational:(BOOL)isInternational;
+ (NSString *)getDeviceOSVersion;
+ (NSString *)getDeviceBand;
+ (NSString *)getDeviceRegion;
+ (NSString *)getDeviceOSName;
+ (NSString *)getDeviceCarrierName;
+ (NSString *)getDeviceCarrier;
+ (NSString *)getDeviceName;

//
+ (void)setKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getKeyChainPublicServiceToken;

+ (NSString *)getDeviceUDIDValueFromKeychain;
+ (NSString *)getDeviceIDFA;
//
+ (NSString *)getDeviceNetworkStatus;
//
+ (NSString*)getDeviceType;
//
+ (NSString*)getPreferredLanguage;



@end

NS_ASSUME_NONNULL_END



