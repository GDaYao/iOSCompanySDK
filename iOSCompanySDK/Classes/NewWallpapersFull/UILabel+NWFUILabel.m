////  UILabel+NWFUILabel.m
//  iOSCompanySDK
//
//  Created on 2019/8/10.
//  
//

#import "UILabel+NWFUILabel.h"

@implementation UILabel (NWFUILabel)


#pragma mark - `UILabel` init method
+ (UILabel *)InitLabWithBGColor:(UIColor *)bgColor textColor:(UIColor *)txColor fontName:(NSString *)fontName isBold:(BOOL)isBold fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment
{
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


// garbage code
+ (void)addGarbageTextCodeInPublicNNNNNModel {
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFour = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIView *view = [[UIView alloc]init];
    [view addSubview:testBtn];
    [view addSubview:testBtnTwo];
    [view addSubview:testBtnThree];
    [view addSubview:testBtnFour];
    [view addSubview:testBtnFive];
    
}


@end
