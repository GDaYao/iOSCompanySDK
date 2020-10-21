////  BASDKSubCollectionView.h
//  BetteryAnimationSDK
//
//  Created on 2020/10/21.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BASDKSubCollectionView : UICollectionView <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>



@property (nonatomic,copy)NSInteger(^basdkNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^basdkNumberItems)(UICollectionView *collectionView,NSInteger section);


@property (nonatomic,copy)CGSize(^basdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^basdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^basdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^basdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^basdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^basdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)UIEdgeInsets(^basdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);


//
@property (nonatomic,copy)CGSize (^basdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^basdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^basdkSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^basdkSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);


// scroll delegate
@property (nonatomic,copy) void(^basdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^basdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^basdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^basdkScrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^basdkScrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^basdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);



// init method
- (void)BASDKInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;

@end

NS_ASSUME_NONNULL_END
