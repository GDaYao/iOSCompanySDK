////  UILabel+NPTSDKUILabel.h
//  iOSCompanySDK
//
//  Created on 2019/11/28.
//  




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (NPTSDKUILabel)

+ (UILabel *)NPTSDKInitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;



@end

NS_ASSUME_NONNULL_END
