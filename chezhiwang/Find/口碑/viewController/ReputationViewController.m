//
//  ReputationViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ReputationViewController.h"
#import "ReputationCell.h"
#import "CZWRootToolBar.h"
#import "ChooseTableView.h"
#import "LCReputationViewController.h"
#import "LCReputationDetailsViewController.h"

@interface ReputationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
    NSString *_iOrder;
    CZWRootToolBar *_toolbar;
    LCReputationChangeView *changeView;
    ChooseTableView *chooseView;

    NSString *brandId;
    NSString *seriesId;
    NSString *modelId;
}
@end

@implementation ReputationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"口碑";
    _count = 1;
    _dataArray = [NSMutableArray array];


    _toolbar = [[CZWRootToolBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(_toolbar)wealBar = _toolbar;
    [_toolbar chooseClickButton:^(UIButton *button, NSInteger index, BOOL select) {
        if (select == YES) {
            if (index == 0) {
                brandId = seriesId = modelId = nil;
            }else if (index == 1){
                seriesId = modelId = nil;
            }else{
                modelId = nil;
            }
            _count = 1;
            [weakSelf showChooseView:NO];
            [weakSelf loadData];
        }else{
            if (chooseView == nil) {
                CGRect sRect = CGRectMake(0, _toolbar.lh_bottom, WIDTH, HEIGHT - _toolbar.lh_bottom);
                chooseView = [[ChooseTableView alloc] initWithFrame:sRect style:UITableViewStylePlain];
                chooseView.hidden = YES;
                [self.view addSubview:chooseView];
            }

            if (index == 0) {
                 chooseView.isIndex = YES;
            }else{
                chooseView.isIndex = NO;
            }
            if (index == 0 || index == 1) {
                chooseView.isShowSection = YES;
                chooseView.isShowImage = YES;
            }else{
                chooseView.isShowSection = NO;
                chooseView.isShowImage = NO;
            }
            chooseView.sectionModels = nil;
            [chooseView.tableView reloadData];
            
            [chooseView setDidSelectedRow:^(ChooseTableViewModel *model) {
                if (index == 0) {
                    brandId = model.ID;
                }else if (index == 1){
                    seriesId = model.ID;
                }else{
                    modelId = model.ID;
                }
                _count = 1;
                [weakSelf showChooseView:NO];
                [weakSelf loadData];
                [wealBar setTitle:model.title andButton:button];
            }];
            [weakSelf showChooseView:YES];
//
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [weakSelf loadChooseDataWithIndex:index result:^(NSArray<ChooseTableViewSectionModel *> *sectionModels) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                chooseView.sectionModels = sectionModels;
                [chooseView.tableView reloadData];
            }];
        }
    }];

    changeView = [[LCReputationChangeView  alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [changeView setChange:^(NSInteger index) {
        _iOrder = index == 0 ? @"0" : @"1";
        _count = 1;
        [weakSelf loadData];
    }];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    _iOrder = @"0";
    _count = 1;
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{

        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;


    _toolbar.lh_top = 64;

    changeView.lh_top = _toolbar.lh_bottom;

    _tableView.lh_top = changeView.lh_bottom;
    _tableView.lh_height -= changeView.lh_bottom;

    [self.view addSubview:_toolbar];
    [self.view addSubview:changeView];
    [self.view addSubview:_tableView];
}


- (void)loadChooseDataWithIndex:(NSInteger)index result:(void(^)(NSArray<ChooseTableViewSectionModel *> * sectionModels))result{

    if (index == 0) {
        [ChooseTableViewSectionModel brand:result];
    }else if (index == 1){
        [ChooseTableViewSectionModel seriesWithBid:brandId result:result];
    }else{
        [ChooseTableViewSectionModel modelWithSid:seriesId result:result];
    }
}

- (void)loadData{_tableView.contentOffset = CGPointZero;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequest GET:[URLFile url_reputationlistWithBid:brandId sid:seriesId mid:modelId ID:nil iOrder:_iOrder p:_count s:5] success:^(id responseObject) {
        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[ReputationModel mj_objectArrayWithKeyValuesArray:responseObject[@"rel"]]];
        [_tableView reloadData];
        if (_count == 1) {
             _tableView.contentOffset = CGPointZero;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)showChooseView:(BOOL)show{

    [self.view bringSubviewToFront:chooseView];
    if (show) {
        chooseView.hidden = NO;
        chooseView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            chooseView.alpha = 1;
        }];
    }else{

        chooseView.sectionModels = nil;
        [UIView animateWithDuration:0.3 animations:^{
            chooseView.alpha = 0;

        } completion:^(BOOL finished) {
            chooseView.hidden = YES;
            
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReputationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ReputationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReputationModel *model = _dataArray[indexPath.row];
    LCReputationDetailsViewController *details = [[LCReputationDetailsViewController alloc] init];
    details.ID = model.ID;
    [self.navigationController pushViewController:details animated:YES];
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
