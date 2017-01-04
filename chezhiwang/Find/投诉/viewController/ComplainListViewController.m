//
//  ComplainListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainListViewController.h"
#import "HomepageComplainCell.h"
#import "ComplainDetailsViewController.h"
#import "ComplainSearchViewController.h"
#import "ComplainViewController.h"
#import "LoginViewController.h"


@interface ComplainListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    CGFloat cellheight;

    NSInteger _count;
    
    FmdbManager *_fmdb;
}
@end

@implementation ComplainListViewController

-(void)loadData{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForZLTS],_count,10];
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
       for (NSDictionary *dict in responseObject[@"rel"]) {
           [_dataArray addObject:[HomepageComplainModel mj_objectWithKeyValues:dict]];
       }

       [_tableView reloadData];


   } failure:^(NSError *error) {
       [_tableView.mj_header endRefreshing];
       [_tableView.mj_footer endRefreshing];
   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"投诉";
    _count = 1;
    
    [self dataInitialization];
    [self creaRightItem];
    [self createTableView];

}

//初始化数据
-(void)dataInitialization{
    _dataArray = [[NSMutableArray alloc] init];
    _fmdb = [FmdbManager shareManager];
}

#pragma mark - 我要投诉
-(void)creaRightItem{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"auto_common_search"] forState:UIControlStateNormal];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake(0, 0, 30, 20);
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *complainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [complainButton setImage:[UIImage imageNamed:@"auto_投诉列表_投诉"] forState:UIControlStateNormal];
    complainButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    complainButton.frame = CGRectMake(0, 0, 30, 20);
    [complainButton addTarget:self action:@selector(complainButtonClick) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    UIBarButtonItem *complainItem = [[UIBarButtonItem alloc] initWithCustomView:complainButton];
    self.navigationItem.rightBarButtonItems = @[searchItem,complainItem];
}

-(void)complainButtonClick{
    
    if ([CZWManager manager].isLogin) {
        ComplainViewController *complain = [[ComplainViewController alloc] init];
        complain.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complain animated:YES];
    }else{

        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
    }
}

- (void)searchButtonClick{
    ComplainSearchViewController *search = [[ComplainSearchViewController alloc] init];
    search.numType = 2;
    search.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:search animated:YES];
}

- (void)createTableView{
   
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];

    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;
}

-(void)createRightItem{
    UIButton *button = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemCLick) Text:nil];
    [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)rightItemCLick{
    
    ComplainSearchViewController *search = [[ComplainSearchViewController alloc] init];
    search.numType = 2;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomepageComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomepageComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.complainModel =  _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageComplainModel *model = _dataArray[indexPath.row];
    ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
    detail.cid = model.cpid;
  
//存储数据库
    [_fmdb insertIntoReadHistoryWithId:model.cpid andTitle:model.question andType:ReadHistoryTypeComplain];
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
