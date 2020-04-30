////  NSDictionary+RCSDKDictionary.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RCSDKDictionary)



// 取字典元素
- (id)RCSDKDicSafetyObjectForKey:(NSString *)key;



@end

NS_ASSUME_NONNULL_END
