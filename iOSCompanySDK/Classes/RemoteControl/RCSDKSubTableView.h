////  RCSDKSubTableView.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RCSDKSubTableView : UITableView <UITableViewDelegate,UITableViewDataSource>



@property(nonatomic,copy) NSInteger(^numberSections)(UITableView *tableView);
@property(nonatomic,copy) NSInteger(^numberRows)(UITableView *tableView,NSInteger section);

//
@property(nonatomic,copy) CGFloat(^heightRow)(UITableView *tableView,NSIndexPath *indexPath);
@property(nonatomic,copy) CGFloat(^heightHeaderInSection)(UITableView *tableView, NSInteger section);

@property(nonatomic,copy) UIView*_Nullable(^viewHeaderInSection)(UITableView *tableView, NSInteger section);
@property(nonatomic,copy) CGFloat(^heightFooterInSection)(UITableView *tableView, NSInteger section);
@property(nonatomic,copy) UIView*_Nullable(^viewFooterInSection)(UITableView *tableView,NSInteger section);

//
@property (nonatomic,copy)NSArray<NSString *>*(^sectionIndexTitles)(UITableView *tableView);
@property (nonatomic,copy)NSInteger(^sectionForSectionIndexTitle)(NSString *title,NSInteger index);

//
@property(nonatomic,copy) UITableViewCell*_Nullable(^cellForRow)(UITableView *tableView,NSIndexPath *indexPath);
@property(nonatomic,copy) void(^willDisrplayCellBlock)(UITableView *tableView,UITableViewCell *cell,NSIndexPath *indexPath);
@property(nonatomic,copy) void(^didSelectInTV)(UITableView *tableView,NSIndexPath *indexPath);




// scrollView delegate
@property(nonatomic,copy) void(^scrollViewWillBeginDraggingInTV)(UIScrollView *scrollView);
@property(nonatomic,copy) void(^scrollViewDidScrollToTopInTV)(UIScrollView *scrollView);
@property(nonatomic,copy) void(^scrollViewDidScrollInTV)(UIScrollView *scrollView);



// edit cell
@property (nonatomic,copy) BOOL (^canEditRowAtIndexPathBlock)(NSIndexPath *indexpath);
@property (nonatomic,copy) void(^rcsdkCellDeleteInTVBlock)(UITableView *tableView,NSIndexPath *indexPath);


// initilize method
- (void)initTVWithBGColor:(UIColor *)BGColor registerTableViewCell:(UITableViewCell *)tableViewCell tableViewCellID:(NSString *)kCellIdentifier showVerticalSI:(BOOL)showV showHorizontalSI:(BOOL)showH separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;



@end

NS_ASSUME_NONNULL_END
