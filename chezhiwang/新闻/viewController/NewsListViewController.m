//
//  NewsListViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsListCell.h"
#import "NewsDetailViewController.h"
#import "InvestigateListCell.h"
#import "ChangeView.h"
#import "NewsSearchViewController.h"
#import "PostViewController.h"
#import "NewsTableHeaderView.h"

@interface NewsListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchDisplayDelegate,MJRefreshBaseViewDelegate,UISearchBarDelegate>
{
    CGFloat xx;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NewsTableHeaderView *_tableHeaderView;
    
    MJRefreshHeaderView * MJheaderView;
    MJRefreshFooterView *footView;
    NSInteger _count;
}
@end

@implementation NewsListViewController

-(void)loadDataWithP:(NSInteger)p andS:(NSInteger)s{
   
    NSString *url = [NSString stringWithFormat:_urlString,p,s];
  [HttpRequest GET:url success:^(id responseObject) {

      if (_count == 1) {
          
          footView.noData = NO;
          [_dataArray removeAllObjects];
      }else{
          if ([responseObject count] == 0) {
              footView.noData = YES;
          }
      }
      
      for (NSDictionary *dict in responseObject) {
          [_dataArray addObject:dict];
      }
      
      [_tableView reloadData];
      [MJheaderView endRefreshing];
      [footView endRefreshing];
  } failure:^(NSError *error) {
      [MJheaderView endRefreshing];
      [footView endRefreshing];

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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];

  
    if (self.tableHeaderViewHave) {
        _tableHeaderView = [[NewsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 69+207*(WIDTH/375))];
        _tableHeaderView.parentViewController = self;
        __weak __typeof(self)weakSelf = self;
        _tableHeaderView.block = ^(NSString *ID, NSString *title){
            NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
            detail.ID = ID;
            detail.titleLabelText = title;
            detail.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detail animated:YES];
        };
        _tableView.tableHeaderView = _tableHeaderView;
    }
    
    MJheaderView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    MJheaderView.delegate = self;
    footView.delegate = self;
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
    
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NewsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //cell.readArray = self.readArray;
    cell.dictionary = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _dataArray[indexPath.row];
    if ([dict[@"image"] length] == 0) {
        return 65;
    }
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        NSDictionary *dict = _dataArray[indexPath.row];
        detail.ID = dict[@"id"];
        detail.titleLabelText = dict[@"title"];
    
        //改变颜色
        NewsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *title = (UILabel *)[cell valueForKey:@"titleLabel"];
        title.textColor = colorDeepGray;
        //存储数据库
        [[FmdbManager shareManager] insertIntoReadHistoryWithId: detail.ID andTitle:detail.titleLabelText andType:ReadHistoryTypeNews];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
}



#pragma mark - 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str searchStr:(NSString *)search{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, att.length)];
    for (int i = 0; i < search.length; i ++) {
        NSRange ran = {i,1};
        NSString *sub = [search substringWithRange:ran];
        NSRange range = [str rangeOfString:sub];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
    }
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    //[style setLineBreakMode:NSLineBreakByWordWrapping];
    // style.firstLineHeadIndent = 30;
    //style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
    return att;
}

-(void)viewApper{
    _tableView.scrollsToTop = YES;
}

-(void)viewDisappear{
    _tableView.scrollsToTop = NO;
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == MJheaderView) {
        _count = 1;
        if (_tableHeaderView) {
            [_tableHeaderView loadData];
        }
    }else{
        if (_count < 1) _count = 1;
       
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
