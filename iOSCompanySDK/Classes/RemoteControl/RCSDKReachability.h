////  RCSDKReachability.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>



NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// 注意const常量这里的监听名已改变
extern NSString *const kRCSDKReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};


@class RCSDKReachability;

typedef void (^NetworkReachable)(RCSDKReachability * reachability);
typedef void (^NetworkUnreachable)(RCSDKReachability * reachability);

@interface RCSDKReachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(RCSDKReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+ (RCSDKReachability*)reachabilityWithHostName:(NSString*)hostname;
+ (RCSDKReachability*)reachabilityForInternetConnection;
+ (RCSDKReachability*)reachabilityWithAddress:(void *)hostAddress;
+ (RCSDKReachability*)reachabilityForLocalWiFi;

-(RCSDKReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(NetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;





@end

NS_ASSUME_NONNULL_END

