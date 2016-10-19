//
//  ComplainListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainListViewController.h"
#import "HomepageComplainCell.h"
#import "ComplainDetailsViewController.h"
#import "ComplainSearchViewController.h"
#import "ComplainView.h"
#import "LoginViewController.h"


@interface ComplainListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    CGFloat cellheight;

    NSInteger _count;
    
    FmdbManager *_fmdb;
}
@end

@implementation ComplainListViewController

-(void)loadDataP:(NSInteger)p andS:(NSInteger)s{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForZLTS],p,s];
   [HttpRequest GET:url success:^(id responseObject) {

       if (_count == 1) {
           [_dataArray removeAllObjects];
           
       }

     [_dataArray addObjectsFromArray:[HomepageComplainModel arayWithArray:responseObject[@"rel"]]];

       [_tableView reloadData];


   } failure:^(NSError *error) {

   }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self dataInitialization];
    [self createLeftItem];
    //[self createRightItem];
    [self createTableView];
    [self loadDataP:1 andS:10];

}

//初始化数据
-(void)dataInitialization{
    _dataArray = [[NSMutableArray alloc] init];
    _fmdb = [FmdbManager shareManager];
}

-(void)createLeftItem{
       self.navigationItem.rightBarButtonItem = [LHController createComplainItemWthFrame:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(leftItemClick)];
}

-(void)leftItemClick{
    if ([CZWManager manager].isLogin) {
        ComplainView *complain = [[ComplainView alloc] init];
        complain.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:complain animated:YES];
    }else{

        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
    }
}

- (void)createTableView{
   
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

-(void)createRightItem{
    UIButton *button = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemCLick) Text:nil];
    [button setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)rightItemCLick{
    
    ComplainSearchViewController *search = [[ComplainSearchViewController alloc] init];
    search.numType = 2;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomepageComplainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomepageComplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.complainModel =  _dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomepageComplainModel *model = _dataArray[indexPath.row];
    ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
    detail.cid = model.cpid;
  
//存储数据库
    [_fmdb insertIntoReadHistoryWithId:model.cpid andTitle:model.question andType:ReadHistoryTypeComplain];
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
