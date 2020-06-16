////  VRSDKNetworkMgr.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VRSDKNetworkMgr : NSObject




// 'GET' net request data
+ (void)VRSDKAFHttpDataTaskGETMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure;

// 'POST' net request data
+ (void)VRSDKAFHttpDataTaskPOSTMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters successBlock:(void (^)(id _Nullable responseObject))successBlock failureBlock:(void (^)(NSError * _Nullable error))failureBlock;

// net implete download
+ (void)VRSDKCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;






@end

NS_ASSUME_NONNULL_END
