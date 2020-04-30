////  UIButton+RCSDKButton.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import "UIButton+RCSDKButton.h"

@implementation UIButton (RCSDKButton)


//
+ (UIButton *)RCSDKInitWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize btnBGColor:(UIColor *)bgColor {
    UIButton *vpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imgStr.length != 0) {
        [vpBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    if (titleStr.length != 0) {
        [vpBtn setTitle:titleStr forState:UIControlStateNormal];
        if (titleColor) {
            [vpBtn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        vpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    if (fontName.length!=0 && fontSize != 0.0 ) {
        vpBtn.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    }else if( (fontSize != 0.0) &&(isBold == YES) ){
        vpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        vpBtn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    if(bgColor){
        [vpBtn setBackgroundColor:bgColor];
    }
    return vpBtn;
}



@end
