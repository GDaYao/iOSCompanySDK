////  NPTSDKNetworkMgr.m
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  
//

#import "NPTSDKNetworkMgr.h"
#import <AFNetworking/AFNetworking.h>

@implementation NPTSDKNetworkMgr


// TODO:数据请求
+ (void)NPTSDKAFHttpDataTaskPostMethodWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    // 下面这个属性，大多用在加密返回参数中使用;
    //sessionMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", @"text/plain",@"charset=utf-8",nil];
    sessionMgr.requestSerializer.timeoutInterval = 60.f;
    [sessionMgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}

@end
