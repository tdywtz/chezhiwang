


//
//  BrandCollectionView.m
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BrandCollectionView.h"
#import "VehicleImageCell.h"
#import "VehicleSeriesImageViewController.h"

@interface BrandCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataArray;
}
@end

@implementation BrandCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _dataArray = [[NSMutableArray alloc] init];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[VehicleImageCell class] forCellWithReuseIdentifier:@"cellName"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerName"];
        
    }
    return self;
}


- (void)loadData{

    NSString * url = [NSString stringWithFormat:@"%@&bid=%@",[URLFile urlString_modelPlicList],self.bid];
   // url = [NSString stringWithFormat:@"%@&p=%ld&s=10"];
    [HttpRequest GET:url success:^(id responseObject) {
        [_dataArray removeAllObjects];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            [_dataArray addObject:dict];
        }
        [self reloadData];
       
    } failure:^(NSError *error) {

    }];
}

- (void)setBid:(NSString *)bid{
    _bid = bid;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray[section][@"minbrand"] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VehicleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellName" forIndexPath:indexPath];
    [cell setDictionary:_dataArray[indexPath.section][@"minbrand"][indexPath.row]];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){

        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerName" forIndexPath:indexPath];
        reusableview.backgroundColor = RGB_color(237, 238, 239, 1);
        UILabel *label = (UILabel *)[reusableview viewWithTag:100];
        if (!label) {
            label = [[UILabel alloc] init];
            label.textColor = colorLightGray;
            label.font = [ UIFont systemFontOfSize:14];
            label.tag = 100;
            [reusableview addSubview:label];
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.centerY.equalTo(0);
            }];
        }
        label.text = _dataArray[indexPath.section][@"brandname"];
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    VehicleSeriesImageViewController *vc = [[VehicleSeriesImageViewController alloc] init];
    NSDictionary *dict = _dataArray[indexPath.section][@"minbrand"][indexPath.row];
    vc.sid = dict[@"sid"];
    vc.title = dict[@"seriesname"];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat width = self.frame.size.width/2-22.5;
     return CGSizeMake(width, width*(145.0/217.0)+30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(CGRectGetWidth(self.frame), 40);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
