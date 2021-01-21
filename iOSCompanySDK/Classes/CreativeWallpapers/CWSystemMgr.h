

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWSystemMgr : NSObject


#pragma mark - get app config
+ (NSString *)getAppVersion;

+ (NSString *)getAppBuildVersion;

+ (NSString *)getAppBundleId;

+ (NSString *)getAppDsisplayName;


#pragma mark - get device config

+ (NSString *)getDeviceUDIDValueFromKeychain;
+ (NSString *)getIDFAValueFromKeychain;
// save public service token
+ (void)setCwKeyChainPublicServiceTokenWithSaveObject:(NSString *)saveObject;
+ (NSString *)getCwKeyChainPublicServiceToken;


+ (NSString *)getDeviceModel;

+ (NSString*)getDeviceType;

+ (NSString *)getDeviceOSVersion;

+ (NSString *)getDeviceName;

+ (NSString *)getDeviceBand;

+ (NSString *)getDeviceLocalizedModel;

+ (NSString *)getDeviceSystemName;


#pragma mark - get system languages/ 获的当前系统使用语言
+ (NSString*)getPreferredLanguage;

// 运营商名称
+ (NSString *)getDeviceCarrierName;
// 运营商
+ (NSString *)getDeviceCarrier;
// 地区
+ (NSString *)getDeviceRegion;
// 获取网络名称
+ (NSString *)cwGetDeviceNetworkStatus;




@end

NS_ASSUME_NONNULL_END
