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
#import "ComplainViewController.h"
#import "MyComplainHeaderView.h"

@interface MyComplainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    MyComplainHeaderView *headerStepView;

    MyComplainModel *myModel;
    MyComplainModel *openModel;

    NSInteger _count;
    BOOL comont;
}
@end

@implementation MyComplainViewController


-(void)loadData{
    NSString *url  = [NSString stringWithFormat:[URLFile urlStringForMyTS],[CZWManager manager].userID,_count];
 
  [HttpRequest GET:url success:^(id responseObject) {

      if (_count == 1) {

          [_dataArray removeAllObjects];
      }
      [_tableView.mj_header endRefreshing];
      if ([responseObject count] == 0) {
          [_tableView.mj_footer endRefreshingWithNoMoreData];
      }else{
          [_tableView.mj_footer endRefreshing];
      }

      for (NSDictionary *dict in responseObject) {
          MyComplainModel *model = [[MyComplainModel alloc] initWithDictionary:dict];
       
          [_dataArray addObject:model];
      }
      if (_dataArray.count == 0) {
          [self createSpace];
      }

      [_tableView reloadData];

  } failure:^(NSError *error) {
      [_tableView.mj_header endRefreshing];
      [_tableView.mj_footer endRefreshing];

  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _count = 1;
    self.navigationItem.title = @"我的投诉";
    self.view.backgroundColor = [UIColor whiteColor];

    [self creaRightItem];
    
    _dataArray = [[NSMutableArray alloc] init];

    
    [self createTableView];
}

-(void)createTableView{
    
    headerStepView = [[MyComplainHeaderView alloc] initWithFrame:CGRectMake(10, 15+64, WIDTH-20, 55)];
    headerStepView.lightBackColor = RGB_color(0, 192, 155, 1);
    headerStepView.backColor = RGB_color(229, 229, 229, 1);
    [self.view addSubview:headerStepView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];


    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(headerStepView.bottom);
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
    ComplainViewController *complain =[[ComplainViewController alloc] init];
    [self.navigationController pushViewController:complain animated:YES];
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
            showcell.contentView.backgroundColor = colorLineGray;
        }
        showcell.selectionStyle = UITableViewCellSelectionStyleNone;
        showcell.parentController = self;
        [showcell setModel:model];
        return showcell;
    }
    
    
    MyComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    model.isOpen = NO;
    cell.contentView.backgroundColor = [UIColor clearColor];
    if ([model isEqual:openModel]) {
        model.isOpen = YES;
        cell.contentView.backgroundColor = colorLineGray;
    }
    
    cell.model = model;
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    MyComplainModel *model = _dataArray[indexPath.row];
    headerStepView.current = [model.stepid integerValue]-1;
    openModel = nil;
    
    
    NSInteger index = [_dataArray indexOfObject:myModel];
    
    if (index == NSNotFound) {
        openModel = model;
        myModel = [[MyComplainModel alloc] initWithDictionary:[model getDcitonary]];
        [_dataArray insertObject:myModel atIndex:indexPath.row+1];
    }else{

        if (index == indexPath.row) {

           [_dataArray removeObject:myModel];
        }else if (index-1 == indexPath.row){
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



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (comont == YES) {
        _count = 1;
        [self loadData];
    }
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
