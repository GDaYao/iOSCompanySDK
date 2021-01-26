////  UIButton+VCSDK.h
//  iOSCompanySDK
//
//  Created on 2021/1/25.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (VCSDK)


// init
+ (UIButton *)InitWithBGName:(NSString *_Nullable)imgStr btnTitle:(NSString *_Nullable)btnTitle titleColor:(UIColor *_Nullable)titleColor isBold:(BOOL)isBold fontSize:(CGFloat)fontSize btnBgColor:(UIColor *_Nullable)btnBgColor;



@end

NS_ASSUME_NONNULL_END
