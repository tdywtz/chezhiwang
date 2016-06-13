//
//  MyComplainViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyComplainViewController.h"
#import "MyComplainCell.h"
#import "MyComplainModel.h"
#import "MyComplainShowCell.h"
#import "ComplainView.h"

@interface MyComplainViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UIImageView *headerImageView;

    MyComplainModel *myModel;
    MyComplainModel *openModel;

    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;

    NSInteger _count;
    BOOL comont;
    CustomActivity *activity;
}
@end

@implementation MyComplainViewController
- (void)dealloc
{
    [headerView removeFromSuperview];
    [footView removeFromSuperview];
}

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url  = [NSString stringWithFormat:[URLFile urlStringForMyTS],[[NSUserDefaults standardUserDefaults] objectForKey:user_id],p,(long)s];
 
  [HttpRequest GET:url success:^(id responseObject) {
      if ([responseObject count] == 0) {
          footView.noData = YES;
          
      }
      if (_count == 1) {
          footView.noData = NO;
          [_dataArray removeAllObjects];
      }
     
      for (NSDictionary *dict in responseObject) {
          MyComplainModel *model = [[MyComplainModel alloc] initWithDictionary:dict];
       
          [_dataArray addObject:model];
      }
      if (_dataArray.count == 0) {
          [self createSpace];
      }
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

    self.navigationItem.title = @"我的投诉";
    self.view.backgroundColor = [UIColor whiteColor];

    [self creaRightItem];
    
    _dataArray = [[NSMutableArray alloc] init];

    
    [self createTableView];
    
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];
    
    [self loadDataWithP:1 andS:10];
    
    
}

-(void)createTableView{
    
    headerImageView = [LHController createImageViewWithFrame:CGRectMake(10, 15+64, WIDTH-20, 80*(WIDTH-20)/614.0) ImageName:nil];
    headerImageView.image = [UIImage imageNamed:@"tous1.png"];
    [self.view addSubview:headerImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerImageView.frame.size.height+headerImageView.frame.origin.y+5, WIDTH, HEIGHT-64-headerImageView.frame.size.height-20) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    headerView.delegate = self;
    footView.delegate = self;
}

-(void)createSpace{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 140)];
    imageView.center = CGPointMake(WIDTH/2, HEIGHT/2-64);
    [self.view addSubview:imageView];
    
    UIImageView *subImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subImageView.image = [UIImage imageNamed:@"90"];
    [imageView addSubview:subImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    label.text = @"您还没有投诉暂无投诉内容";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:label];
}

#pragma mark - 返回
-(void)leftItemBackClick{
    if (self.isRoot) {
      
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIViewController *controller = self.navigationController.viewControllers[self.viewIndex];
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark - 我要投诉
-(void)creaRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(rightItemClick) Text:@"我要投诉"];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90-16, 3, 16, 14)];
    imageView.image = [UIImage imageNamed:@"complain_complain"];
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}
//投诉
-(void)rightItemClick{
    ComplainView *cp =[[ComplainView alloc] init];
    [cp notifacation:^{
        [self loadDataWithP:1 andS:10];
    }];
    cp.isMyComplainVC = YES;
    [self.navigationController pushViewController:cp animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource/UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyComplainModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    if ([model isEqual:myModel]) {
        MyComplainShowCell *showcell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
        if (!showcell) {
            showcell = [[MyComplainShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showcelle"];
        }
        showcell.parentController = self;
        [showcell setModel:model];
        return showcell;
    }
    
    
    MyComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    model.isOpen = NO;
    if ([model isEqual:openModel]) {
        model.isOpen = YES;
    }
    
    cell.model = model;
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    MyComplainModel *model = _dataArray[indexPath.row];
    headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tous%@",model.stepid]];
    
    openModel = nil;
    
    
    NSInteger index = [_dataArray indexOfObject:myModel];
    
    if (index == NSNotFound) {
        openModel = model;
        myModel = [[MyComplainModel alloc] initWithDictionary:[model getDcitonary]];
        [_dataArray insertObject:myModel atIndex:indexPath.row+1];
    }else{
        if (index == indexPath.row) {
            return;
        }else if (index == indexPath.row+1){
            [_dataArray removeObject:myModel];
        }else{
            
            openModel = model;
            
            MyComplainModel *obj = [[MyComplainModel alloc] initWithDictionary:[model getDcitonary]];
            [_dataArray insertObject:obj atIndex:indexPath.row+1];
            [_dataArray removeObject:myModel];
            
            myModel = obj;
            
        }
    } 
       [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == headerView) {
        _count = 1;
        
    }else if (refreshView == footView){
        
        if (_count < 1) {
            _count = 1;
        }
        _count ++;
    }
     [self loadDataWithP:_count andS:10];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
    
    if (comont == YES) {
        _count = 1;
        [self loadDataWithP:1 andS:10];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
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
