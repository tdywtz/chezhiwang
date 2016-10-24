//
//  AnswerListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerListViewController.h"
#import "HomepageAnswerCell.h"
#import "AnswerDetailsViewController.h"


@interface AnswerListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    NSInteger _count;
}
@end

@implementation AnswerListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = @"0";
    }
    return self;
}
-(void)loadData{
   
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForZJDY],self.type,_count];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:url success:^(id responseObject) {
        
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }
        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }

        [_dataArray addObjectsFromArray:[HomepageAnswerModel arayWithArray:responseObject[@"rel"]]];

        [weakSelf.tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _count = 1;
    _dataArray = [[NSMutableArray alloc] init];
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomepageAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomepageAnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.answerModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailsViewController *detail = [[AnswerDetailsViewController alloc] init];
    HomepageAnswerModel *model = _dataArray[indexPath.row];
    detail.cid = model.ID;

    //存储数据库
    [[FmdbManager shareManager] insertIntoReadHistoryWithId:model.ID andTitle:model.question andType:ReadHistoryTypeAnswer];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
