//
//  LookCarViewController.m
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LookCarViewController.h"
#import "LCSeriesViewController.h"
#import "ChooseTableView.h"

@interface LookCarViewController ()
{
    ChooseTableView *chooseTabel;
}

@end

@implementation LookCarViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = @"找车";
    
    self.isIndex = YES;
    self.isShowSection = YES;
    self.isShowImage = YES;


    chooseTabel = [[ChooseTableView alloc] initWithFrame:CGRectMake(WIDTH, 64,WIDTH - WIDTH/3, HEIGHT-64) style:UITableViewStylePlain];
    chooseTabel.backgroundColor = [UIColor whiteColor];
    chooseTabel.layer.shadowColor = [UIColor blackColor].CGColor;
    chooseTabel.layer.shadowOffset = CGSizeMake(-5, 3);
    chooseTabel.layer.shadowOpacity = 0.5;
    chooseTabel.isShowImage = YES;
    chooseTabel.isShowSection = YES;
    __weak __typeof(self)_self = self;
    chooseTabel.didSelectedRow = ^(ChooseTableViewModel *model){
        LCSeriesViewController *lc = [[LCSeriesViewController alloc] init];
        lc.seriesID = model.ID;
        lc.title = model.title;
        [_self.navigationController pushViewController:lc animated:YES];
        NSMutableArray *arr = [_self.navigationController.viewControllers mutableCopy];
        [arr removeObject:_self];
        for (int i = 0; i < arr.count; i ++) {
            UIViewController *vc = arr[i];
            if (i == 0) {
                 vc.hidesBottomBarWhenPushed = NO;
            }else {
                 vc.hidesBottomBarWhenPushed = YES;
            }
        }
        _self.navigationController.viewControllers = arr;
    };

    
    [chooseTabel addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];


    [self.view addSubview:chooseTabel];

    [self loadData];
}



- (void)loadData{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpRequest GET:[URLFile urlStringForLetter] success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        NSMutableArray *mArray = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"letter"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"brand"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"id"];
                model.title = subDic[@"name"];
                model.imageUrl = subDic[@"logo"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        self.sectionModels = mArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 滑动
-(void)pan:(UIPanGestureRecognizer *)pan{

    CGPoint point = [pan translationInView:self.view];

    if (point.x+pan.view.frame.origin.x > WIDTH/3) {
        pan.view.center = CGPointMake(point.x+pan.view.center.x, pan.view.center.y);
        [pan setTranslation:CGPointZero inView:self.view];
    }

    if (pan.state == UIGestureRecognizerStateEnded) {
        if (pan.view.frame.origin.x< WIDTH/3+30) {
            [self showChooseTable:YES];
        }else{
           [self showChooseTable:NO];
        }
    }
}

- (void)showChooseTable:(BOOL)show{
    if (show) {
        chooseTabel.lh_left = WIDTH;
        [UIView animateWithDuration:0.3 animations:^{
            chooseTabel.lh_left = WIDTH/3;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            chooseTabel.lh_left = WIDTH;
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseTableViewSectionModel *sectionModel = self.sectionModels[indexPath.section];
    ChooseTableViewModel *model = sectionModel.rowModels[indexPath.row];
    [self loadModelData:model.ID];
    [self showChooseTable:YES];
}

- (void)loadModelData:(NSString *)bid{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForSeries],bid];
    [HttpRequest GET:url success:^(id responseObject) {


        NSMutableArray *mArray = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in responseObject[@"rel"]) {
            ChooseTableViewSectionModel *sectionModel = [[ChooseTableViewSectionModel alloc] init];
            sectionModel.title = dict[@"brands"];

            NSMutableArray *rowModels = [[NSMutableArray alloc] init];
            for (NSDictionary *subDic in dict[@"series"]) {
                ChooseTableViewModel *model = [[ChooseTableViewModel alloc] init];
                model.ID = subDic[@"seriesid"];
                model.title = subDic[@"seriesname"];
                model.imageUrl = subDic[@"logo"];
                [rowModels addObject:model];
            }
            sectionModel.rowModels = rowModels;
            [mArray addObject:sectionModel];
        }
        chooseTabel.sectionModels = mArray;
        [chooseTabel.tableView reloadData];

    } failure:^(NSError *error) {

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
