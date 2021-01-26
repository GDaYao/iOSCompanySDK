////  UILabel+VCSDK.m
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import "UILabel+VCSDK.h"

@implementation UILabel (VCSDK)

+ (UILabel *)InitLabWithBGColor:(UIColor *_Nullable)bgColor txtColor:(UIColor *)txtColor isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txtAlignment:(NSTextAlignment)txtAlignment {
    UILabel *lab = [[UILabel alloc]init];
    if (bgColor == nil) {
        lab.backgroundColor = [UIColor clearColor];
    }else{
        lab.backgroundColor = bgColor;
    }
    
    if ( (fontSize!=0)&&(isBold==YES) ) {
        lab.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        lab.font = [UIFont systemFontOfSize:fontSize];
    }
    lab.text = labText;
    lab.textColor = txtColor;
    lab.textAlignment = txtAlignment;
    lab.numberOfLines = 0;
    
    return lab;
}



@end




