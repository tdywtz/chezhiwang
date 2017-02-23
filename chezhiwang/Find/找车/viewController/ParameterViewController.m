//
//  ParameterViewController.m
//  chezhiwang
//
//  Created by bangong on 17/1/5.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "ParameterViewController.h"
#import "ParameterChartView.h"
#import "ChooseTableViewController.h"

@interface ParameterViewController ()
{
    ParameterChartView *chartView;
}
@end

@implementation ParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak __typeof(self)weakSelf = self;

    chartView = [[ParameterChartView alloc] initWithFrame:CGRectMake(0, _contentInsets.top, WIDTH, HEIGHT - _contentInsets.top)];
    [chartView setBlock:^(ParameterTopModel *topModel) {

        [weakSelf loadTopData:topModel choose:YES];

    }];
    [chartView setCancel:^(ParameterTopModel *topModel) {
        [weakSelf deleteQueue:topModel.index];

    }];
    [self.view addSubview:chartView];
    [self loadData];
}

- (void)loadTopData:(ParameterTopModel *)topModel choose:(BOOL)choose{

    __weak __typeof(self)weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:[URLFile urlStringForModelList],_seriesID];
    [HttpRequest GET:urlString success:^(id responseObject) {

        ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
        NSMutableArray *rowModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
            model.ID = dict[@"mid"];
            model.title = dict[@"modelname"];
            [rowModels addObject:model];
        }
        sectionModel.rowModels = rowModels;
        if (choose) {
            [weakSelf setPushChoose:@[sectionModel] topMdoel:topModel];
        }else if(rowModels.count){
            ChooseTableViewModel *model = rowModels[0];

            ParameterTopModel *one = [ParameterTopModel modelWithString:model.title];
            one.isModelName = YES;
            one.ID = model.ID;
            [weakSelf insertTopModel:one index:topModel.index];
            [weakSelf loadValue:self.seriesID mid:model.ID];
        }

    } failure:^(NSError *error) {

    }];
}


- (void)setPushChoose:(NSArray *)sectionModels topMdoel:(ParameterTopModel *)topModel{
    __weak __typeof(self)weakSelf = self;

    NSMutableArray *selecteds = [NSMutableArray array];
    for (ParameterTopModel *model in chartView.topModels) {
        if (model.ID) {
            [selecteds addObject:model.ID];
        }
    }
    ChooseTableViewController *choose = [[ChooseTableViewController alloc] init];
    choose.sectionModels = sectionModels;
    choose.selectId = selecteds;
    choose.didSelectedRow = ^(ChooseTableViewModel *model){
        ParameterTopModel *one = [ParameterTopModel modelWithString:model.title];
        one.isModelName = YES;
        one.ID = model.ID;
        [weakSelf insertTopModel:one index:topModel.index];

        [weakSelf loadValue:self.seriesID mid:model.ID];
    };

    BasicNavigationController *nvc = [[BasicNavigationController alloc] initWithRootViewController:choose];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)insertTopModel:(ParameterTopModel *)one index:(NSInteger)index{
    NSMutableArray *topModels = [chartView.topModels mutableCopy];
    if (topModels) {
        [topModels insertObject:one atIndex:index];
    }
    //只显示4组
    if (topModels.count > 4 && one.isModelName == NO) {
        one.isHide = YES;
    }
    chartView.topModels = topModels;
    [chartView leftTopInitialSetting];
    [chartView reloadData];
}

- (void)deleteQueue:(NSInteger)index{
    NSArray *sections = chartView.sectionModels;
    for (ChartSectionModel *sectionModel in sections) {
        for (ChartRowModel *rowModel in sectionModel.rowModels) {
            NSMutableArray *items = [rowModel.itemModels mutableCopy];
            [items removeObjectAtIndex:index];
            rowModel.itemModels = items;
        }
    }
    NSMutableArray *topArr = [chartView.topModels mutableCopy];
    [topArr removeObjectAtIndex:index];
    if (topArr.count < 5 && topArr.count > 0) {
        for ( ParameterTopModel *topModel in topArr) {
             topModel.isHide = NO;
        }
    }
    chartView.topModels = topArr;
    [chartView leftTopInitialSetting];
    [chartView reloadData];
}

- (void)loadData{
    NSMutableArray *sectionModelArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:[URLFile urlString_mConfig] success:^(id responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];

        for (int i = 0; i <  [responseObject[@"rel"] count]; i ++) {
            NSDictionary *superDict = responseObject[@"rel"][i];

            ChartSectionModel *sectionModel = [[ChartSectionModel alloc] init];
            sectionModel.name = superDict[@"name"];
            int temp = 0;
            if (i == 0) {
                //基本参数数组前两个数据剔除，从第三个开始取值
                temp = 2;
            }
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (int j = temp; j < [superDict[@"paramitems"] count]; j ++) {
                NSDictionary *dict = superDict[@"paramitems"][j];
                ChartRowModel *rowModel = [[ChartRowModel alloc] init];
                rowModel.name = dict[@"name"];

                rowModel.itemModels = @[[ChartItemModel new]];

                [rows addObject:rowModel];
            }

            sectionModel.rowModels = rows;
            [sectionModelArray addObject:sectionModel];
        }
        chartView.sectionModels = sectionModelArray;
        [chartView reloadData];
        if (chartView.topModels.count) {
            [self loadTopData:[chartView.topModels lastObject] choose:NO];
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadValue:(NSString *)sid mid:(NSString *)mid{
    NSArray *sectionModelArray = chartView.sectionModels;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@&sid=%@&mid=%@",[URLFile urlString_mConfig],sid,mid];
    [HttpRequest GET:url success:^(id responseObject) {
        for (int i = 0; i <  sectionModelArray.count; i ++) {
            if ([responseObject[@"rel"] count] <= i) {
                break;
            }
            NSDictionary *superDict = responseObject[@"rel"][i];
            ChartSectionModel *sectionModel = sectionModelArray[i];

            int temp = 0;
            if (i == 0) {
                //基本参数数组前两个数据剔除，从第三个开始取值
                temp = 2;
            }
            NSArray *rows = sectionModel.rowModels;
            for (int j = 0; j < rows.count; j ++) {
                if ([superDict[@"paramitems"] count] <= j+temp) {
                    break;
                }
                NSDictionary *dict = superDict[@"paramitems"][j+temp];
                ChartRowModel *rowModel = rows[j];

                NSMutableArray *items = [rowModel.itemModels mutableCopy];
                ChartItemModel *itemModel = [[ChartItemModel alloc] init];
                if ([dict[@"valueitems"] isKindOfClass:[NSArray class]]) {
                    if ([dict[@"valueitems"] count]) {
                         itemModel.name = [dict[@"valueitems"][0][@"value"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];

                    }
                }

                itemModel.isborder = YES;
                if (items == nil) {
                    items = [NSMutableArray array];
                }
                if (items.count == 0) {
                    [items addObject:itemModel];
                    [items addObject:[ChartItemModel new]];
                }else{
                    [items insertObject:itemModel atIndex:items.count-1];
                }
                rowModel.itemModels = items;
            }
        }
       // chartView.sectionModels = sectionModelArray;
        [chartView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
