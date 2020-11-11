////  UIButton+BASDK.h
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BASDK)


+ (UIButton *)InitWithBGName:(NSString * _Nullable)imgStr title:(NSString * _Nullable)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *_Nullable)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *_Nullable)bgColor;


@end

NS_ASSUME_NONNULL_END
