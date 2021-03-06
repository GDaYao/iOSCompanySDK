////  UILabel+VRSDKLab.m
//  iOSCompanySDK
//
//  Created on 2020/6/15.
//  
//

#import "UILabel+VRSDKLab.h"


@implementation UILabel (VRSDKLab)


#pragma mark - label init
+ (UILabel *)VRSDKInitLabWithTextColor:(UIColor *)textColor isBold:(BOOL)isBold fontSize:(float)fontSize labText:(NSString *)labText labTxAlignment:(NSTextAlignment)labTxAlignment {
    UILabel *vpLab = [[UILabel alloc]init];
    if( (fontSize !=0) && (isBold == YES) ){
        vpLab.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        vpLab.font = [UIFont systemFontOfSize:fontSize];
    }
    vpLab.text = labText;
    vpLab.textColor = textColor;
    vpLab.textAlignment = labTxAlignment;
    vpLab.numberOfLines = 0;
    return vpLab;
}






@end
