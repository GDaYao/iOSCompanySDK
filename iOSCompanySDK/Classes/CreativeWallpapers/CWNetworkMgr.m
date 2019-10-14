
#import "CWNetworkMgr.h"
#import <AFNetworking/AFNetworking.h>


@implementation CWNetworkMgr


+ (void)CWAFHttpDataTaskPostWithURLString:(NSString *)URLString
                               parameters:(id)parameters
                                  success:(void (^)(id _Nullable responseObject))success
                                  failure:(void (^)(NSError * _Nullable error))failure {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    sessionMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
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
