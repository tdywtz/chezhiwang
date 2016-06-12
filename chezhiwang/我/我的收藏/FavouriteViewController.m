//
//  FavouriteViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "FavouriteViewController.h"
#import "ComplainDetailsViewController.h"
#import "AnswerDetailsViewController.h"
#import "NewsDetailViewController.h"

@interface FavouriteViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    CGFloat B;
}

@end

@implementation FavouriteViewController



-(void)reaData{
    
    FmdbManager *fb = [FmdbManager shareManager];
    NSArray *arr1 = [fb selectAllFromCollect:collectTypeCompalin];
    NSArray *arr2 = [fb selectAllFromCollect:collectTypeAnswer];
    NSArray *arr3 = [fb selectAllFromCollect:collectTypeNews];
    
    _dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in arr1) {
        [_dataArray addObject:dict];
    }
    for (NSDictionary *dict in  arr2) {
        [_dataArray addObject:dict];
    }
    for (NSDictionary *dict in arr3) {
        [_dataArray addObject:dict];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    B = [LHController setFont];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createLeftItem];
    [self createTableView];
}

-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
 
}

-(void)createSpace{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 140)];
    imageView.center = CGPointMake(WIDTH/2, HEIGHT/2-64);
    [self.view addSubview:imageView];
    
    UIImageView *subImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subImageView.image = [UIImage imageNamed:@"90"];
    [imageView addSubview:subImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 40)];
    label.text = @"您还没有收藏暂无收藏内容";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:B-2];
    [imageView addSubview:label];
    
}
#pragma mark - 返回
-(void)createLeftItem{
   
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(itemClick)];
}

-(void)itemClick{

    [self.navigationController popViewControllerAnimated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 59, WIDTH, 1)];
        view.backgroundColor = colorLineGray;
        [cell.contentView addSubview:view];
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.textColor = colorBlack;
    cell.detailTextLabel.text = dict[@"time"];
    cell.detailTextLabel.textColor = colorLightGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//-(void)btnClick{
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.row];

    if ([dict[@"type"] intValue] == collectTypeCompalin) {
        ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
        user.cid = dict[@"id"];
        user.textTitle = dict[@"title"];
        user.type = @"2";
        [self.navigationController pushViewController:user animated:YES];
    }else if ([dict[@"type"] intValue] == collectTypeAnswer){
        AnswerDetailsViewController *answer = [[AnswerDetailsViewController alloc] init];
        answer.cid = dict[@"id"];
        answer.type = @"3";
        answer.textTitle = dict[@"title"];
        [self.navigationController pushViewController:answer animated:YES];
    }else{
        NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
        news.ID = dict[@"id"];
        news.titleLabelText = dict[@"title"];
        [self.navigationController pushViewController:news animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
    
    [self reaData];
    if (_dataArray.count == 0) {
        [self createSpace];
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
