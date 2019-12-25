////  UIButton+NPTSDKUIButton.h
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (NPTSDKUIButton)

+ (UIButton *)NPTSDKInitBtnWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END