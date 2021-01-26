////  UILabel+VCSDK.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (VCSDK)


+ (UILabel *)InitLabWithBGColor:(UIColor *_Nullable)bgColor txtColor:(UIColor *)txtColor isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txtAlignment:(NSTextAlignment)txtAlignment;




@end

NS_ASSUME_NONNULL_END
