////  UIButton+VCSDK.m
//  iOSCompanySDK
//
//  Created on 2021/1/25.
//  
//

#import "UIButton+VCSDK.h"

@implementation UIButton (VCSDK)


// init
+ (UIButton *)InitWithBGName:(NSString *_Nullable)imgStr btnTitle:(NSString *_Nullable)btnTitle titleColor:(UIColor *_Nullable)titleColor isBold:(BOOL)isBold fontSize:(CGFloat)fontSize btnBgColor:(UIColor *_Nullable)btnBgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imgStr.length != 0) {
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    if (btnTitle.length != 0) {
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        if (titleColor) {
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    if( (fontSize != 0.0) && (isBold == YES) ){
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    if(btnBgColor){
        [btn setBackgroundColor:btnBgColor];
    }
    return btn;
}


@end



