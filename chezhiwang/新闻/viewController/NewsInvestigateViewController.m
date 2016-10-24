//
//  NewsInvestigateViewController.m
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsInvestigateViewController.h"
#import "HomepageResearchCell.h"
#import "NewsDetailViewController.h"
#import "InvestigateChangeViewController.h"

@interface NewsInvestigateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    
    UILabel *titleLabel;

    NSInteger _count;

}
@end

@implementation NewsInvestigateViewController


-(void)loadData{
    NSString *url = [NSString stringWithFormat:self.urlString,_count];
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

        [_dataArray addObjectsFromArray:[HomepageResearchModel arayWithArray:responseObject[@"rel"]]];
        
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"调查";
    _dataArray = [[NSMutableArray alloc] init];
    _count = 1;
    self.urlString = [NSString stringWithFormat:[URLFile urlStringForReport],@"0",@"&p=%ld&s=10"];
    [self createTableView];
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
     _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

    
    titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    titleLabel.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.userInteractionEnabled = YES;
    _tableView.tableHeaderView = titleLabel;

    titleLabel.attributedText = [self attWithString:@"不限" frame:CGRectMake(0, -3, 16, 16)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xuanzheClick)];
    [titleLabel addGestureRecognizer:tap];

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

    HomepageResearchModel *model = _dataArray[indexPath.row];
    HomepageResearchCell *researchCell = [tableView dequeueReusableCellWithIdentifier:@"researchCell"];
    if (!researchCell) {
        researchCell = [[HomepageResearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"researchCell"];
    }
    researchCell.researchModel = model;
    return researchCell;

}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HomepageResearchModel *model = _dataArray[indexPath.row];
    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    detail.ID = model.ID;
    detail.invest = YES;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
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
