////  UILabel+BASDK.m
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import "UILabel+BASDK.h"

@implementation UILabel (BASDK)


+ (UILabel *)InitLabWithBGColor:(UIColor * _Nullable)bgColor textColor:(UIColor *)txColor fontName:(NSString *_Nullable)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment {
    UILabel *lab = [[UILabel alloc]init];
    if (bgColor == nil) {
        lab.backgroundColor = [UIColor clearColor];
    }else{
        lab.backgroundColor = bgColor;
    }
    if(fontName &&  (fontSize != 0)){
        lab.font = [UIFont fontWithName:fontName size:fontSize];
    }else if(!fontName && (fontSize !=0) && (isBold == YES) ){
        lab.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        lab.font = [UIFont systemFontOfSize:fontSize];
    }
    lab.text = labText;
    lab.textColor = txColor;
    lab.textAlignment = txAlignment;
    lab.numberOfLines = 0;
    
    return lab;
}






@end
