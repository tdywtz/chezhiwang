




//
//  VehicleSeriesImageViewController.m
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "VehicleSeriesImageViewController.h"
#import "CollectionSectionView.h"
#import "VehicleSeriesSctionModel.h"
#import "ImageShowViewController.h"
#import "VehicleImageCell.h"
#import "CollectionSectionView.h"
#import "MoreImagesViewController.h"

@interface VehicleSeriesImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray   *_dataArray;
    VehicleSeriesSctionModel   *_sectionOneModel;

    NSString *_mid;//车型id
    NSInteger selectRow;//第一组选择被选中项
}
@end

@implementation VehicleSeriesImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mid = @"";
    _sectionOneModel = [[VehicleSeriesSctionModel alloc] init];
    _dataArray = [[NSMutableArray alloc] init];


    [self createCollectionView];
    [self loadDataSectionOne];
}

- (void)loadDataSectionOne{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@&bid=%@&sid=%@&mid=%@",[URLFile urlString_modelPlicList],self.bid,self.sid,_mid];
    [HttpRequest GET:url success:^(id responseObject) {

        _sectionOneModel.serieslist = responseObject[@"rel"];
        _sectionOneModel.selectRow = 0;
        if (_sectionOneModel.serieslist.count) {
            _mid = _sectionOneModel.serieslist[0][@"mid"];
        }

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadData];
    } failure:^(NSError *error) {
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@&bid=%@&sid=%@&mid=%@",[URLFile urlString_modelPlicList],self.bid,self.sid,_mid];
    [HttpRequest GET:url success:^(id responseObject) {

        [_dataArray removeAllObjects];
        [_dataArray addObject:_sectionOneModel];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            VehicleSeriesSctionModel *sectionModel = [VehicleSeriesSctionModel mj_objectWithKeyValues:dict];
            [_dataArray addObject:sectionModel];
        }
        [_collectionView reloadData];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
   // _collectionView.allowsSelection = NO;
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellOne"];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[CollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (section == 0) {
        return _sectionOneModel.serieslist.count;
    }else{
        VehicleSeriesSctionModel *secionModel = _dataArray[section];
        if (secionModel.open) {
            return secionModel.images.count;
        }
        return secionModel.images.count>6?6:secionModel.images.count;

    }

    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellOne" forIndexPath:indexPath];
        cell.contentView.backgroundColor = RGB_color(237, 238, 239, 1);
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.tag = 100;
            label.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:label];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, WIDTH, 1)];
            lineView.backgroundColor  = colorLineGray;
            [cell.contentView addSubview:lineView];

            [label makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsMake(0, 10, 0, 0));
            }];
        }

        if (indexPath.row == _sectionOneModel.selectRow) {
            label.textColor = colorLightBlue;
        }else{
            label.textColor = colorDeepGray;
        }
        label.text = _sectionOneModel.serieslist[indexPath.row][@"modelname"];
        return cell;

    }else{

        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        UIImageView *imageView = [cell.contentView viewWithTag:100];
        if (!imageView) {
            imageView = [[UIImageView alloc] init];
            //imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = 100;
            [cell.contentView addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsZero);
            }];
        }
        VehicleSeriesSctionModel *sectionModel = _dataArray[indexPath.section];
        NSString *imageUrl = sectionModel.images[indexPath.row][@"url"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        return cell;

    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }
    CollectionSectionView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){

        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        reusableview.section = indexPath.section;
        VehicleSeriesSctionModel *model = _dataArray[indexPath.section];
        reusableview.model = model;
        __weak __typeof(self)weakSelf = self;
        reusableview.block = ^{
//            [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
            MoreImagesViewController *more = [[MoreImagesViewController alloc] init];
            more.model = model;

            more.modelname = _sectionOneModel.serieslist[_sectionOneModel.selectRow][@"modelname"];
            NSInteger num = 0;
            for (int i = 1; i < indexPath.section; i ++) {
                VehicleSeriesSctionModel *sectionModel = _dataArray[i];
                num += sectionModel.images.count;
            }
            more.num = num;
            more.mid = _mid;
            [weakSelf.navigationController pushViewController:more animated:YES];
        };
    }
    return reusableview;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        if (_sectionOneModel.selectRow == indexPath.row) {
            return;
        }
        _sectionOneModel.selectRow = indexPath.row;
        selectRow = indexPath.row;
        _mid = _sectionOneModel.serieslist[indexPath.row][@"mid"];
        [self loadData];

    }else{

        ImageShowViewController *vc = [[ImageShowViewController alloc] init];
        NSInteger num = 0;
        for (int i = 1; i < indexPath.section; i ++) {
             VehicleSeriesSctionModel *model = _dataArray[i];
            num += model.images.count;

        }
        vc.mid = _mid;
        vc.pageIndex = num+indexPath.row;
       
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(WIDTH, 40);
    }
    
    CGFloat width = (self.view.frame.size.width-20-10)/3;
    return CGSizeMake(width, width*(145.0/217.0));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 15, 0);
    }
    return UIEdgeInsetsMake(5, 10, 15, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
