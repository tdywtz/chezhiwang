//
//  ContrasChartCollectionView.m
//  chezhiwang
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ContrasChartCollectionView.h"
#import "XLPlainFlowLayout.h"

@interface ContrasChartCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSInteger KKK;
}
@end

@implementation ContrasChartCollectionView

+ (instancetype)initWithFrame:(CGRect)frame{
   
 
  
    XLPlainFlowLayout *layout = [[XLPlainFlowLayout alloc] init];
    layout.naviHeight = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self _initView];
    
    }
    return self;
}

-(void)_initView
{
    KKK = [[[NSUserDefaults standardUserDefaults] valueForKey:@"forCellWithReuseIdentifier"] integerValue];
    KKK++;
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:KKK] forKey:@"forCellWithReuseIdentifier"];
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;

    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

-(void)setScrollContentOffSet:(CGPoint)contentOffSet{
    self.contentOffset = contentOffSet;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.contentView.layer.borderWidth = 0.5;
    UILabel *label = [cell.contentView viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc]initWithFrame:cell.bounds];
        [cell.contentView addSubview:label];
        label.textColor = [UIColor redColor];
        label.tag = 100;
    }
    label.text = [@(indexPath.row) stringValue];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor lightGrayColor];
        if (KKK%2 == 1) {
            view.backgroundColor = [UIColor orangeColor];
        }
        if (KKK == 1) {
           // view.clipsToBounds = NO;
            UIView *sub = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
            sub.backgroundColor = [UIColor redColor];
            [view addSubview:sub];
        }
        return view;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake(CGRectGetWidth(self.frame), 100);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

     return CGSizeMake(CGRectGetWidth(self.frame), 30);
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


#pragma mark - UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_ChartDelegate && [_ChartDelegate respondsToSelector:@selector(scrollContentOffSet:)])
    {
        [_ChartDelegate scrollContentOffSet:scrollView.contentOffset];
    }
}



@end
