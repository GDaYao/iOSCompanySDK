////  VRSDKSubCollectionView.h
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

/** func: VRSDK UICollectionView
 *
 *
 **/


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN



@interface VRSDKSubCollectionView : UICollectionView

//
@property (nonatomic,strong)NSInteger(^vrsdkNumberSections)(UICollectionView *collectionView);
@property (nonatomic,strong)NSInteger (^vrsdkNumberItems)(UICollectionView *collectionView,NSInteger section);

@property (nonatomic,copy)CGSize(^vrsdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^vrsdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^vrsdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^vrsdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^vrsdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^vrsdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)UIEdgeInsets(^vrsdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);

//
@property (nonatomic,copy)CGSize (^vrsdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^vrsdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vrsdkSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^vrsdkSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);


// scroll delegate
@property (nonatomic,copy) void(^vrsdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vrsdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vrsdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vrsdkScrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^vrsdkScrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^vrsdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);



// init method
- (void)vrsdkInitCollectionViewWithNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID registerClass:(Class)cellClass withCellId:(NSString *)cellId;











@end

NS_ASSUME_NONNULL_END
