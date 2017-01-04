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
#import "FavouriteCell.h"

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

    if (_dataArray.count == 0) {
        self.backgroundView.contentLabel.text = @"暂无收藏";
        self.backgroundView.hidden = NO;
    }else{
        self.backgroundView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    B = [LHController setFont];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTableView];

}

-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
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
    FavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[FavouriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    cell.titleLabel.text = dict[@"title"];
    cell.dateLabel.text = dict[@"time"];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataArray[indexPath.row];

    if ([dict[@"type"] intValue] == collectTypeCompalin) {
        ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
        user.cid = dict[@"id"];
        [self.navigationController pushViewController:user animated:YES];
    }else if ([dict[@"type"] intValue] == collectTypeAnswer){
        AnswerDetailsViewController *answer = [[AnswerDetailsViewController alloc] init];
        answer.cid = dict[@"id"];
        [self.navigationController pushViewController:answer animated:YES];
    }else{
        NewsDetailViewController *news = [[NewsDetailViewController alloc] init];
        news.ID = dict[@"id"];
        [self.navigationController pushViewController:news animated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reaData];

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
