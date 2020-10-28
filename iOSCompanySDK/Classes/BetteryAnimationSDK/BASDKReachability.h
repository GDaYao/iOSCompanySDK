////  BASDKReachability.h
//  BetteryAnimationSDK
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
extern NSString *const kBASDKReachabilityChangedNotification;


typedef NS_ENUM(NSInteger, BANetworkStatus) {
    BANotReachable = 0,
    BAReachableViaWiFi = 2,
    BAReachableViaWWAN = 1
};


@class BASDKReachability;

typedef void (^BANetworkReachable)(BASDKReachability * reachability);
typedef void (^BANetworkUnreachable)(BASDKReachability * reachability);

@interface BASDKReachability : NSObject

@property (nonatomic, copy) BANetworkReachable    reachableBlock;
@property (nonatomic, copy) BANetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(BASDKReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+ (BASDKReachability*)reachabilityWithHostName:(NSString*)hostname;
+ (BASDKReachability*)reachabilityForInternetConnection;
+ (BASDKReachability*)reachabilityWithAddress:(void *)hostAddress;
+ (BASDKReachability*)reachabilityForLocalWiFi;

-(BASDKReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

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

-(BANetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;





@end

NS_ASSUME_NONNULL_END

