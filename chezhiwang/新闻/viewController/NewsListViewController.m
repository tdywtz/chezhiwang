//
//  NewsListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsListViewController.h"
#import "HomepageNewsTextCell.h"
#import "HomepageNewsImageCell.h"
#import "NewsDetailViewController.h"
#import "NewsSearchViewController.h"
#import "PostViewController.h"

@interface NewsListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    CGFloat xx;
    UITableView *_tableView;
    NSMutableArray *_dataArray;

    NSInteger _count;
}
@end

@implementation NewsListViewController

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
   
    NSString *url = [NSString stringWithFormat:_urlString,p,s];
  [HttpRequest GET:url success:^(id responseObject) {

      if (_count == 1) {
          

          [_dataArray removeAllObjects];
      }else{
          if ([responseObject count] == 0) {

          }
      }
      [_dataArray addObjectsFromArray:[HomepageNewsModel arayWithArray:responseObject]];
   
      [_tableView reloadData];

  } failure:^(NSError *error) {


  }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    [self createTableView];
    _count = 1;
    _tableView.contentOffset = CGPointZero;
    [self loadDataWithP:_count andS:10];

     //_tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}


-(void)createTableView{

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    HomepageNewsModel *model = _dataArray[indexPath.row];
    //有图
    if (model.image.length) {
        HomepageNewsImageCell *newsImageCell = [tableView dequeueReusableCellWithIdentifier:@"newsImageCell"];
        if (!newsImageCell) {
            newsImageCell = [[HomepageNewsImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsImageCell"];
        }
        newsImageCell.newsModel = model;
        return newsImageCell;
    }

    //无图
    HomepageNewsTextCell *newsTextCell = [tableView dequeueReusableCellWithIdentifier:@"newsTextCell"];
    if (!newsTextCell) {
        newsTextCell = [[HomepageNewsTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsTextCell"];
    }
    newsTextCell.newsModel = model;
    return newsTextCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

     HomepageNewsModel *model = _dataArray[indexPath.row];

        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = model.ID;
        detail.titleLabelText = model.title;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
}



-(void)viewApper{
    _tableView.scrollsToTop = YES;
}

-(void)viewDisappear{
    _tableView.scrollsToTop = NO;
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
