//
//  NewsInvestigateViewController.m
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsInvestigateViewController.h"
#import "InvestigateListCell.h"
#import "NewsDetailViewController.h"
#import "InvestigateChangeViewController.h"

@interface NewsInvestigateViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    UILabel *titleLabel;
    
    MJRefreshHeaderView * MJheaderView;
    MJRefreshFooterView *footView;
    NSInteger _count;

}
@end

@implementation NewsInvestigateViewController


-(void)loadData{
    NSString *url = [NSString stringWithFormat:self.urlString,_count];
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
    _count = 1;
    self.urlString = [NSString stringWithFormat:[URLFile urlStringForReport],@"0",@"&p=%ld&s=10"];

    [self createTableView];
    [self loadData];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    titleLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.userInteractionEnabled = YES;
    _tableView.tableHeaderView = titleLabel;

    titleLabel.attributedText = [self attWithString:@"不限" frame:CGRectMake(0, -3, 16, 16)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xuanzheClick)];
    [titleLabel addGestureRecognizer:tap];
    
    
    MJheaderView = [[MJRefreshHeaderView alloc] initWithScrollView:_tableView];
    footView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    MJheaderView.delegate = self;
    footView.delegate = self;
}

-(void)xuanzheClick{
    InvestigateChangeViewController *change = [[InvestigateChangeViewController alloc] init];
    __weak __typeof(self)weakSelf = self;
    [change returnChange:^(NSString *name, NSString *ID) {
        weakSelf.urlString = [NSString stringWithFormat:[URLFile urlStringForReport],ID,@"&p=%ld&s=10"];
        _count = 1;
        titleLabel.attributedText = [weakSelf attWithString:name frame:CGRectMake(0, -3, 16, 16)];
        [weakSelf loadData];
    }];
    [self presentViewController:change animated:NO completion:nil];
}


-(NSAttributedString *)attWithString:(NSString *)string frame:(CGRect)frame{
    string = [NSString stringWithFormat:@"  %@   ",string];
    NSMutableAttributedString *mutableAtt = [[NSMutableAttributedString alloc] initWithString:string];
    [mutableAtt addAttribute:NSForegroundColorAttributeName value:colorDeepBlue range:NSMakeRange(0, mutableAtt.length)];
    NSTextAttachment *chment = [[NSTextAttachment alloc] init];
    chment.image = [UIImage imageNamed:@"news_jiantou"];
    chment.bounds = frame;
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:chment];
    [mutableAtt appendAttributedString:att];
    return mutableAtt;
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
    
    InvestigateListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[InvestigateListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //cell.readArray = self.readArray;
    cell.dictionary = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    NSDictionary *dict = _dataArray[indexPath.row];
    detail.ID = dict[@"id"];
    detail.titleLabelText = dict[@"models"];
    NSLog(@"%@",dict);
//    //改变颜色
//    InvestigateListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel *title = (UILabel *)[cell valueForKey:@"titleLabel"];
//    title.textColor = colorDeepGray;
    //存储数据库
    [[FmdbManager shareManager] insertIntoReadHistoryWithId: detail.ID andTitle:detail.titleLabelText andType:ReadHistoryTypeNews];
    detail.invest = YES;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
