////  VPSDKNetworkMgr.m
//  iOSCompanySDK
//
//  Created on 2020/4/24.
//  
//

#import "VPSDKNetworkMgr.h"
#import <AFNetworking/AFNetworking.h>


@implementation VPSDKNetworkMgr

#pragma mark - 'POST' net request data
+ (void)VPAFHttpDataTaskPostMethodWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                      success:(void (^)(id _Nullable responseObject))success
                                             failure:(void (^)(NSError * _Nullable error))failure {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
       sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", @"text/plain",@"charset=utf-8",nil];
       sessionMgr.requestSerializer.timeoutInterval = 6.f; // 60.0s request->response default time out
       [sessionMgr POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (responseObject) {
               success(responseObject);
           }else{
               NSString *domain = @"domain with response object null";
               NSString *desc = NSLocalizedString(@"response object null", @"response object null");
               NSDictionary *userInfo = [NSDictionary dictionaryWithObject:desc forKey:NSLocalizedDescriptionKey];
               NSError *error = [NSError errorWithDomain:domain code:0000 userInfo:userInfo];
               failure(error);
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           failure(error);
       }];
}




#pragma mark - AFNet implete 'download'
+ (void)VPCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    if (parameters) {
        downloadStr = [downloadStr stringByAppendingString:parameters];
    }
    NSURLRequest *request = nil;
    if (ticketStr.length != 0) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableURLRequest *requestOne = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadStr parameters:nil error:nil];
        [requestOne setValue:ticketStr forHTTPHeaderField:@"ticket"];
        request = requestOne;
    }else{
        NSURL *URL = [NSURL URLWithString:downloadStr];
        NSURLRequest *requestTwo = [NSURLRequest requestWithURL:URL];
        request = requestTwo;
    }
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress){
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        if (specifilyPath) {
            path = specifilyPath;
        }
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        destination(targetPath);
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        completionHandler(filePath,error);
    }];
    [downloadTask resume];
}



@end



