////  VCSDKSubCollectionView.h
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSDKSubCollectionView : UICollectionView <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


@property (nonatomic,copy)NSInteger(^vcsdkNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^vcsdkNumberItems)(UICollectionView *collectionView,NSInteger section);

@property (nonatomic,copy)CGSize(^vcsdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^vcsdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^vcsdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^vcsdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^vcsdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^vcsdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)UIEdgeInsets(^vcsdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);

@property (nonatomic,copy) void(^vcsdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vcsdkScrollViewWillBegingDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vcsdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vcsdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vcsdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vcsdkScrollViewDidEndDragging)(UIScrollView *scrollView,BOOL decelerate);


//
@property (nonatomic,copy)CGSize (^vcsdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^vcsdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vcsdkSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vcsdkSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);


// init method
- (void)VCSDKInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID registerClass:(Class)cellClass withCellId:(NSString *)cellId;


@end

NS_ASSUME_NONNULL_END
