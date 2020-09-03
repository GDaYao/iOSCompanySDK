

// network status judge


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>


NS_ASSUME_NONNULL_BEGIN

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// 注意const常量这里的监听名已改变
extern NSString *const kReachabilityChangedNotificationInCW;

typedef NS_ENUM(NSInteger, CWNetworkStatus) {
    
    CWNotReachable = 0,
    CWReachableViaWiFi = 2,
    CWReachableViaWWAN = 1
};

@class CWReachability;

typedef void (^CWNetworkReachable)(CWReachability * reachability);
typedef void (^CWNetworkUnreachable)(CWReachability * reachability);

@interface CWReachability : NSObject


@property (nonatomic, copy) CWNetworkReachable    reachableBlock;
@property (nonatomic, copy) CWNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(CWReachability*)reachabilityWithHostname:(NSString*)hostname;

+(CWReachability*)reachabilityWithHostName:(NSString*)hostname;
+(CWReachability*)reachabilityForInternetConnection;
+(CWReachability*)reachabilityWithAddress:(void *)hostAddress;
+(CWReachability*)reachabilityForLocalWiFi;

-(CWReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;


-(BOOL)isConnectionRequired;
-(BOOL)connectionRequired;

-(BOOL)isConnectionOnDemand;

-(BOOL)isInterventionRequired;

-(CWNetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;




@end

NS_ASSUME_NONNULL_END
