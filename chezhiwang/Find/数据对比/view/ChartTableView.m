//
//  ChartTableView.m
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartTableView.h"
#import "ChartTableViewCell.h"
#import "UICollectionView+Chart.h"

@interface ChartTableView ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    CGPoint  collectionViewContentSize;
}
@end

@implementation ChartTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {

        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.bounces = NO;
        self.dataSource = self;
        self.delegate = self;
    }

    return self;
}

+ (instancetype)initWithFrame:(CGRect)frame{
    ChartTableView *chart = [[ChartTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    return chart;
}

- (void)setTopOffset:(CGPoint)topOffset
{
    _topOffset = topOffset;
    //设置头部collectionView的滑动坐标，下部tableview里cell中collectionView滑动坐标跟个改变
    for (ChartTableViewCell* cell in self.visibleCells) {
        cell.collectionView.contentOffset = _topOffset;
    }
}

- (CGFloat)itemWidth{
    if (_itemWidth == 0) {
        return _itemWidth = 110;
    }
    return  _itemWidth;
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == self) {

        //当前tableview滑动
        [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_contentTableViewContentOffset];
    }
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        if (scrollView.contentOffset.y != 0) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
            return;
        }
        @synchronized(self)
        {
            //当前cell中collectionView滑动
            collectionViewContentSize = scrollView.contentOffset;

            //通知头部collectonView滑动
            [self setValue:[NSValue valueWithCGPoint:scrollView.contentOffset] forKey:Excel_collectionViewContentOffset];
            //改变tableView中出现在界面上的所以collectionView滑动坐标
            for (ChartTableViewCell* cell in self.visibleCells) {
                cell.collectionView.contentOffset = scrollView.contentOffset;

            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ChartSectionModel *sectionModel = self.sectionModels[section];
    return sectionModel.rowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
    if (!cell) {
        cell = [[ChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;


    }
    [cell.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;

    ChartSectionModel *sectionModel = self.sectionModels[indexPath.section];
    ChartRowModel *rowModel = sectionModel.rowModels[indexPath.row];
    cell.collectionView.itemModels = rowModel.itemModels;
    cell.collectionView.path = indexPath;
   //重新设置collectionView滑动坐标
    cell.collectionView.contentOffset = collectionViewContentSize;
    cell.collectionView.theCellHeight = rowModel.cellHeight;
    cell.collectionView.rowTextColor = rowModel.textColor;
    [cell.collectionView reloadData];

    cell.nameLabel.text = rowModel.name;
    cell.nameLabel.textColor = rowModel.textColor;

    return cell;

}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChartSectionModel *sectionModel = self.sectionModels[indexPath.section];
    ChartRowModel *rowModel = sectionModel.rowModels[indexPath.row];

    return rowModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    ChartSectionModel *sectionMdoel = self.sectionModels[section];
    if (sectionMdoel.name == nil && section == 0) {
       return 0;
    }
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ChartSectionModel *sectionMdoel = self.sectionModels[section];
    if (sectionMdoel.name == nil && section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB_color(234, 236, 239, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = colorBlack;
    [view addSubview:titleLabel];

    UILabel *zhushiLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH-200, 0, 180, 30)];
    zhushiLabel.font = [UIFont systemFontOfSize:13];
    zhushiLabel.textColor = colorLightGray;
    zhushiLabel.textAlignment = NSTextAlignmentRight;
    zhushiLabel.text = @"● 标配 ○ 选配 - 无";
    [view addSubview:zhushiLabel];


    titleLabel.text = sectionMdoel.name;
    return view;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return collectionView.itemModels.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.layer.borderWidth = 0.5;
    cell.contentView.layer.borderColor = colorLineGray.CGColor;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:cell.bounds];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = colorDeepGray;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
        }];
    }
    label.textColor = collectionView.rowTextColor;
    ChartItemModel *itemModel = collectionView.itemModels[indexPath.row];
    label.textAlignment =  NSTextAlignmentCenter;

    if (itemModel.attribute) {
        if (collectionView.path.section == 0 && collectionView.path.row == 4) {
            label.textAlignment = NSTextAlignmentLeft;
        }
        label.attributedText = itemModel.attribute;

    }else{
        label.text = itemModel.name;
    }
    if (itemModel.isborder == NO) {
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        cell.contentView.layer.borderColor = colorLineGray.CGColor;
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(self.itemWidth, collectionView.theCellHeight);
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
