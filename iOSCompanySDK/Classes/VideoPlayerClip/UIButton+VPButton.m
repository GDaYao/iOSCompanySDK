////  UIButton+VPButton.m
//  iOSCompanySDK
//
//  Created on 2020/2/28.
//  
//

#import "UIButton+VPButton.h"




@implementation UIButton (VPButton)


// init button.
+ (UIButton *)CPInitWithBGName:(NSString *)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *)bgColor {
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
    if (fontName.length!=0 && sizeFont != 0.0 ) {
        vpBtn.titleLabel.font = [UIFont fontWithName:fontName size:sizeFont];
    }else if( (sizeFont != 0.0) &&(isBold == YES) ){
        vpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:sizeFont];
    }else{
        vpBtn.titleLabel.font = [UIFont systemFontOfSize:sizeFont];
    }
    if(bgColor){
        [vpBtn setBackgroundColor:bgColor];
    }
    return vpBtn;
}



@end



