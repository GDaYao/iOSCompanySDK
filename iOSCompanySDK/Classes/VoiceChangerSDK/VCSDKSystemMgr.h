////  VCSDKSystemMgr.h
//  iOSCompanySDK
//
//  Created on 2021/1/27.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSDKSystemMgr : NSObject


// get app config
+ (NSString *)getAppBundleId;
+ (NSString *)getAppDsisplayNameWithIsInternational:(BOOL)isInternational;
+ (NSString *)getAppVersion;
+ (NSString *)getAppBuildVersion;
+ (NSString *)getDeviceBand;
+ (NSString *)getDeviceOSVersion;


//
+ (NSString *)getDeviceUDIDValueFromKeychain;
// idfa
+ (NSString *)getDeviceIDFA;

// save or get
+ (void)setKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getKeyChainPublicServiceToken;


+ (NSString *)getDeviceCarrierName;
+ (NSString *)getDeviceCarrier;
+ (NSString *)getDeviceRegion;

+ (NSString *)getDeviceOSName;
+ (NSString *)getDeviceName;
+ (BOOL)isHaveString:(NSString *)string;
+ (NSString *)getDeviceNetworkStatus;

+ (NSString*)getDeviceType;




@end

NS_ASSUME_NONNULL_END
