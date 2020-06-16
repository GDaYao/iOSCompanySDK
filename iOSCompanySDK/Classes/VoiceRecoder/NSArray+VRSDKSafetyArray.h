////  NSArray+VRSDKSafetyArray.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//


/** func:NSArray safety get index data
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (VRSDKSafetyArray)


// get array index data.
- (id)vrsdkSafetyArrayObjectAtIndexVerify:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END
