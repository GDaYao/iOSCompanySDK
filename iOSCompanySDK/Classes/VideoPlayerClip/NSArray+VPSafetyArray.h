////  NSArray+VPSafetyArray.h
//  iOSCompanySDK
//
//

/** func: NSArray 安全数组
 *
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (VPSafetyArray)

/** func: 取数组--index.
 *
 */
- (id)vpSafetyArrayObjectAtIndexVerify:(NSUInteger)index;



@end

NS_ASSUME_NONNULL_END
