
//
//  NewsTestViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/31.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestViewController.h"
#import "NewsTestTableView.h"
#import "HomepageNewsImageCell.h"
#import "HomepageNewsTextCell.h"
#import "NewsDetailViewController.h"

@interface TestToolView : UIView

@property (nonatomic,assign) NSInteger currant;
@property (nonatomic,copy) void (^block)(NSInteger index);
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(void (^)(NSInteger index))block;

@end

@implementation TestToolView
{
    UIView *moveView;
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(void (^)(NSInteger index))block{
    if (self = [super initWithFrame:frame]) {
        self.block = block;
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+i*80, 10, 70, CGRectGetHeight(frame)-10);
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:colorBlack forState:UIControlStateNormal];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            btn.tag = 100+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
        line.backgroundColor = colorLineGray;
        [self addSubview:line];
        _currant = 0;
        
        moveView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(frame)-3, 70, 3)];
        moveView.backgroundColor = colorYellow;
        [self addSubview:moveView];

    }
    return self;
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag-100 == _currant) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
         moveView.center = CGPointMake(btn.center.x, moveView.center.y);
    }];
    
    if (self.block) {
        self.block(btn.tag-100);
    }
    _currant = btn.tag - 100;
}

@end

#pragma mark - NewsTestViewController

@interface NewsTestViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    TestToolView *toolView;
    NewsTestTableView *testTableView;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    MJRefreshHeaderView * MJheaderView;
    MJRefreshFooterView *footView;
    NSInteger _count;
}
@end

@implementation NewsTestViewController

- (void)loadData{
   NSString *url = [NSString stringWithFormat:[URLFile urlStringForNewsList],@"4",@"&p=%ld&s=10"];
    url = [NSString stringWithFormat:url,_count];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {
            
            footView.noData = NO;
            [_dataArray removeAllObjects];
        }else{
            if ([responseObject count] == 0) {
                footView.noData = YES;
            }
        }
        
        [_dataArray addObjectsFromArray:[HomepageNewsModel arayWithArray:responseObject]];
        
        [_tableView reloadData];
        [MJheaderView endRefreshing];
        [footView endRefreshing];
    } failure:^(NSError *error) {
        [MJheaderView endRefreshing];
        [footView endRefreshing];
        
    }];

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    __weak  __typeof(self)weakself = self;
    toolView = [[TestToolView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 40) titles:@[@"精品试驾",@"全部文章"] block:^(NSInteger index) {
        if (index == 0) {
            [_tableView removeFromSuperview];
            [weakself.view addSubview:testTableView];
            _tableView.scrollsToTop = NO;
            [testTableView setScrollToTop:YES];
        }else{
            [testTableView removeFromSuperview];
            [weakself.view addSubview:_tableView];
            _tableView.scrollsToTop = YES;
            [testTableView setScrollToTop:NO];
        }
    }];
 //   [self.view addSubview:toolView];
    
    testTableView = [[NewsTestTableView alloc] initWithFrame:CGRectMake(0, toolView.frame.origin.y+CGRectGetHeight(toolView.frame), WIDTH, HEIGHT-49-64-40) parentViewController:self];
  //  [self.view addSubview:testTableView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    [self.view addSubview:_tableView];
    
    MJheaderView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    MJheaderView.delegate = self;
    footView.delegate = self;

    
    _count = 1;
    _dataArray = [[NSMutableArray alloc] init];
    [self loadData];
}

-(void)viewApper{
    if (toolView.currant == 0) {
        _tableView.scrollsToTop = NO;
        [testTableView setScrollToTop:YES];
    }else{
         _tableView.scrollsToTop = YES;
        [testTableView setScrollToTop:NO];
    }
}


-(void)viewDisappear{
    _tableView.scrollsToTop = NO;
    [testTableView setScrollToTop:NO];
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


#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView == MJheaderView) {
        _count = 1;
       
    }else{
        if (_count < 1) _count = 1;
        
        _count ++;
    }
    [self loadData];
}


@end
