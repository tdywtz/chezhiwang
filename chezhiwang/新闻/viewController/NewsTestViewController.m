
//
//  NewsTestViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/31.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestViewController.h"
#import "NewsTestTableView.h"
#import "NewsListCell.h"
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
