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

    NSMutableArray *_dataArray;
    NSInteger _count;
}
@end

@implementation NewsListViewController

-(void)loadData{

    NSString *url = [NSString stringWithFormat:_urlString,_count,10];
    [HttpRequest GET:url success:^(id responseObject) {

        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }

        [_dataArray addObjectsFromArray:[HomepageNewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"rel"]]];

        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    _count = 1;

    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];

    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 80;
        _tableView.contentOffset = CGPointZero;
        _tableView.contentInset = _contentInsets;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }

    return  _tableView;
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
    NSString *url = model.image;
    //如果有图片链接，设置分享图片链接为第一个
    if (url.length > 1) {
        NSArray *urls = [url componentsSeparatedByString:@","];
        if (urls.count) {
            detail.shareImageUrl = urls[0];
        }
    }
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
