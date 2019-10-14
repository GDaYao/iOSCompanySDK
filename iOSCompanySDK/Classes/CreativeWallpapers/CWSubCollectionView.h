
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWSubCollectionView : UICollectionView <UIScrollViewDelegate>


@property (nonatomic,copy)NSInteger(^cwNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^cwNumberItems)(UICollectionView *collectionView,NSInteger section);
//
@property (nonatomic,copy)CGSize(^cwSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^cwHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^cwVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UIEdgeInsets(^cwInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
//
@property (nonatomic,copy)CGSize (^cwHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^cwFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^cwSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^cwSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
//
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^cwCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^cwDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^cwShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);

// scrollView delegate
@property (nonatomic,copy) void(^cwScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^cwScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^cwScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^cwScrollViewDidEndDecelerating)(UIScrollView *scrollView);



// TODO: initilize method
- (void)CWInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;



@end

NS_ASSUME_NONNULL_END
