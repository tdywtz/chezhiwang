//
//  CommentViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentCell.h"
#import "MyCommentModel.h"

#import "MyCommentShowCell.h"

@interface MyCommentViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
{

    UITableView *_tabelView;
    NSMutableArray *_dataArray;
    
    MyCommentModel *myModel;
    MyCommentModel *openModel;
    
    MJRefreshHeaderView *headerView;
    MJRefreshFooterView *footView;
    NSInteger _count;
    
    CustomActivity *activity;
}
@end

@implementation MyCommentViewController

- (void)dealloc
{
    [headerView removeFromSuperview];
    [footView removeFromSuperview];
}

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDiscuss],[[NSUserDefaults standardUserDefaults] objectForKey:user_id],p,s];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            footView.noData = NO;
            [_dataArray removeAllObjects];
        }
        NSArray *array = responseObject;
        if ([responseObject count] == 0) {
            footView.noData = YES;
        }
        for (NSDictionary *dict in array) {
            MyCommentModel *model = [[MyCommentModel alloc] initWithDictionary:dict];
            [_dataArray addObject:model];
        }
        [headerView endRefreshing];
        [footView endRefreshing];
        [activity animationStoping];
        [_tabelView reloadData];

    } failure:^(NSError *error) {
        [headerView endRefreshing];
        [footView endRefreshing];
        [activity animationStoping];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"我的评论";
    self.view.backgroundColor = [UIColor whiteColor];
  
 
        [self createTabelView];
        
        activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
        [self.view addSubview:activity];
        [activity animationStarting];
        
        [self loadDataWithP:1 andS:10];
  

}

-(void)createTabelView{
    _dataArray = [[NSMutableArray alloc] init];

    self.navigationController.modalPresentationCapturesStatusBarAppearance = NO;
    _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tabelView.separatorInset = UIEdgeInsetsMake(0, -100, 0, 0);
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
    label.text = @"您还没有评论暂无平论内容";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:label];
    
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
     MyCommentModel *model = [_dataArray objectAtIndex:indexPath.row];
  
    if ([model isEqual:myModel]) {
        MyCommentShowCell *showcell = [tableView dequeueReusableCellWithIdentifier:@"showcell"];
        if (!showcell) {
            showcell = [[MyCommentShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"showcelle"];
            showcell.selectionStyle = UITableViewCellSelectionStyleNone;
            showcell.contentView.backgroundColor = colorLineGray;
        }
        showcell.parentViewController = self;
        showcell.model = model;
        return showcell;
    }
   
  
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[MyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
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


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MyCommentModel *model = _dataArray[indexPath.row];
    
    openModel = nil;
    
    

    NSInteger index = [_dataArray indexOfObject:myModel];
    
    if (index == NSNotFound) {
        openModel = model;
        myModel = [[MyCommentModel alloc] initWithDictionary:[model getDcitonary]];
        [_dataArray insertObject:myModel atIndex:indexPath.row+1];
    }else{
        if (index == indexPath.row) {
            [_dataArray removeObject:myModel];
        }else if (index == indexPath.row+1){
            [_dataArray removeObject:myModel];
        }else{
            
            openModel = model;
            
            MyCommentModel *obj = [[MyCommentModel alloc] initWithDictionary:[model getDcitonary]];
            [_dataArray insertObject:obj atIndex:indexPath.row+1];
            [_dataArray removeObject:myModel];
           
            myModel = obj;
            
        }
    }

    [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - MJRefreshBaseViewDelegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == headerView) {
        _count = 1;
    }else{
        if (_count < 0) {
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
