////  NSDictionary+VPSafetyDictionary.h
//  iOSCompanySDK
//



/** func: NSDictionary 安全字典使用
*
*/



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VPSafetyDictionary)


// 取字典元素
- (id)vpSafetyObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
