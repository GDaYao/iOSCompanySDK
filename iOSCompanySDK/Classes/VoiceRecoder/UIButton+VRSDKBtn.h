////  UIButton+VRSDKBtn.h
//  iOSCompanySDK
//
//  Created on 2020/6/15.
//  
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIButton (VRSDKBtn)


#pragma mark  - button init
+ (UIButton *)VRSDKInitBtnWithBtnTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor isBold:(BOOL)isBold fontSize:(float)fontSize btnBgColor:(UIColor *)bgColor;






@end

NS_ASSUME_NONNULL_END
