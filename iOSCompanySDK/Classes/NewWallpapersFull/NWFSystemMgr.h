////  NWFSystemMgr.h
//  iOSCompanySDK
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



#pragma mark - get system languages/ 获的当前系统使用语言
/**
 多语言适配中使用，有些地区因为使用语言相通但是语言代码不同，如zh-Hans，还有zh_Hans-CN则只使用前面匹配即可
 
 @return 返回多语言代码.
 */
+ (NSString*)getPreferredLanguage;



@end

NS_ASSUME_NONNULL_END
