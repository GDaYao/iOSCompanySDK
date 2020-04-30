////  UIButton+RCSDKButton.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (RCSDKButton)


//
+ (UIButton *)RCSDKInitWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize btnBGColor:(UIColor *)bgColor;



@end

NS_ASSUME_NONNULL_END
