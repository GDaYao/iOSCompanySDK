

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// 注意const常量这里的监听名已改变
extern NSString *const kReachabilityChangedNotificationInNWF;

typedef NS_ENUM(NSInteger, NWFNetworkStatus) {
    NWFNotReachable = 0,
    NWFReachableViaWiFi = 2,
    NWFReachableViaWWAN = 1
};

@class NWFReachability;


typedef void (^NWFNetworkReachable)(NWFReachability * reachability);
typedef void (^NWFNetworkUnreachable)(NWFReachability * reachability);


@interface NWFReachability : NSObject

@property (nonatomic, copy) NWFNetworkReachable    reachableBlock;
@property (nonatomic, copy) NWFNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(NWFReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(NWFReachability*)reachabilityWithHostName:(NSString*)hostname;
+(NWFReachability*)reachabilityForInternetConnection;
+(NWFReachability*)reachabilityWithAddress:(void *)hostAddress;
+(NWFReachability*)reachabilityForLocalWiFi;

-(NWFReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

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

-(NWFNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;




@end
