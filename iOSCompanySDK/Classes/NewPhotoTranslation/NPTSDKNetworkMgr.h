////  NPTSDKNetworkMgr.h
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPTSDKNetworkMgr : NSObject


// TODO:数据请求
+ (void)NPTSDKAFHttpDataTaskPostMethodWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
