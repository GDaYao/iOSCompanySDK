////  UIColor+VPUIColor.m
//  iOSCompanySDK
//  
//

#import "UIColor+VPUIColor.h"




@implementation UIColor (VPUIColor)


#pragma mark - 渐变色生成
+ (CAGradientLayer *)vpSDKSetGradualChangingColor:(CGRect)gradientLayerFrame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint fromColor:(UIColor *)
fromColor toColor:(UIColor *)toColor {
    
    
    CAGradientLayer *gradientLayer  = [CAGradientLayer layer];
    gradientLayer.frame = gradientLayerFrame;
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.locations = @[@0,@1];
    return gradientLayer;
}





@end




