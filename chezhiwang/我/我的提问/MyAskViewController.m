//
//  MyAskViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyAskViewController.h"
#import "AskViewController.h"
#import "MyAskCell.h"
#import "MyAskModel.h"
#import "MyAskShowCell.h"

@interface MyAskViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    
    MyAskModel *openModel;
    
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    NSInteger _count;
}
@property (nonatomic,strong) MyAskModel *model;
@end

@implementation MyAskViewController
- (void)dealloc
{
    [headerView removeFromSuperview];
    [footView removeFromSuperview];
}

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringFor_myZJDY],[[NSUserDefaults standardUserDefaults] objectForKey:user_id],p,s];
    
    
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {

            [_dataArray removeAllObjects];
            footView.noData = NO;
        }
        if ([responseObject count] == 0) footView.noData = YES;

        for (NSDictionary *dict in responseObject) {
            
            MyAskModel *model = [[MyAskModel alloc] init];
            model.answer = dict[@"answer"];
            model.date = dict[@"date"];
            model.cid = dict[@"id"];
            model.path = dict[@"path"];
            model.question = dict[@"question"];
            model.type = dict[@"type"];
            model.answerdate = dict[@"answerdate"];
            [_dataArray addObject:model];
        }
        [headerView endRefreshing];
        [footView endRefreshing];
        [_tabelView reloadData];
        
    } failure:^(NSError *error) {
        [headerView endRefreshing];
        [footView endRefreshing];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的提问";
    self.view.backgroundColor = [UIColor whiteColor];
    self.model = [[MyAskModel alloc] init];
    
   
    [self createRightItem];
  
    [self createTabelView];
    [self loadDataWithP:1 andS:10];
}


-(void)createTabelView{
    _dataArray = [[NSMutableArray alloc] init];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
    
    headerView = [[MJRefreshHeaderView alloc] initWithScrollView:_tabelView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tabelView];
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
    label.text = @"您还没有提问暂无提问内容";
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

#pragma mark - 跳转我要提问页面
-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(rightItemClick) Text:@"我要提问"];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(90-16, 3, 16, 14)];
    imageView.image = [UIImage imageNamed:@"answer_question_right"];
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rightItemClick{
    AskViewController *ask = [[AskViewController alloc] init];
    ask.isMyAsk = YES;
    [self.navigationController pushViewController:ask animated:YES];
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
    MyAskModel *model = _dataArray[indexPath.row];
    if ([model isEqual:self.model]) {
        MyAskShowCell *showCell = [_tabelView dequeueReusableCellWithIdentifier:@"showCell"];
        if (!showCell) {
            showCell = [[MyAskShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showCell"];
            showCell.selectionStyle = UITableViewCellSelectionStyleNone;
            showCell.contentView.backgroundColor = colorLineGray;
        }
        [showCell setModel:model];
        return showCell;
    }
    
    MyAskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyAskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
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

//-(void)btnClick{
//    
//}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model isEqual:_dataArray[indexPath.row]]) {
        return 150;
    }
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MyAskModel *model = _dataArray[indexPath.row];
   
   openModel = nil;
   
    self.model.answer = model.answer;
    self.model.answerdate = model.answerdate;
    self.model.question = model.question;
    NSInteger index = [_dataArray indexOfObject:self.model];
    
    if (index == NSNotFound) {
        openModel = model;
        
        [_dataArray insertObject:self.model atIndex:indexPath.row+1];
    }else{
        if (index == indexPath.row) {
            [_dataArray removeObject:self.model];
        }else if (index == indexPath.row+1){
            [_dataArray removeObject:self.model];
        }else{
            
            openModel = model;
            
            MyAskModel *obj = [[MyAskModel alloc] init];
            obj.answer = model.answer;
            obj.answerdate = model.answerdate;
            obj.question = model.question;
            [_dataArray insertObject:obj atIndex:indexPath.row+1];
            [_dataArray removeObject:self.model];
            self.model = obj;
            
        }
    }

    if (index != indexPath.row) {
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if ([df objectForKey:YorNO]) {
            [dict setDictionary:[df objectForKey:YorNO]];
        }
        [dict setObject:@"1" forKeyedSubscript:model.cid];
        [df setObject:dict forKey:YorNO];
        [df synchronize];
    }


    [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == headerView){
    
        _count = 1;
    }else{
        if (_count < 1) {
            _count = 1;
        }
        _count ++;
    }
    [self loadDataWithP:_count andS:10];
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
