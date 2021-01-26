////  VCSDKNetworkMgr.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface VCSDKNetworkMgr : NSObject


// post
+ (void)VCSDKAFHttpDataTaskPOSTMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters successBlock:(void (^)(id _Nullable responseObject))successBlock failureBlock:(void (^)(NSError * _Nullable error))failureBlock;

// get
+ (void)VCSDKAFHttpDataTaskGETMethodWithUrlString:(NSString *)UrlString parameters:(id)parameters success:(void (^)(id _Nullable responseObject))success failure:(void (^)(NSError * _Nullable error))failure;


//  download
+ (void)VCSDKCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;




@end

NS_ASSUME_NONNULL_END
