////  NSArray+BASDKSafetyArray.h
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (BASDKSafetyArray)


- (id)BASDKSafetyArrayObjectAtIndexVerify:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END
