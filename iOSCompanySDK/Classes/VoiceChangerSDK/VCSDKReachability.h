////  VCSDKReachability.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>



NS_ASSUME_NONNULL_BEGIN


#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif


extern NSString *const kVCSDKReachabilityChangedNotification;


typedef NS_ENUM(NSInteger, VCNetworkStatus) {
    VCNotReachable = 0,
    VCReachableViaWiFi = 2,
    VCReachableViaWWAN = 1
};


@interface VCSDKReachability : NSObject

@property (nonatomic,copy)void(^VCNetworkReachable)(VCSDKReachability *reachability);
@property (nonatomic,copy)void(^VCNetworkUnreachable)(VCSDKReachability *reachability);


@property (nonatomic, assign) BOOL reachableOnWWAN;


+ (VCSDKReachability*)reachabilityWithHostname:(NSString*)hostname;
// 下面这个方法与上面一样但是需要保留
+ (VCSDKReachability*)reachabilityWithHostName:(NSString*)hostname;

- (VCNetworkStatus)currentReachabilityStatus;







@end

NS_ASSUME_NONNULL_END






