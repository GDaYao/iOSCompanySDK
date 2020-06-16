////  UIButton+VRSDKBtn.m
//  iOSCompanySDK
//
//  Created on 2020/6/15.
//  
//

#import "UIButton+VRSDKBtn.h"



@implementation UIButton (VRSDKBtn)




#pragma mark  - button init
+ (UIButton *)VRSDKInitBtnWithBtnTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor isBold:(BOOL)isBold fontSize:(float)fontSize btnBgColor:(UIColor *)bgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (titleStr.length != 0) {
        [btn setTitle:titleStr forState:UIControlStateNormal];
        if (titleColor) {
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    if( (fontSize != 0.0) &&(isBold == YES) ){
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    if(bgColor){
        [btn setBackgroundColor:bgColor];
    }
    return btn;
}









@end

