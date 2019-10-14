
/** func: UIButton category
 *  init method.
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CWUIButton)

+ (UIButton *)cwInitBtnWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
