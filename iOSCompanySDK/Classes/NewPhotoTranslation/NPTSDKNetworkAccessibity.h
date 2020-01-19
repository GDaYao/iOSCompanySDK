////  NPTSDKNetworkAccessibity.h
//



/** func:  网络权限获取监听
 *
 */

#import <Foundation/Foundation.h>


extern NSString * const nptNetworkAccessibityChangedNotification;

typedef NS_ENUM(NSUInteger, ZYNetworkAccessibleState) {
    ZYNetworkChecking  = 0,
    ZYNetworkUnknown     ,
    ZYNetworkAccessible  ,
    ZYNetworkRestricted  ,
};

typedef void (^NetworkAccessibleStateNotifier)(ZYNetworkAccessibleState state);


NS_ASSUME_NONNULL_BEGIN

@interface NPTSDKNetworkAccessibity : NSObject

+ (void)start;


+ (void)stop;

+ (void)setStateDidUpdateNotifier:(void (^)(ZYNetworkAccessibleState))block;

+ (ZYNetworkAccessibleState)currentState;



@end

NS_ASSUME_NONNULL_END
