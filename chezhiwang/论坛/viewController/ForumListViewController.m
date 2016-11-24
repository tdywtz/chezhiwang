//
//  ForumListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumListViewController.h"
#import "HomepageForumCell.h"
#import "PostViewController.h"
#import "ForumHeaderView.h"


@interface ForumListViewController ()<UITableViewDataSource,UITableViewDelegate,ForumHeaderViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    NSInteger _orderType;
    NSInteger _topicType;
    NSInteger _count;
}
@end

@implementation ForumListViewController

-(void)loadData{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPostList],_orderType,_topicType,_count];
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
            
            HomepageForumModel *model = [HomepageForumModel mj_objectWithKeyValues:dict];
            [_dataArray addObject:model];
        }

        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _orderType = 0;
    _topicType = 0;
    _count = 1;

    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf createTableView];
        [weakSelf createHeaderView];
       
    });
}



-(void)createTableView{

    [self.view addSubview:[[UIView alloc] init]];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
    [self.view addSubview:_tableView];


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

-(void)createHeaderView{

    ForumHeaderView *headerView = [[ForumHeaderView alloc] initWithFrame:CGRectMake(0,64, WIDTH, 40)];
    headerView.delegate = self;
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];

}


#pragma mark - ForumHeaderViewDelegate
- (void)didSelectOrderType:(NSInteger)orderType topicType:(NSInteger)topicType{
    _count = 1;
    _orderType = orderType;
    _topicType = topicType;
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomepageForumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomepageForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.forumModel = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        HomepageForumModel *model = _dataArray[indexPath.row];

        PostViewController *detail = [[PostViewController alloc] init];
        detail.tid = model.tid;
        detail.titleText = model.title;

        //存储数据库
        detail.hidesBottomBarWhenPushed = YES;
       // [[FmdbManager shareManager] insertIntoReadHistoryWithId:_dataArray[indexPath.row][@"tid"] andTitle:_dataArray[indexPath.row][@"title"] andType:ReadHistoryTypeForum];
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
