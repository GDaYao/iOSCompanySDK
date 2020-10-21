////  NSDictionary+BASDKDictionary.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BASDKDictionary)



// 取字典元素
- (id)BASDKDicSafetyObjectForKey:(NSString *)key;



@end

NS_ASSUME_NONNULL_END
