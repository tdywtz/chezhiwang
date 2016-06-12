//
//  AnswerListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerListViewController.h"
#import "AnswerListModel.h"
#import "AnswerListCell.h"
#import "AnswerDetailsViewController.h"


@interface AnswerListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UIView *_headerView;
    UITableView *_tableView;
    NSMutableArray *_dataArray;

    CGFloat B;
    
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    NSInteger _count;
    CustomActivity *activity;
}
@property (nonatomic,strong) NSArray *readArray;
@end

@implementation AnswerListViewController

-(void)loadData{
   
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForZJDY],self.type,_count,10];
    [HttpRequest GET:url success:^(id responseObject) {
        
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }
        for (NSDictionary *subDic in responseObject) {
            AnswerListModel *model = [[AnswerListModel alloc] init];
            model.question = [subDic objectForKey:@"question"];
            model.answer = [subDic objectForKey:@"answer"];
            model.uid = [subDic objectForKey:@"id"];
            model.date = [subDic objectForKey:@"date"];
            model.type = [subDic objectForKey:@"type"];
            
            [_dataArray addObject:model];
        }
        self.readArray = [[FmdbManager shareManager] selectAllFromReadHistory:ReadHistoryTypeAnswer];
        [headerView endRefreshing];
        [footView endRefreshing];
        [_tableView reloadData];
        [activity animationStoping];

    } failure:^(NSError *error) {
        [headerView endRefreshing];
        [footView endRefreshing];
        [activity animationStoping];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _count = 1;
    B = [LHController setFont];
    self.cidArray = [[NSMutableArray alloc] init];
    [self createTableView];
    _dataArray = [[NSMutableArray alloc] init];
    self.readArray = [[FmdbManager shareManager] selectAllFromReadHistory:ReadHistoryTypeAnswer];
    

    [self createTableView];
    [self loadData];
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];
}

//tableview
-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40+64, WIDTH, HEIGHT-49-40-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    headerView.delegate = self;
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    footView.delegate = self;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AnswerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[AnswerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.readArray = self.readArray;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 125;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerDetailsViewController *detail = [[AnswerDetailsViewController alloc] init];
    AnswerListModel *mdoel = _dataArray[indexPath.row];
    detail.textTitle = mdoel.question;
    detail.cid = mdoel.uid;
    detail.type = @"3";
    
    //改变颜色
    AnswerListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *title = (UILabel *)[cell valueForKey:@"questionLabel"];
    title.textColor = colorDeepGray;
    //存储数据库
    [[FmdbManager shareManager] insertIntoReadHistoryWithId:mdoel.uid andTitle:mdoel.question andType:ReadHistoryTypeAnswer];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == headerView) {
    
        _count = 1;
    }else{
        if (_count < 1) {
            _count = 1;
        }
        _count ++;
    }
    [self loadData];
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
