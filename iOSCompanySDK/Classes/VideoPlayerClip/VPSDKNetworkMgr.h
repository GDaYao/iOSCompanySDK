////  VPSDKNetworkMgr.h
//  iOSCompanySDK
//
//  Created on 2020/4/24.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VPSDKNetworkMgr : NSObject

#pragma mark - 'POST' net request data
+ (void)VPAFHttpDataTaskPostMethodWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                      success:(void (^)(id _Nullable responseObject))success
                                      failure:(void (^)(NSError * _Nullable error))failure;

#pragma mark - AFNet implete 'download'
+ (void)VPCreateDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress destination:(void(^)(NSURL *targetPath))destination completionHandler:(void (^)(NSURL *filePath, NSError *error))completionHandler;



@end

NS_ASSUME_NONNULL_END
