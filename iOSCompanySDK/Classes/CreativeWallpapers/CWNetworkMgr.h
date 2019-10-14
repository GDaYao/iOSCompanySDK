

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWNetworkMgr : NSObject


+ (void)CWAFHttpDataTaskPostWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                      success:(void (^)(id _Nullable responseObject))success
                                      failure:(void (^)(NSError * _Nullable error))failure;




@end

NS_ASSUME_NONNULL_END
