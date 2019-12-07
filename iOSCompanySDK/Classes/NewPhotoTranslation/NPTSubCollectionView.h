////  NPTSubCollectionView.h
//  iOSCompanySDK
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPTSubCollectionView : UICollectionView <UIScrollViewDelegate>


@property (nonatomic,copy)NSInteger(^nptsdkNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^nptsdkNumberItems)(UICollectionView *collectionView,NSInteger section);
//
// test teset teste
@property (nonatomic,copy)CGSize(^nptsdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^nptsdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^nptsdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
// test teset teste
@property (nonatomic,copy)UIEdgeInsets(^nptsdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
//// test teset teste
@property (nonatomic,copy)CGSize (^nptsdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^nptsdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^sectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^sectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
//// test teset teste
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^nptsdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^nptsdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^nptsdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
// scrollView delegate
@property (nonatomic,copy) void(^nptsdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^nptsdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^nptsdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^nptsdkScrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^nptsdkScrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^nptsdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);
// test teset teste

// TODO: initilize method
- (void)NPTSDKInitCVFWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;


@end

NS_ASSUME_NONNULL_END
