////  VPSDKReachability.h
//  iOSCompanySDK
//
//  Created on 2020/4/24.
//  
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// 注意const常量这里的监听名已改变
extern NSString *const kVPReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, VPNetworkStatus) {
    VPNotReachable = 0,
    VPReachableViaWiFi = 2,
    VPReachableViaWWAN = 1
};

@class VPSDKReachability;

typedef void (^VPNetworkReachable)(VPSDKReachability * reachability);
typedef void (^VPNetworkUnreachable)(VPSDKReachability * reachability);

@interface VPSDKReachability : NSObject

@property (nonatomic, copy) VPNetworkReachable    reachableBlock;
@property (nonatomic, copy) VPNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(VPSDKReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(VPSDKReachability*)reachabilityWithHostName:(NSString*)hostname;
+(VPSDKReachability*)reachabilityForInternetConnection;
+(VPSDKReachability*)reachabilityWithAddress:(void *)hostAddress;
+(VPSDKReachability*)reachabilityForLocalWiFi;

-(VPSDKReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(VPNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;


@end

NS_ASSUME_NONNULL_END
