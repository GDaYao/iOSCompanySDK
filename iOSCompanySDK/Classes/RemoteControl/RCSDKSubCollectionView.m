////  RCSDKSubCollectionView.m
//  iOSCompanySDK
//
//  Created on 2020/4/30.
//  
//

#import "RCSDKSubCollectionView.h"


static NSString * const kRCSDKDefaultCellIdentifier = @"RCSDKDefaultCellIdentifier";



@implementation RCSDKSubCollectionView


#pragma mark - init with frame
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}



#pragma mark  - init config method
- (void)RCSDKInitCVWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId {
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
    if (cellId == nil || cellId.length == 0) {
        [self registerNib:[UINib nibWithNibName:NibName bundle:nil] forCellWithReuseIdentifier:kRCSDKDefaultCellIdentifier];
    }else if(NibName.length !=0 ){
        [self registerNib:[UINib nibWithNibName:NibName bundle:nil] forCellWithReuseIdentifier:cellId];
    }else if(cellClass){
        [self registerClass:cellClass forCellWithReuseIdentifier:cellId];
    }
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.dataSource = self;
    self.bounces = YES;
}


#pragma mark - UICollectionView delegate/datasource
// TODO: numbers
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numInt = self.rcsdkNumberSectionsInCV(collectionView);
    return numInt;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.rcsdkNumberItems(collectionView,section);
}

// TODO: some size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.rcsdkSizeForItem(collectionView,collectionViewLayout,indexPath);
}
// 纵间距 <>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.rcsdkVerticalDis(collectionView,collectionViewLayout,section);
}
// 列间距 <|---|---|>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.rcsdkHorizontalDis(collectionView,collectionViewLayout,section);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.rcsdkInsetForSectionAtIndex) {
        return self.rcsdkInsetForSectionAtIndex(collectionView,collectionViewLayout,section);
    }
    return UIEdgeInsetsZero;
}


// TODO: header|footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(self.rcsdkHeaderSizeInSection){
     return   self.rcsdkHeaderSizeInSection(collectionView, collectionViewLayout, section);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.rcsdkFooterSizeInSection) {
        return self.rcsdkFooterSizeInSection(collectionView, collectionViewLayout, section);
    }
 return CGSizeMake(0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.rcsdkSectionHeader) {
            return self.rcsdkSectionHeader(collectionView,kind,indexPath);
        }
    }
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (self.rcsdkSectionFooter) {
            return self.rcsdkSectionFooter(collectionView,kind,indexPath);
        }
    };
    return nil;
}

// TODO: cell display+select

/**
 UICollectionView cell content show or cell action operate.
 
 useage:
    CustomizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomizeCellId forIndexPath:indexPath];
    // start use `cell`
 
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.rcsdkCellForItem(collectionView,indexPath);
}

/**
 useage:
    // 可取消 - select 点击效果
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.rcsdkDidSelectItem(collectionView,indexPath);
}
//返回这个 `UICollectionView`某个cell 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.rcsdkScrollViewWillBeginDraggingInCV) {
        self.rcsdkScrollViewWillBeginDraggingInCV(scrollView);
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.rcsdkScrollViewDidScrollToTopInCV) {
        self.rcsdkScrollViewDidScrollToTopInCV(scrollView);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.rcsdkScrollViewDidScrollInCV) {
        self.rcsdkScrollViewDidScrollInCV(scrollView);
    }
}
// scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.rcsdkScrollViewDidEndDraggingInNWF) {
        self.rcsdkScrollViewDidEndDraggingInNWF(scrollView, decelerate);
    }
}
// scrollview 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.rcsdkScrollViewWillBegingDeceleratingInNWF) {
        self.rcsdkScrollViewWillBegingDeceleratingInNWF(scrollView);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.rcsdkScrollViewDidEndDecelerating) {
        self.rcsdkScrollViewDidEndDecelerating(scrollView);
    }
}





@end


