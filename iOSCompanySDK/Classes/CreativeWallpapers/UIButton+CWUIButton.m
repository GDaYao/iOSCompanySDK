
#import "UIButton+CWUIButton.h"

@implementation UIButton (CWUIButton)

#pragma mark - init button.
+ (UIButton *)cwInitBtnWithBGName:(NSString *_Nullable)imgStr title:(NSString *)titleStr titleColor:(UIColor *)titleColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)sizeFont btnBGColor:(UIColor *)bgColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imgStr.length != 0) {
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    }
    if (titleStr.length != 0) {
        [btn setTitle:titleStr forState:UIControlStateNormal];
        if (titleColor) {
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    if (fontName.length!=0 && sizeFont != 0.0 ) {
        btn.titleLabel.font = [UIFont fontWithName:fontName size:sizeFont];
    }else if( (sizeFont != 0.0) &&(isBold == YES) ){
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:sizeFont];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:sizeFont];
    }
    if(bgColor){
        [btn setBackgroundColor:bgColor];
    }
    return btn;
}





@end
