////  UILabel+VPLabel.h



/** func: video player and cliper
 * category UILabel.
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (VPLabel)



// init ui
+ (UILabel *)VPInitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;


@end

NS_ASSUME_NONNULL_END

