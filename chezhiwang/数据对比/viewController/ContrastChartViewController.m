//
//  ContrastChartViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ContrastChartViewController.h"
#import "ChartView.h"

@interface ContrastChartViewController ()
{

    NSMutableArray *sectionModelArray;
    ChartView *_chartView;
}
@end

@implementation ContrastChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftItemBack];

    sectionModelArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"车型信息",@"投诉数量",@"厂家回复率",@"用户满意度",@"典型故障"];
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; i ++) {
        ChartRowModel *rowModel = [[ChartRowModel alloc] init];
        rowModel.name = array[i];
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (int j = 0; j < 4; j ++) {
            ChartItemModel *itemModel = [[ChartItemModel alloc] init];
            [items addObject:itemModel];
        }
        rowModel.itemModels = items;
        [rows addObject:rowModel];
    }
    ChartSectionModel *sectionModel = [[ChartSectionModel alloc] init];
    sectionModel.rowModels = rows;

    [sectionModelArray addObject:sectionModel];



    _chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _chartView.itemWidth = 100;
    _chartView.parentViewController = self;
    [self.view addSubview:_chartView];
    __weak __typeof(self)weakSelf = self;
    [_chartView ruturnModel:^(TopCollectionViewModel *topModel) {
       // [weakSelf releaesItemDataWithQueue:topModel.index];
        [weakSelf loadSectionOneValueListWithBrandId:topModel.brandId seriesId:topModel.seriesId modelId:topModel.modelId queue:topModel.index];
        if ([topModel.modelId integerValue]) {
            [weakSelf loadDataValueListWithSeriesId:topModel.seriesId modelId:topModel.brandId queue:topModel.index];
        }

    }];


  [_chartView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
  }];

    [self loadDataNameList];
}


-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:0] forKey:@"forCellWithReuseIdentifier"];
}

//清除列数据
- (void)releaesItemDataWithQueue:(NSInteger)queue{
    for (int i = 0; i < _chartView.sectionModels.count; i ++) {
        ChartSectionModel *sectionModel = _chartView.sectionModels[i];

        for (int j = 0; j < sectionModel.rowModels.count; j ++) {

            ChartRowModel *rowModel = sectionModel.rowModels[j];

            ChartItemModel *itemModel = rowModel.itemModels[queue];
            [itemModel releaseData];
        }
    }
    [_chartView reloadData];
}

//加载第一列数据
- (void)loadDataNameList{

    [HttpRequest GET:[URLFile urlString_mConfig] success:^(id responseObject) {
        for (int i = 0; i <  [responseObject[@"rel"] count]; i ++) {
            NSDictionary *superDict = responseObject[@"rel"][i];

            ChartSectionModel *sectionModel = [[ChartSectionModel alloc] init];
            sectionModel.name = superDict[@"name"];
            int temp = 0;
            if (i == 0) {
                temp = 2;
            }
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (int j = temp; j < [superDict[@"paramitems"] count]; j ++) {
                NSDictionary *dict = superDict[@"paramitems"][j];
                ChartRowModel *rowModel = [[ChartRowModel alloc] init];
                rowModel.name = dict[@"name"];

                NSMutableArray *items = [[NSMutableArray alloc] init];
                for (int k = 0; k < 4; k ++) {
                    ChartItemModel *itemModel = [[ChartItemModel alloc] init];
                    [items addObject:itemModel];
                }
                rowModel.itemModels = items;
                [rows addObject:rowModel];
            }

            sectionModel.rowModels = rows;
            [sectionModelArray addObject:sectionModel];
        }
        _chartView.sectionModels = sectionModelArray;
        [_chartView reloadData];

    } failure:^(NSError *error) {

    }];
   //表格头部数据
    NSArray *arr = [[NSArray alloc] initWithObjects:[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init],[[TopCollectionViewModel alloc] init], nil];
    [_chartView setTopModels:arr];
}

//加载右侧值列
- (void)loadDataValueListWithSeriesId:(NSString *)seriesId modelId:(NSString *)modeId queue:(NSInteger)queue{
    NSString *url = [NSString stringWithFormat:@"%@&sid=%@&mid=%@",[URLFile urlString_mConfig],seriesId,modeId];
    [HttpRequest GET:url success:^(id responseObject) {
        NSArray *array = responseObject[@"rel"];
        for (int i = 1; i < _chartView.sectionModels.count; i ++) {
            ChartSectionModel *sectionModel = _chartView.sectionModels[i];
            //如果 下标 大于 越界，跳出循环
            if (i-1 > array.count-1) {
                break;
            }

            NSDictionary *dict = array[i-1];
            //
            for (int j = 0; j < sectionModel.rowModels.count; j ++) {

                int temp = 0;
                if (i-1 == 0) {
                    //基本参数数组前两个数据剔除，从第三个开始取值
                    temp = 2;
                }
                if (j+temp > [dict[@"paramitems"] count]-1) {
                    break;
                }
                NSDictionary *rowDict = dict[@"paramitems"][j+temp];
                //如果数组长度为零，跳出循环
                if ([rowDict[@"valueitems"] count] == 0) {
                    break;
                }
                ChartRowModel *rowModel = sectionModel.rowModels[j];

                ChartItemModel *itemModel = rowModel.itemModels[queue];
                NSDictionary *itemDict = rowDict[@"valueitems"][0];
                itemModel.name = itemDict[@"value"];
            }
        }
        [_chartView reloadData];

    } failure:^(NSError *error) {

    }];
}

//sectionOne概况信息
- (void)loadSectionOneValueListWithBrandId:(NSString *)brandId seriesId:(NSString *)seriesId modelId:(NSString *)modeId queue:(NSInteger)queue{
    if (seriesId == nil) {
        seriesId = @"";
    }
    if (modeId == nil) {
        modeId = @"";
    }
    NSString *url = [NSString stringWithFormat:[URLFile urlString_dbInfo],brandId,seriesId,modeId];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:url success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {

    }];
}



-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortraitUpsideDown;
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
