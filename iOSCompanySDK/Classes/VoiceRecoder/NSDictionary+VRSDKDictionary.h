////  NSDictionary+VRSDKDictionary.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

/** func: safety NSDictionary
 *
 *
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VRSDKDictionary)


// 字典取字典元素
- (id)vrsdkDicSafetyObjectForKey:(NSString *)key;



@end

NS_ASSUME_NONNULL_END
