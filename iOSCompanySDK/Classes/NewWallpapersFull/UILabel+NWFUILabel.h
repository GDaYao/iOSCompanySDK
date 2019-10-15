////  UILabel+NWFUILabel.h
//  
//
//  Created on 2019/8/10.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (NWFUILabel)

+ (UILabel *)InitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;


@end

NS_ASSUME_NONNULL_END
