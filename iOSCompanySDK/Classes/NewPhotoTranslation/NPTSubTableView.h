////  NPTSubTableView.h
//  iOSCompanySDK
//
//  Created on 2019/12/25.
//





#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPTSubTableView : UITableView


@property(nonatomic,copy) NSInteger(^nptNumberSections)(UITableView *tableView);
@property(nonatomic,copy) NSInteger(^nptNumberRows)(UITableView *tableView,NSInteger section);
//
@property(nonatomic,copy) CGFloat(^nptHeightRow)(UITableView *tableView,NSIndexPath *indexPath);
@property(nonatomic,copy) CGFloat(^nptHeightHeaderInSection)(UITableView *tableView, NSInteger section);

@property(nonatomic,copy) UIView*_Nullable(^nptViewHeaderInSection)(UITableView *tableView, NSInteger section);
@property(nonatomic,copy) CGFloat(^nptHeightFooterInSection)(UITableView *tableView, NSInteger section);
@property(nonatomic,copy) UIView*_Nullable(^nptViewFooterInSection)(UITableView *tableView,NSInteger section);

@property(nonatomic,copy) UITableViewCell*_Nullable(^nptCellForRow)(UITableView *tableView,NSIndexPath *indexPath);
@property(nonatomic,copy) void(^nptWillDisplayCellBlock)(UITableView *tableView,UITableViewCell *cell,NSIndexPath *indexPath);
@property(nonatomic,copy) void(^nptDidSelectInTV)(UITableView *tableView,NSIndexPath *indexPath);
@property (nonatomic,copy) void(^nptCellDeleteInTVInNWF)(UITableView *tableView,NSIndexPath *indexPath);




// TODO: initilize method
- (void)initNPTTVWithBGColor:(UIColor *)BGColor registerTableViewCell:(UITableViewCell *)tableViewCell tableViewCellID:(NSString *)kCellIdentifier showVerticalSI:(BOOL)showV showHorizontalSI:(BOOL)showH separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;




@end

NS_ASSUME_NONNULL_END
