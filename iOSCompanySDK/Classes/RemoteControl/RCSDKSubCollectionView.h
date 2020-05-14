////  RCSDKSubCollectionView.h
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 

@interface RCSDKSubCollectionView : UICollectionView <UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>



@property (nonatomic,copy)NSInteger(^rcsdkNumberSectionsInCV)(UICollectionView *collectionView);
@property (nonatomic,copy)NSInteger(^rcsdkNumberItems)(UICollectionView *collectionView,NSInteger section);


@property (nonatomic,copy)CGSize(^rcsdkSizeForItem)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^rcsdkHorizontalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGFloat(^rcsdkVerticalDis)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionViewCell*_Nullable(^rcsdkCellForItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)void(^rcsdkDidSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)BOOL(^rcsdkShouldSelectItem)(UICollectionView *collectionView,NSIndexPath *indexPath);
@property (nonatomic,copy)UIEdgeInsets(^rcsdkInsetForSectionAtIndex)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);


//
@property (nonatomic,copy)CGSize (^rcsdkHeaderSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)CGSize (^rcsdkFooterSizeInSection)(UICollectionView *collectionView,UICollectionViewLayout *collectionViewLayout,NSInteger section);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^rcsdkSectionHeader)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);
@property (nonatomic,copy)UICollectionReusableView *_Nullable(^rcsdkSectionFooter)(UICollectionView *collectionView,NSString *kind,NSIndexPath *indexPath);


// scroll delegate
@property (nonatomic,copy) void(^rcsdkScrollViewWillBeginDraggingInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^rcsdkScrollViewDidScrollToTopInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^rcsdkScrollViewDidScrollInCV)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^rcsdkScrollViewDidEndDraggingInNWF)(UIScrollView *scrollView,BOOL decelerate);
@property (nonatomic,copy) void(^rcsdkScrollViewWillBegingDeceleratingInNWF)(UIScrollView *scrollView);
@property (nonatomic,copy) void(^rcsdkScrollViewDidEndDecelerating)(UIScrollView *scrollView);



// init method
- (void)RCSDKInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId;





@end

NS_ASSUME_NONNULL_END



