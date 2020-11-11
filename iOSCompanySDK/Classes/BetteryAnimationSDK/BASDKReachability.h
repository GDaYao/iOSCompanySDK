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
// 下面这个方法与上面一样但是需要保留
+(BASDKReachability*)reachabilityWithHostName:(NSString*)hostname;

- (BANetworkStatus)currentReachabilityStatus;






@end

NS_ASSUME_NONNULL_END

