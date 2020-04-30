////  UILabel+RCSDKLabel.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import "UILabel+RCSDKLabel.h"

@implementation UILabel (RCSDKLabel)


// init UILabel
+ (UILabel *)RCSDKInitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment {
    
    UILabel *vpLab = [[UILabel alloc]init];
    if (bgColor == nil) {
        vpLab.backgroundColor = [UIColor clearColor];
    }else{
        vpLab.backgroundColor = bgColor;
    }
    if(fontName &&  (fontSize != 0)){
        vpLab.font = [UIFont fontWithName:fontName size:fontSize];
    }else if(!fontName && (fontSize !=0) && (isBold == YES) ){
        vpLab.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        vpLab.font = [UIFont systemFontOfSize:fontSize];
    }
    vpLab.text = labText;
    vpLab.textColor = txColor;
    vpLab.textAlignment = txAlignment;
    vpLab.numberOfLines = 0;
    return vpLab;
}


@end



