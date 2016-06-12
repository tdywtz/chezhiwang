//
//  ComplainListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainListViewController.h"
#import "ComplainListCell.h"
#import "ComplainDetailsViewController.h"
#import "ComplainSearchViewController.h"
#import "ComplainView.h"
#import "LoginViewController.h"

@interface ComplainListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    BOOL header;
    CGFloat cellheight;
    
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    NSInteger _count;
    CustomActivity *activity;
    
    FmdbManager *_fmdb;
}
@property (nonatomic,strong) NSArray *readArray;
@end

@implementation ComplainListViewController

-(void)loadDataP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForZLTS],p,s];
   [HttpRequest GET:url success:^(id responseObject) {
       if (_count == 1) {
           [_dataArray removeAllObjects];
           
       }
       for (NSDictionary *dict in responseObject) {
           
           [_dataArray addObject:dict];
       }
       self.readArray = [_fmdb selectAllFromReadHistory:ReadHistoryTypeComplain];
       [_tableView reloadData];
       [headerView endRefreshing];
       [footView endRefreshing];
       [activity animationStoping];

   } failure:^(NSError *error) {
       [headerView endRefreshing];
       [footView endRefreshing];
       [activity animationStoping];

   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self dataInitialization];
    [self createLeftItem];
    [self createRightItem];
    [self createTableView];
    
    header = YES;
    
 
        [self loadDataP:1 andS:10];
        activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
        [self.view addSubview:activity];
        [activity animationStarting];
}

//初始化数据
-(void)dataInitialization{
    _dataArray = [[NSMutableArray alloc] init];
    _fmdb = [FmdbManager shareManager];
    self.readArray = [_fmdb selectAllFromReadHistory:ReadHistoryTypeComplain];
}

-(void)createLeftItem{
       self.navigationItem.leftBarButtonItem = [LHController createComplainItemWthFrame:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(leftItemClick)];
}

-(void)leftItemClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        ComplainView *complain = [[ComplainView alloc] init];
        complain.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complain animated:YES];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypeToComplainView;
        my.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:my animated:YES];
    }
}

- (void)createTableView{
   
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    headerView.delegate = self;
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    footView.delegate = self;
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
    
    ComplainListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ComplainListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setCellHeight:^(CGFloat gao) {
        cellheight = gao;
    }];
    cell.readArray = self.readArray;
    cell.dictionary = _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        return cellheight;
    }
    
    return [ComplainListCell returnCellHeight:_dataArray[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
    NSDictionary *dict = _dataArray[indexPath.row];
    detail.textTitle = dict[@"question"];
    detail.cid = dict[@"cpid"];
    detail.type = @"2";
//改变颜色
    ComplainListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *title = (UILabel *)[cell valueForKey:@"questionLable"];
    title.textColor = colorDeepGray;
//存储数据库
    [_fmdb insertIntoReadHistoryWithId:dict[@"cpid"] andTitle:dict[@"question"] andType:ReadHistoryTypeComplain];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == headerView) {
        header = YES;
        _count = 1;
    }else{
        if (_count < 1) {
            _count = 1;
        }
        _count ++;
    }
    [self loadDataP:_count andS:10];
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
