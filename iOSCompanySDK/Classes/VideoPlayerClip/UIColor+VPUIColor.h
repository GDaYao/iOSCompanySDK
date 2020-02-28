////  UIColor+VPUIColor.h
//  iOSCompanySDK
//  
//

/** func: UIColor
 *
 */



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (VPUIColor)


#pragma mark - 渐变色生成
+ (CAGradientLayer *)vpSDKSetGradualChangingColor:(CGRect)gradientLayerFrame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint fromColor:(UIColor *)
fromColor toColor:(UIColor *)toColor;



@end

NS_ASSUME_NONNULL_END

