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

@interface ForumListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UITableView *twoTableView;
    NSArray *_twoDataArray;
    
    UIView *_titleView;
    UIView *_moveView;
    
    NSInteger orderType;
    NSInteger topicType;
    NSInteger _count;
}
@end

@implementation ForumListViewController

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPostList],orderType,topicType,p,s];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        for (NSDictionary *dict in responseObject) {
            [_dataArray addObject:dict];
        }

        [_tableView reloadData];

    } failure:^(NSError *error) {


    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _twoDataArray = @[@"品牌论坛",@"栏目论坛"];
   
  
    [self createCustomTitleView];
    
    orderType = 0;
    topicType = 0;
    _count = 1;

    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf createTableView];
        [weakSelf createTableHeaderView];
       
    });

    [self loadDataWithP:1 andS:10];

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
            CGRect rect1 = _tableView.frame;
            CGRect rect2 = twoTableView.frame;
            rect1.origin.x = 0;
            rect2.origin.x = WIDTH;
            _tableView.frame = rect1;
            twoTableView.frame = rect2;
            _moveView.frame = CGRectMake(btn.frame.origin.x, _moveView.frame.origin.y, btn.frame.size.width, _moveView.frame.size.height);
        }];
        
        UIButton *button = (UIButton *)[_titleView viewWithTag:101];
        button.selected = NO;
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect1 = _tableView.frame;
            CGRect rect2 = twoTableView.frame;
            rect1.origin.x = -WIDTH;
            rect2.origin.x = 0;
            _tableView.frame = rect1;
            twoTableView.frame = rect2;
           _moveView.frame = CGRectMake(btn.frame.origin.x, _moveView.frame.origin.y, btn.frame.size.width, _moveView.frame.size.height);
        }];
        
        UIButton *button = (UIButton *)[_titleView viewWithTag:100];
        button.selected = NO;

    }
}

-(void)createTableView{

    [self.view addSubview:[[UIView alloc] init]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 64, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    twoTableView.delegate = self;
    twoTableView.dataSource = self;
    twoTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:twoTableView];

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
