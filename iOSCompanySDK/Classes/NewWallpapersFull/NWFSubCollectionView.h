


/** func: realized `UICollectionView` subclass
 *  `UICollectionView` class method used.
 *
 *  由于扩展中不能使用扩展类“属性”，所以只能使用继承实现我们所需要的效果，可实现多个block回调实现。
 */

/** Usage:
 * 1. first to import class. #import "GDYSDKSubCollectionView.h"
 
 * 2. start relaized.
 
     UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
 GDYSDKSubCollectionView *mainCV = [[GDYSDKSubCollectionView alloc]initWithFrame:<#CGRectZero-after set frame/set frame now#> collectionViewLayout:layout];
 [mainCV initCVWithBGColor:<#bgColor#> withNeedHeaderFooter:<#YES/NO#> withHSize:<#CGSizeZero/set size#> withFSize:<#CGSizeZero/set size#> withHID:<#set header id string#> withFID:<#set footer id string#> withRegisterNib:<#UICollectionViewCell.nib file name#> registerClas:<#cellClass#> withCellId:<#UICollectionViewCell id#>];
     [self.view addSubview:mainCV];
 >>>>
     // Also you can use `Masonry` to layout view.
     [mainCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topSearchOrBackView.mas_bottom).offset(12);
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.bottom.equalTo(self).offset(0);
     }];
 >>>>
    // use weak reference.
    __weak typeof(self) weakSelf = self;
    // start to call some iOS-block to relized.
 >>>>
    // cellForItem -- useage:
    CustomizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomizeCellId forIndexPath:indexPath];
    // start use `cell`
 >>>>
    // didSelectItem -- useage:
    // 可取消 - select 点击效果
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
 >>>>
    // also you want to observer scroll,you can relized `UIScollView` delegate-block.
 
 * 3. 特别用法： 使UICollectionView滚动头部标题不动，效果类似于UITableView-UITableViewStylePlain
 
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NWFSubCollectionView : UICollectionView <UIScrollViewDelegate>  // <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,copy)NSInteger(^numberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^numberItems)(UICollectionView *collectionView,NSInteger section);
//
@property (nonatomic,copy)CGSize(^sizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^horizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^verticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UIEdgeInsets(^insetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
//
@property (nonatomic,copy)CGSize (^headerSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^footerSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^sectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^sectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
//
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^cellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^didSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^shouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
// scrollView delegate
@property (nonatomic,copy) void(^scrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^scrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^scrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView);


// TODO: initilize method
- (void)initCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;



@end

NS_ASSUME_NONNULL_END
