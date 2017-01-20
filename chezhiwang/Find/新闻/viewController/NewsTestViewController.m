
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

@interface NewsTestViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TestToolView *toolView;
    NewsTestTableView *testTableView;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
}
@end

@implementation NewsTestViewController

- (void)loadData{
   NSString *url = [NSString stringWithFormat:@"%@%@",[URLFile url_newslistWithStyle:@"4" title:nil sid:nil],@"&p=%ld&s=10"];
    url = [NSString stringWithFormat:url,_count];
    [HttpRequest GET:url success:^(id responseObject) {
        if (_count == 1) {

            [_dataArray removeAllObjects];
        }

        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        for (NSDictionary *dict in responseObject[@"rel"]) {
            [_dataArray addObject:[HomepageNewsModel mj_objectWithKeyValues:dict]];
        }
        
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        
    }];

}

- (void)viewDidLoad{
    [super viewDidLoad];
 _dataArray = [[NSMutableArray alloc] init];

    toolView = [[TestToolView alloc] initWithFrame:CGRectMake(0, 64+44, WIDTH, 50) titles:@[@"精品试驾",@"全部文章"] block:^(NSInteger index) {
        if (index == 0) {
            testTableView.hidden = NO;
            _tableView.hidden = YES;
            _tableView.scrollsToTop = NO;
            [testTableView setScrollToTop:YES];
        }else{
            testTableView.hidden = YES;
            _tableView.hidden = NO;
            _tableView.scrollsToTop = YES;
            [testTableView setScrollToTop:NO];
        }
    }];
    [self.view addSubview:toolView];

    CGFloat frame_y = toolView.frame.origin.y+CGRectGetHeight(toolView.frame);
    testTableView = [[NewsTestTableView alloc] initWithFrame:CGRectMake(0, frame_y, WIDTH, HEIGHT-frame_y) parentViewController:self];
    [self.view addSubview:testTableView];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, frame_y, WIDTH, HEIGHT-frame_y) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];

    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;

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
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}



@end
