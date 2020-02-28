////  VPSubCollectionView.h
//  iOSCompanySDK
//
//  Created on 2020/2/28.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VPSubCollectionView : UICollectionView



@property (nonatomic,copy)NSInteger(^vpsdkNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^vpsdkNumberItems)(UICollectionView *collectionView,NSInteger section);
//
// test teset teste
@property (nonatomic,copy)CGSize(^vpsdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^vpsdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^vpsdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
// test teset teste
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^vpsdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^vpsdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^vpsdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
// test teset teste
@property (nonatomic,copy)UIEdgeInsets(^vpsdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);

// test teset teste
@property (nonatomic,copy)CGSize (^vpsdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^vpsdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vpsdkSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vpsdkSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);

// video player scrollView delegate
@property (nonatomic,copy) void(^vpsdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vpsdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vpsdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vpsdkScrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^vpsdkScrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vpsdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);
// test teset teste

// TODO: initilize method
- (void)VPSDKInitCVFWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;







@end

NS_ASSUME_NONNULL_END


