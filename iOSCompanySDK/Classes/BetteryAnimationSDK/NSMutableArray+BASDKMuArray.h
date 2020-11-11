////  NSMutableArray+BASDKMuArray.h
//  BetteryAnimationSDK
//
//  Created on 2020/4/30.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (BASDKMuArray)

- (id)BASDKSafetyMuArrObjectAtIndex:(NSUInteger)index;
- (void)BASDKSafetyMuArrDeleteWithIndex:(NSUInteger)index;
- (void)BASDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
- (void)BASDKSafetyMuArrAddObjectVerify:(id)object;
- (void)BASDKSafetyMuArrDeleteWithObject:(id)object;



@end

NS_ASSUME_NONNULL_END


