
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
@property (nonatomic,copy) void(^scrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^scrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView);


// TODO: initilize method
- (void)initCVInNWFWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;



@end

NS_ASSUME_NONNULL_END
