////  UILabel+BASDK.h
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (BASDK)



+ (UILabel *)InitLabWithBGColor:(UIColor * _Nullable)bgColor textColor:(UIColor *)txColor fontName:(NSString *_Nullable)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;


@end

NS_ASSUME_NONNULL_END
