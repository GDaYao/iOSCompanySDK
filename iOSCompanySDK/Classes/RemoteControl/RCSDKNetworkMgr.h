////  RCSDKNetworkMgr.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface RCSDKNetworkMgr : NSObject



#pragma mark - 'POST' net request data
+ (void)RCSDKAFHttpDataTaskPOSTMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters successBlock:(void (^)(id _Nullable responseObject))successBlock failureBlock:(void (^)(NSError * _Nullable error))failureBlock;


#pragma mark  - 'GET' net request data ----
+ (void)RCSDKAFHttpDataTaskGETMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure;



#pragma mark - afnet implete download
+ (void)RCSDKCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;


@end

NS_ASSUME_NONNULL_END
