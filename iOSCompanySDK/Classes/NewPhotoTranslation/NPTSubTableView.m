////  NPTSubTableView.m
//  iOSCompanySDK
//
//  Created on 2019/12/25.
//  
//


#import "NPTSubTableView.h"



static NSString *const kNPTDefaultCellIdentifier = @"NPTDefaultCellIdentifier";



@interface NPTSubTableView () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation NPTSubTableView

#pragma mark - init life
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}


#pragma mark - init config method
- (void)initNPTTVWithBGColor:(UIColor *)BGColor registerTableViewCell:(UITableViewCell *)tableViewCell tableViewCellID:(NSString *)kCellIdentifier showVerticalSI:(BOOL)showV showHorizontalSI:(BOOL)showH separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    self.backgroundColor = BGColor;
    // register cell class
    if ((kCellIdentifier==nil) || (kCellIdentifier.length == 0)) {
        [self registerClass:[tableViewCell class] forCellReuseIdentifier:kNPTDefaultCellIdentifier];
    }else{
        [self registerClass:[tableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    self.showsVerticalScrollIndicator = showV;
    self.showsHorizontalScrollIndicator = showH;
    self.separatorStyle = separatorStyle;
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - tableView delegate/dataSource
// TODO: nums
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger testInt = self.nptNumberSections(tableView);
    return testInt;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nptNumberRows(tableView,section);
}

// TODO: size-height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.nptHeightRow(tableView,indexPath);
}
// TODO: header and footer view
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.nptHeightHeaderInSection){
        return self.nptHeightHeaderInSection(tableView,section);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.nptViewHeaderInSection) {
        return self.nptViewHeaderInSection(tableView,section);
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.nptHeightFooterInSection){
        return self.nptHeightFooterInSection(tableView,section);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.nptViewFooterInSection) {
        return self.nptViewFooterInSection(tableView,section);
    }
    return nil;
}

// TODO: cell for row
/**
 useage:
    CustomizeCell *tableViewCell = (CustomizeCell *)[tableView dequeueReusableCellWithIdentifier:<equal to last set cell id>];
    if (tableViewCell == nil) {
        tableViewCell = [[CustomizeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:<equal to last set cell id>];
    }
    // start use `cell`

 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.nptCellForRow(tableView,indexPath);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.nptWillDisplayCellBlock) {
        self.nptWillDisplayCellBlock(tableView, cell, indexPath);
    }
}

// TODO: did select row
/**
 useage:
    // 可取消 - select 点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.nptDidSelectInTV(tableView,indexPath);
}
// TODO: edit cell
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (self.nptCellDeleteInTVInNWF) {
            self.nptCellDeleteInTVInNWF(tableView, indexPath);
        }
    }
    else
    {
        
    }
}
*/










@end
