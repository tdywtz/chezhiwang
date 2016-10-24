//
//  TopCollectionView.m
//  chezhiwang
//
//  Created by bangong on 16/8/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TopCollectionView.h"
#import "TopCollectionViewCell.h"
#import "ChartTableView.h"

@interface TopCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@end

@implementation TopCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
         self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    }
    return self;
}


/**选择车型信息*/
- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block{
    self.block = block;
}
/**取消选择*/
- (void)cancel:(void (^)(TopCollectionViewModel *topModel))cancel{
    self.cancel = cancel;
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_topCollectionViewContentOffset];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.parentViewController = self.parentViewController;
    cell.topModel = self.topModels[indexPath.row];
    cell.topModel.index = indexPath.row;
    //回调数据
    [cell ruturnModel:self.block];
    [cell cancel:self.cancel];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.itemWidth, self.frame.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
