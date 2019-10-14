


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CWColor)

#pragma mark - hex string to color
+ (UIColor *) cwColorWithHexString: (NSString *)hexString;


#pragma mark - 渐变色生成
+ (CAGradientLayer *)cwSetGradualChangingColor:(CGRect)gradientLayerFrame fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;




@end

NS_ASSUME_NONNULL_END
