////  BASDKNetworkMgr.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface BASDKNetworkMgr : NSObject



#pragma mark - 'POST' net request data
+ (void)BASDKAFHttpDataTaskPOSTMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters successBlock:(void (^)(id _Nullable responseObject))successBlock failureBlock:(void (^)(NSError * _Nullable error))failureBlock;


#pragma mark  - 'GET' net request data ----
+ (void)BASDKAFHttpDataTaskGETMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure;



#pragma mark - afnet implete download
+ (void)BASDKCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;


@end

NS_ASSUME_NONNULL_END
