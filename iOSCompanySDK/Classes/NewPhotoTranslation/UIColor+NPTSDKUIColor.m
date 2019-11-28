////  UIColor+NPTSDKUIColor.m
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  
//

#import "UIColor+NPTSDKUIColor.h"


@implementation UIColor (NPTSDKUIColor)

#pragma mark - hex string to color
+ (UIColor *)NPTSDKColorWithHexString: (NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //hexString should six-eight character
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if (cString.length > 6) {
        if ([cString hasSuffix:@"FF"]) {
            cString = [cString substringToIndex:cString.length-2];
        }
    }
    if ([cString length] != 6)
        return [UIColor clearColor];
    //RGB exchange
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // unsigned int object
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


#pragma mark - 渐变色生成
+ (CAGradientLayer *)NPTSDKSetGradualChangingColor:(CGRect)gradientLayerFrame fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradientLayerFrame;
    
    gradientLayer.colors = @[(__bridge id)[self NPTSDKColorWithHexString:fromHexColorStr].CGColor,(__bridge id)[self NPTSDKColorWithHexString:toHexColorStr].CGColor];
    
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}




@end
