////  NSMutableArray+VCSDKMuArray.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSMutableArray (VCSDKMuArray)



- (id)VCSDKSafetyMuArrObjectAtIndex:(NSUInteger)arrIndex;
- (void)VCSDKSafetyMuArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
- (void)VCSDKSafetyMuArrAddObjectVerify:(id)object;
- (void)VCSDKSafetyMuArrDeleteWithIndex:(NSUInteger)index;
- (void)VCSDKSafetyMuArrDeleteWithObject:(id)object;




@end

NS_ASSUME_NONNULL_END
