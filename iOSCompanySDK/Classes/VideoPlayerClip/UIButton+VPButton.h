////  UIButton+VPButton.h
//  iOSCompanySDK
//
//  Created on 2020/2/28.
//  
//



/** func: video player and cliper
*   category UIButton.
*/


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (VPButton)

// init button.
+ (UIButton *)CPInitWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *)bgColor;



@end

NS_ASSUME_NONNULL_END


