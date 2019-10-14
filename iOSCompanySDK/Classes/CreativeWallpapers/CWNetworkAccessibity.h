

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



extern NSString * const CWNetworkAccessibityChangedNotification;


typedef NS_ENUM(NSUInteger, CWNetworkAccessibleState) {
    NetworkChecking  = 0,
    NetworkUnknown     ,
    NetworkAccessible  ,
    NetworkRestricted  ,
};

typedef void (^CWNetworkAccessibleStateNotifier)(CWNetworkAccessibleState state);

@interface CWNetworkAccessibity : NSObject

// 网络权限监听
+ (void)cwSetStateDidUpdateNotifier:(void (^)(CWNetworkAccessibleState))block;

+ (void)stop;

+ (void)start;


+ (CWNetworkAccessibleState)currentState;



@end

NS_ASSUME_NONNULL_END
