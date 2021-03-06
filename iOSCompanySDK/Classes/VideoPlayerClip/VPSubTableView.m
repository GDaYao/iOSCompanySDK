////  VPSubTableView.m
//  iOSCompanySDK
//
//  Created on 2020/4/8.
//  
//

#import "VPSubTableView.h"

static NSString *  const kVPDefaultCellIdentifier = @"VPSubUITableViewCellIdentifier";

@implementation VPSubTableView

#pragma mark - init life
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
    }
    return self;
}


#pragma mark - init config method
- (void)initTVWithBGColor:(UIColor *)BGColor registerTableViewCell:(UITableViewCell *)tableViewCell tableViewCellID:(NSString *)kCellIdentifier showVerticalSI:(BOOL)showV showHorizontalSI:(BOOL)showH separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{
    self.backgroundColor = BGColor;
    // register cell class
    if ((kCellIdentifier==nil) || (kCellIdentifier.length == 0)) {
        [self registerClass:[tableViewCell class] forCellReuseIdentifier:kVPDefaultCellIdentifier];
    }else{
        [self registerClass:[tableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    self.showsVerticalScrollIndicator = showV;
    self.showsHorizontalScrollIndicator = showH;
    self.separatorStyle = separatorStyle; // 去除cell底部横线
    self.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; // 去除多余横线
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - tableView delegate/dataSource
// TODO: nums
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger testInt = self.numberSections(tableView);
    return testInt;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.numberRows(tableView,section);
}

// TODO: size-height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.heightRow(tableView,indexPath);
}
// TODO: header and footer view
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.heightHeaderInSection){
        return self.heightHeaderInSection(tableView,section);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.viewHeaderInSection) {
        return self.viewHeaderInSection(tableView,section);
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.heightFooterInSection){
        return self.heightFooterInSection(tableView,section);
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.viewFooterInSection) {
        return self.viewFooterInSection(tableView,section);
    }
    return nil;
}

// TODO: cell for row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellForRow(tableView,indexPath);
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.willDisplayCellBlock) {
        self.willDisplayCellBlock(tableView, cell, indexPath);
    }
}

// TODO: did select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.didSelectInTV(tableView,indexPath);
}
// TODO: edit cell
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (self.cellDeleteInTVInNWF) {
            self.cellDeleteInTVInNWF(tableView, indexPath);
        }
    }
    else
    {
        
    }
}
*/


#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollViewWillBeginDraggingInTV) {
        self.scrollViewWillBeginDraggingInTV(scrollView);
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollToTopInTV) {
        self.scrollViewDidScrollToTopInTV(scrollView);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollInTV) {
        self.scrollViewDidScrollInTV(scrollView);
    }
}

@end
