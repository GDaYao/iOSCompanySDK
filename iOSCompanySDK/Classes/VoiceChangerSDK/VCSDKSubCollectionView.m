////  VCSDKSubCollectionView.m
//  iOSCompanySDK
//
//  Created on 2021/1/26.
//  
//

#import "VCSDKSubCollectionView.h"




@implementation VCSDKSubCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)VCSDKInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID registerClass:(Class)cellClass withCellId:(NSString *)cellId {
    self.backgroundColor = BGColor;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionViewLayout = layout;
    if(isNeed){
        if (HID) {
            [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HID];
        }
        if (FID) {
            [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FID];
        }
    }
    if(cellClass){
        [self registerClass:cellClass forCellWithReuseIdentifier:cellId];
    }
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    self.bounces = YES;
}


#pragma mark - UICollectionView delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numInt = self.vcsdkNumberSections(collectionView);
    return numInt;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.vcsdkNumberItems(collectionView,section);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vcsdkSizeForItem(collectionView,collectionViewLayout,indexPath);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.vcsdkVerticalDis(collectionView,collectionViewLayout,section);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.vcsdkHorizontalDis(collectionView,collectionViewLayout,section);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.vcsdkInsetForSectionAtIndex) {
        return self.vcsdkInsetForSectionAtIndex(collectionView,collectionViewLayout,section);
    }
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(self.vcsdkHeaderSizeInSection){
     return   self.vcsdkHeaderSizeInSection(collectionView, collectionViewLayout, section);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.vcsdkFooterSizeInSection) {
        return self.vcsdkFooterSizeInSection(collectionView, collectionViewLayout, section);
    }
 return CGSizeMake(0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.vcsdkSectionHeader) {
            return self.vcsdkSectionHeader(collectionView,kind,indexPath);
        }
    }
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (self.vcsdkSectionFooter) {
            return self.vcsdkSectionFooter(collectionView,kind,indexPath);
        }
    };
    return nil;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vcsdkCellForItem(collectionView,indexPath);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vcsdkDidSelectItem(collectionView,indexPath);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.vcsdkScrollViewWillBeginDragging) {
        self.vcsdkScrollViewWillBeginDragging(scrollView);
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.vcsdkScrollViewDidScrollToTop) {
        self.vcsdkScrollViewDidScrollToTop(scrollView);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.vcsdkScrollViewDidScroll) {
        self.vcsdkScrollViewDidScroll(scrollView);
    }
}
// scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.vcsdkScrollViewDidEndDragging) {
        self.vcsdkScrollViewDidEndDragging(scrollView, decelerate);
    }
}
// scrollview 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.vcsdkScrollViewWillBegingDecelerating) {
        self.vcsdkScrollViewWillBegingDecelerating(scrollView);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.vcsdkScrollViewDidEndDecelerating) {
        self.vcsdkScrollViewDidEndDecelerating(scrollView);
    }
}



@end



