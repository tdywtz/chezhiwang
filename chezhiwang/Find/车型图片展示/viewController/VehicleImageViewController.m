//
//  VehicleImageViewController.m
//  chezhiwang
//
//  Created by bangong on 16/8/10.
//  Copyright © 2016年 车质网. All rights reserved.
//



#import "VehicleImageViewController.h"
#import "VehicleImageCell.h"
#import "ComplainChartView.h"
#import "CehicleChooseViewController.h"
#import "BrandCollectionView.h"
#import "VehicleSeriesImageViewController.h"

@interface VehicleImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSMutableArray   *_dataArray;
    NSInteger         _count;

    BrandCollectionView *_brandColectionView;

    ComplainChartView *choosView;
}
@end

@implementation VehicleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"车型图片";
    _dataArray = [[NSMutableArray alloc] init];

    [self createLeftItemBack];

    [self createHeaderView];
    [self createCollectionView];
    _count = 1;
    [self loadData];
}

- (void)createHeaderView{
    __weak __typeof(self) weakSelf = self;
    choosView = [[ComplainChartView alloc] initWithFrame:CGRectMake(0, 70, WIDTH, 40) titles:@[@"车型属性",@"选择品牌",@"选择车系"] block:^(NSInteger index, BOOL initialSetUp) {

        if (!initialSetUp) {
            _count = 1;

            if (index == 0 || index == 1) {
                [choosView setEnable:YES index:0];
                [choosView setEnable:YES index:1];
                [choosView setEnable:NO index:2];
            }
            if (index == 1) {

                _brandColectionView.hidden = YES;
            }else if (index == 0){

                [weakSelf loadData];
            }


        }else{
            ChartChooseType type = ChartChooseTypeAttributeModel;

            if (index == 1) {
                type = ChartChooseTypeBrand;

            }else if (index == 2){
                type = ChartChooseTypeSeries;
            }
            CehicleChooseViewController *chart = [[CehicleChooseViewController alloc] initWithType:type direction:DirectionRight];
            chart.brandId = [choosView gettidWithIndex:1];
            chart.chooseEnd = ^(NSString *title , NSString *tid){
                if (index == 2) {
                    VehicleSeriesImageViewController *vc = [[VehicleSeriesImageViewController alloc] init];
                    vc.sid = tid;
                    vc.bid = [choosView gettidWithIndex:1];
                    [weakSelf.navigationController pushViewController:vc animated:YES];

                    return ;
                }
                [choosView setTitle:title tid:tid index:index];
                _count = 1;//重置页码

                if (index == 0) {

                    [weakSelf loadData];
                    [choosView setEnable:NO index:1];
                    [choosView setEnable:NO index:2];
                    _brandColectionView.hidden = YES;
                }else if (index == 1){
                    _brandColectionView.bid = tid;
                    [_brandColectionView loadData];
                    _brandColectionView.hidden = NO;

                    [choosView setEnable:NO index:0];
                    [choosView setEnable:YES index:2];

                }
            };
            [weakSelf presentViewController:chart animated:YES completion:nil];

        }
    }];
    [choosView setEnable:NO index:2];
    self.view.backgroundColor = RGB_color(237, 238, 239, 1);
    [self.view addSubview:choosView];
}


- (void)loadData{
    NSString *url = [NSString stringWithFormat:@"%@&attr=%@",[URLFile urlString_modelPlicList],[choosView gettidWithIndex:0]];
    url = [NSString stringWithFormat:@"%@&p=%ld&s=10",url,_count];

    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }

        [_collectionView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_collectionView.mj_footer endRefreshing];
        }

        for (NSDictionary *dict in responseObject[@"rel"]) {
            [_dataArray addObject:dict];
        }

        [_collectionView reloadData];

    } failure:^(NSError *error) {

        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}


- (void)createCollectionView{
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
  //  _collectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    [self.view addSubview:_collectionView];

    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(choosView.bottom);
        make.left.right.bottom.equalTo(0);
    }];


    [_collectionView registerClass:[VehicleImageCell class] forCellWithReuseIdentifier:@"cellName"];

    __weak __typeof(self)weakSelf = self;
//    _collectionView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
//        _count = 1;
//        [weakSelf loadData];
//    }];
//
//    _count = 1;
//    [_collectionView.mj_header beginRefreshing];

    _collectionView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    _collectionView.mj_footer.automaticallyHidden = YES;




    UICollectionViewFlowLayout *layoutTwo= [[UICollectionViewFlowLayout alloc] init];
    layoutTwo.scrollDirection = UICollectionViewScrollDirectionVertical;
    _brandColectionView = [[BrandCollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:layoutTwo];
    _brandColectionView.hidden = YES;
    _brandColectionView.backgroundColor = [UIColor whiteColor];
    //_brandColectionView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    _brandColectionView.parentViewController = self;
    [self.view addSubview:_brandColectionView];

    [_brandColectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView);
    }];


}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VehicleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellName" forIndexPath:indexPath];
    [cell setDictionary:_dataArray[indexPath.row]];
    return cell;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VehicleSeriesImageViewController *vc = [[VehicleSeriesImageViewController alloc] init];
    NSDictionary *dict = _dataArray[indexPath.row];
    vc.sid = dict[@"sid"];
    vc.title = dict[@"seriesname"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    CGFloat width = self.view.frame.size.width/2-22.5;
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
