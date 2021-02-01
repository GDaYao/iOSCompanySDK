////  NSDictionary+VCSDKDictionary.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (VCSDKDictionary)


- (id)VCSDKSafetyDictionaryObjectForKey:(NSString *)key;


+ (BOOL)VCSDKClassObjectIsNull:(id)judgeClassObject;

@end

NS_ASSUME_NONNULL_END
