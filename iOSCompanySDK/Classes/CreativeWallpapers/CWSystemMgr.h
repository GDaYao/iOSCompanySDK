

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWSystemMgr : NSObject


#pragma mark - get app config
+ (NSString *)getAppVersion;

+ (NSString *)getAppBuildVersion;

+ (NSString *)getAppBundleId;

+ (NSString *)getAppDisplayName;


#pragma mark - get device config
+ (NSString *)getDeviceUDIDValueString;

+ (NSString *)getDeviceUDIDValueFromKeychain;


+ (NSString *)getDeviceModel;

+ (NSString*)getDeviceType;

+ (NSString *)getDeviceOSVersion;

+ (NSString *)getDeviceName;

+ (NSString *)getDeviceBand;

+ (NSString *)getDeviceLocalizedModel;

+ (NSString *)getDeviceSystemName;


#pragma mark - get system languages/ 获的当前系统使用语言
+ (NSString*)getPreferredLanguage;




@end

NS_ASSUME_NONNULL_END
