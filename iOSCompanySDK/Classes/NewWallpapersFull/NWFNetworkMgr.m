////  NWFNetworkMgr.m
//  
//
//  Created on 2019/8/15.
//  
//

#import "NWFNetworkMgr.h"
#import <AFNetworking/AFNetworking.h>

@implementation NWFNetworkMgr


#pragma mark ---- 'POST' net request data ----
+ (void)AFHttpDataTaskPostMethodInNWFWithURLString:(NSString *)URLString
                                        parameters:(id)parameters
                                           success:(void (^)(id _Nullable responseObject))success
                                           failure:(void (^)(NSError * _Nullable error))failure {
    AFHTTPSessionManager *sessionMgr = [AFHTTPSessionManager manager];
    sessionMgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", @"text/plain",@"charset=utf-8",nil];
    sessionMgr.requestSerializer.timeoutInterval = 6.f; // 60.0s request->response default time out
    [sessionMgr POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            success(responseObject);
            // in this success,you can add NSNotificationCenter to refresh view when data update
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"requestSuccessRefreshData" object:nil];
        }else{
            NSString *domain = @"domain with response object null";
            NSString *desc = NSLocalizedString(@"response object null", @"response object null");
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
            NSError *error = [NSError errorWithDomain:domain code:-0000 userInfo:userInfo];
            failure(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"requestFailureShowAlert" object:nil];
    }];
}


#pragma mark - AFNet implete 'download'
+ (void)createDownloadTaskInNWFWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler {
    // 1. create manager
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    // 2. create request object
    if (parameters) {
        downloadStr = [downloadStr stringByAppendingString:parameters];
    }
    // 3. or set http header "ticket"
    NSURLRequest *request = nil;
    if (ticketStr.length != 0) {
        // if you request set http header,need use `NSMutableURLRequest`
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableURLRequest *requestOne = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:downloadStr parameters:nil error:nil];
        // test -- NSString *ticketStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"ticket"];
        [requestOne setValue:ticketStr forHTTPHeaderField:@"ticket"];
        request = requestOne;
    }else{
        NSURL *URL = [NSURL URLWithString:downloadStr];
        NSURLRequest *requestTwo = [NSURLRequest requestWithURL:URL];
        request = requestTwo;
    }
    
    // 4. download file
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress){
        // test teset teste
        progress(downloadProgress);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // test teset teste
        if (specifilyPath) {
            // test teset teste
            path = specifilyPath;
        }
        // test teset teste
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        destination(targetPath);
        // test teset teste
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        completionHandler(filePath,error);
    }];
    [downloadTask resume];
}






@end
