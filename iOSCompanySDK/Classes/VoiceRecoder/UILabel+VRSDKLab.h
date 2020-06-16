////  UILabel+VRSDKLab.h
//  iOSCompanySDK
//
//  Created on 2020/6/15.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (VRSDKLab)


#pragma mark - label init
+ (UILabel *)VRSDKInitLabWithBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor isBold:(BOOL)isBold fontSize:(float)fontSize labText:(NSString *)labText labTxAlignment:(NSTextAlignment)labTxAlignment;

@end

NS_ASSUME_NONNULL_END
