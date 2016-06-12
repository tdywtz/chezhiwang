//
//  ForumListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumListViewController.h"
#import "ForumListCell.h"
#import "PostViewController.h"
#import "ForumClassifyViewController.h"
#import "ForumClassifyTwoController.h"
#import "MyViewController.h"

@interface ForumListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIScrollView *_scrollView;
    UITableView *twoTableView;
    NSArray *_twoDataArray;
    
    UIView *_titleView;
    UIView *_moveView;
    
    NSInteger orderType;
    NSInteger topicType;
    NSInteger _count;
    BOOL header;
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    CustomActivity *activity;
}
@property (nonatomic,strong) NSArray *readArray;
@end

@implementation ForumListViewController

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPostList],orderType,topicType,p,s];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            [_dataArray removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"论坛无网络缓存"];
        }
        for (NSDictionary *dict in responseObject) {
            [_dataArray addObject:dict];
        }
        self.readArray = [[FmdbManager shareManager] selectAllFromReadHistory:ReadHistoryTypeForum];
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

-(void)readData{
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"论坛无网络缓存"];
  
    for (NSDictionary *dict in array) {
        [_dataArray addObject:dict];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _twoDataArray = @[@"品牌论坛",@"栏目论坛"];
   
    self.readArray = [[FmdbManager shareManager] selectAllFromReadHistory:ReadHistoryTypeForum];
    
    [self createCustomTitleView];
    //[self createRightItem];
  
    
    orderType = 0;
    topicType = 0;
    _count = 1;

    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf createTableView];
        [weakSelf createTableHeaderView];
       
    });
    
    [self loadDataWithP:_count  andS:10];
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];

}

-(void)createCustomTitleView{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
    self.navigationItem.titleView = _titleView;
    
    UIButton *btn1 = [LHController createButtnFram:CGRectMake(0, 14, 80, 20) Target:self Action:@selector(titleClick:) Text:@"帖子列表"];
    btn1.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn1.tag = 100;
    btn1.selected = YES;
    [_titleView addSubview:btn1];
    
    UIButton *btn2 = [LHController createButtnFram:CGRectMake(90, 14, 80, 20) Target:self Action:@selector(titleClick:) Text:@"论坛分类"];
    btn2.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.tag = 101;
    [_titleView addSubview:btn2];
    
    _moveView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleView.frame.size.height-3, 80, 3)];
    _moveView.backgroundColor = [UIColor colorWithRed:255/255.0 green:147/255.0 blue:4/255.0 alpha:0.9];
    [_titleView addSubview:_moveView];
}

-(void)titleClick:(UIButton *)btn{
    btn.selected = YES;
    if (btn.tag == 100) {
        [UIView animateWithDuration:0.1 animations:^{
            _scrollView.contentOffset = CGPointZero;
            _moveView.frame = CGRectMake(btn.frame.origin.x, _moveView.frame.origin.y, btn.frame.size.width, _moveView.frame.size.height);
        }];
        
        UIButton *button = (UIButton *)[_titleView viewWithTag:101];
        button.selected = NO;
    }else{
        [UIView animateWithDuration:0.1 animations:^{
           _scrollView.contentOffset = CGPointMake(WIDTH, 0);
           _moveView.frame = CGRectMake(btn.frame.origin.x, _moveView.frame.origin.y, btn.frame.size.width, _moveView.frame.size.height);
        }];
        
        UIButton *button = (UIButton *)[_titleView viewWithTag:100];
        button.selected = NO;

    }
}

-(void)createTableView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _scrollView.contentSize = CGSizeMake(WIDTH*2, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
 
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    headerView.delegate = self;
    footView.delegate = self;
    
    twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    twoTableView.delegate = self;
    twoTableView.dataSource = self;
    twoTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:twoTableView];
    _scrollView.backgroundColor = [UIColor orangeColor];
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)createTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];

    NSArray *array1 = @[@"全部",@"精华"];
    NSArray *array2 = @[@"最新回复",@"最新发布"];
    UISegmentedControl *sge1 = [[UISegmentedControl alloc] initWithItems:array1];
    sge1.frame = CGRectMake(10, 5, WIDTH/2-12.5, 30);
    sge1.tintColor = colorLightBlue;
    sge1.selectedSegmentIndex = 0;
    [sge1 addTarget:self action:@selector(segmentActionOne:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge1];
    
    UISegmentedControl *sge2 = [[UISegmentedControl alloc] initWithItems:array2];
    sge2.frame = CGRectMake(WIDTH/2+2.5, 5, WIDTH/2-12.5, 30);
    sge2.tintColor = colorLightBlue;
    sge2.selectedSegmentIndex = 0;
    [sge2 addTarget:self action:@selector(segmentActionTwo:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:sge2];
    
    UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, WIDTH, 1)];
    fg1.backgroundColor = colorLineGray;
    [view addSubview:fg1];

    _tableView.tableHeaderView = view;
}

-(void)segmentActionOne:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:
        {
             topicType = 0;
             break;
        }
            
        case 1:
        {
            topicType = 1;
            break;
        }
        default:
        break;
    }
    
    _count = 1;
    header = YES;
    [self loadDataWithP:_count andS:10];
}

-(void)segmentActionTwo:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:
        {
            orderType = 0;
            break;
        }
            
        case 1:
        {
            orderType = 1;
            break;
        }
        default:
            break;
    }
    
    _count = 1;
    header = YES;
    [self loadDataWithP:_count andS:10];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == twoTableView) return _twoDataArray.count;
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == twoTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"twocell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
            view.backgroundColor = colorLineGray;
            [cell.contentView addSubview:view];
        }
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"forum_brand"];
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"forum_column"];
        }
        cell.imageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        cell.textLabel.text = _twoDataArray[indexPath.row];
        //cell.detailTextLabel.text = @"好过哈哈够啊合法哦";
        return cell;
    }
    
    
    ForumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ForumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.readArray = self.readArray;
    cell.dictionary = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == twoTableView) {
        if (indexPath.row == 0) {
            ForumClassifyViewController *classify = [[ForumClassifyViewController alloc] init];
            classify.pushtype = onePushTypeList;
            classify.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:classify animated:YES];
        }else{
            ForumClassifyTwoController *two = [[ForumClassifyTwoController alloc] init];
            two.pushtype = twoPushTypeList;
            two.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:two animated:YES];
        }
        
    }else{
        PostViewController *detail = [[PostViewController alloc] init];
        detail.tid = _dataArray[indexPath.row][@"tid"];
        detail.titleText = _dataArray[indexPath.row][@"title"];
        //改变颜色
        ForumListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *title = (UILabel *)[cell valueForKey:@"titleLabel"];
        title.textColor = colorDeepGray;
        //存储数据库
        detail.hidesBottomBarWhenPushed = YES;
        [[FmdbManager shareManager] insertIntoReadHistoryWithId:_dataArray[indexPath.row][@"tid"] andTitle:_dataArray[indexPath.row][@"title"] andType:ReadHistoryTypeForum];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        NSInteger index = _scrollView.contentOffset.x/WIDTH;
        UIButton *btn = (UIButton *)[_titleView viewWithTag:100+index];
        [self titleClick:btn];
    }
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
    [self loadDataWithP:_count andS:10];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

     UIButton *btn = (UIButton *)[_titleView viewWithTag:100];
    [self titleClick:btn];
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
