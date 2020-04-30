////  UILabel+RCSDKLabel.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (RCSDKLabel)

// init UILabel
+ (UILabel *)RCSDKInitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;


@end

NS_ASSUME_NONNULL_END
