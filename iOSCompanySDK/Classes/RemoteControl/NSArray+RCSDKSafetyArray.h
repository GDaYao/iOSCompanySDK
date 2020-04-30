////  NSArray+RCSDKSafetyArray.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (RCSDKSafetyArray)


/** func: 取数据-index
 */
- (id)RCSDKSafetyArrayObjectAtIndexVerify:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
