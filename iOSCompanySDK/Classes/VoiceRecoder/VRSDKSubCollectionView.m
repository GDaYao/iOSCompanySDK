////  VRSDKSubCollectionView.m
//  iOSCompanySDK
//
//  Created on 2020/6/16.
//  
//

#import "VRSDKSubCollectionView.h"

@implementation VRSDKSubCollectionView


#pragma amrk - int collection view
- (void)vrsdkInitCollectionViewWithNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID registerClass:(Class)cellClass withCellId:(NSString *)cellId {
    
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
    self.bounces = YES;
    // delegate | dataSource no set.
}

#pragma mark - UICollectionView delegate/datasource
// TODO:size
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numInt = self.vrsdkNumberSections(collectionView);
    return numInt;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.vrsdkNumberItems(collectionView,section);
}

// TODO: size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vrsdkSizeForItem(collectionView,collectionViewLayout,indexPath);
}
// TODO:layout
// 纵间距 <>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.vrsdkVerticalDis(collectionView,collectionViewLayout,section);
}
// 列间距 <|---|---|>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.vrsdkHorizontalDis(collectionView,collectionViewLayout,section);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.vrsdkInsetForSectionAtIndex) {
        return self.vrsdkInsetForSectionAtIndex(collectionView,collectionViewLayout,section);
    }
    return UIEdgeInsetsZero;
}


// TODO: header|footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(self.vrsdkHeaderSizeInSection){
     return   self.vrsdkHeaderSizeInSection(collectionView, collectionViewLayout, section);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.vrsdkFooterSizeInSection) {
        return self.vrsdkFooterSizeInSection(collectionView, collectionViewLayout, section);
    }
 return CGSizeMake(0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.vrsdkSectionHeader) {
            return self.vrsdkSectionHeader(collectionView,kind,indexPath);
        }
    }
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (self.vrsdkSectionFooter) {
            return self.vrsdkSectionFooter(collectionView,kind,indexPath);
        }
    };
    return nil;
}

// TODO: cell display+select

/**
 useage:
    CustomizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomizeCellId forIndexPath:indexPath];
    // start use `cell`
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vrsdkCellForItem(collectionView,indexPath);
}

/**
 useage:
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.vrsdkDidSelectItem(collectionView,indexPath);
}
//返回这个 `UICollectionView`某个cell 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.vrsdkScrollViewWillBeginDraggingInCV) {
        self.vrsdkScrollViewWillBeginDraggingInCV(scrollView);
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.vrsdkScrollViewDidScrollToTopInCV) {
        self.vrsdkScrollViewDidScrollToTopInCV(scrollView);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.vrsdkScrollViewDidScrollInCV) {
        self.vrsdkScrollViewDidScrollInCV(scrollView);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.vrsdkScrollViewDidEndDraggingInNWF) {
        self.vrsdkScrollViewDidEndDraggingInNWF(scrollView, decelerate);
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.vrsdkScrollViewWillBegingDeceleratingInNWF) {
        self.vrsdkScrollViewWillBegingDeceleratingInNWF(scrollView);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.vrsdkScrollViewDidEndDecelerating) {
        self.vrsdkScrollViewDidEndDecelerating(scrollView);
    }
}








@end
