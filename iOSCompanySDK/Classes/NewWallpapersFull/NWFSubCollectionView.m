

#import "NWFSubCollectionView.h"


static NSString * const kNWFDefaultCellIdentifier = @"NWFUICollectionViewCellIdentifier";

@implementation NWFSubCollectionView

#pragma mark - init with frame
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
// garbage code
+ (void)addGarbageTextCodeInPublicNNNNNModel {
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnTwo = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnThree = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFour = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *testBtnFive = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIView *view = [[UIView alloc]init];
    [view addSubview:testBtn];
    [view addSubview:testBtnTwo];
    [view addSubview:testBtnThree];
    [view addSubview:testBtnFour];
    [view addSubview:testBtnFive];
    
}

#pragma mark  - init config method
- (void)initCVInNWFWithBGColor:(UIColor *)BGColor withNeedHeaderFooter:(BOOL)isNeed withHSize:(CGSize)HSize withFSize:(CGSize)FSize withHID:(NSString *)HID withFID:(NSString *)FID withRegisterNib:(NSString *)NibName registerClass:(Class)cellClass withCellId:(NSString *)cellId {
    self.backgroundColor = BGColor;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionViewLayout = layout;
    if(isNeed){
        layout.headerReferenceSize = HSize;
        layout.footerReferenceSize = FSize;
        if (HID) {
            [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HID];
        }
        if (FID) {
            [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FID];
        }
    }
    if (cellId == nil || cellId.length == 0) {
        [self registerNib:[UINib nibWithNibName:NibName bundle:nil] forCellWithReuseIdentifier:kNWFDefaultCellIdentifier];
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
    NSInteger numInt = self.numberSectionsInCV(collectionView);
    return numInt;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.numberItems(collectionView,section);
}

// TODO: some size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.sizeForItem(collectionView,collectionViewLayout,indexPath);
}
// 纵间距 <>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.verticalDis(collectionView,collectionViewLayout,section);
}
// 列间距 <|---|---|>
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.horizontalDis(collectionView,collectionViewLayout,section);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.insetForSectionAtIndex) {
        return self.insetForSectionAtIndex(collectionView,collectionViewLayout,section);
    }
    return UIEdgeInsetsZero;
}


// TODO: header|footer
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(self.headerSizeInSection){
     return   self.headerSizeInSection(collectionView, collectionViewLayout, section);
    }
    return CGSizeMake(0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (self.footerSizeInSection) {
        return self.footerSizeInSection(collectionView, collectionViewLayout, section);
    }
 return CGSizeMake(0, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (self.sectionHeader) {
            return self.sectionHeader(collectionView,kind,indexPath);
        }
    }
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        if (self.sectionFooter) {
            return self.sectionFooter(collectionView,kind,indexPath);
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
    return self.cellForItem(collectionView,indexPath);
}

/**
 useage:
    // 可取消 - select 点击效果
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.didSelectItem(collectionView,indexPath);
}
//返回这个 `UICollectionView`某个cell 是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - scrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.scrollViewWillBeginDraggingInCV) {
        self.scrollViewWillBeginDraggingInCV(scrollView);
    }
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollToTopInCV) {
        self.scrollViewDidScrollToTopInCV(scrollView);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollViewDidScrollInCV) {
        self.scrollViewDidScrollInCV(scrollView);
    }
}
// scrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollViewDidEndDraggingInNWF) {
        self.scrollViewDidEndDraggingInNWF(scrollView, decelerate);
    }
}
// scrollview 开始减速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewWillBegingDeceleratingInNWF) {
        self.scrollViewWillBegingDeceleratingInNWF(scrollView);
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollViewDidEndDecelerating) {
        self.scrollViewDidEndDecelerating(scrollView);
    }
}




@end
