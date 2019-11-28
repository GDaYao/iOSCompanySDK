////  UIColor+NPTSDKUIColor.h
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (NPTSDKUIColor)



#pragma mark - hex string to color
+ (UIColor *)NPTSDKColorWithHexString: (NSString *)hexString;


#pragma mark - 渐变色生成
+ (CAGradientLayer *)NPTSDKSetGradualChangingColor:(CGRect)gradientLayerFrame fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;



@end

NS_ASSUME_NONNULL_END
