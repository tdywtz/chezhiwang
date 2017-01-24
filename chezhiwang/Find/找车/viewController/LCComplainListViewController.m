//
//  LCComplainListViewController.m
//  chezhiwang
//
//  Created by bangong on 17/1/13.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LCComplainListViewController.h"
#import "HomepageComplainCell.h"
#import "ComplainDetailsViewController.h"
#import "LoginViewController.h"
#import "MyComplainHeaderView.h"
#import "StarView.h"

@interface LCComplainListHeaderView : UIView
{
    UIImageView *imageView;
    MyComplainHeaderView *drawView;

    StarView *scoreStarView;
    UILabel *scoreLabel;//评分
    UILabel *answerPercentageLabel;//回复率
}
@end

@implementation LCComplainListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] init];

        UILabel *scoreTitleLabel = [[UILabel alloc] init];
        scoreTitleLabel.text = @"用户满意度评分：";
        scoreTitleLabel.font = [UIFont systemFontOfSize:14];
        scoreTitleLabel.textColor = colorDeepGray;

        scoreLabel = [[UILabel alloc] init];

        scoreStarView = [[StarView alloc] initWithFrame:CGRectMake(0, 0, 75, 23)];

        answerPercentageLabel = [[UILabel alloc] init];
        answerPercentageLabel.font = [UIFont systemFontOfSize:14];

        UILabel *telephoneLabel = [[UILabel alloc] init];
        telephoneLabel.attributedText = [self telephone];

        drawView = [[MyComplainHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - 20, 41)];
        drawView.current = 5;

        UIView *lineView1 = [UIView new];
        lineView1.backgroundColor = colorBackGround;

        UIView *lineView2 = [UIView new];
        lineView2.backgroundColor = colorBackGround;

        [self addSubview:imageView];
        [self addSubview:scoreTitleLabel];
        [self addSubview:scoreStarView];
        [self addSubview:scoreLabel];
        [self addSubview:answerPercentageLabel];
        [self addSubview:lineView1];
        [self addSubview:telephoneLabel];
        [self addSubview:drawView];
        [self addSubview:lineView2];

        CGFloat width = WIDTH*4/10 - 10;
        imageView.lh_left = 10;
        imageView.lh_top = 10;
        imageView.lh_size = CGSizeMake(width, width * 0.8);

        scoreTitleLabel.lh_left = imageView.lh_right + 20;
        scoreTitleLabel.lh_top = imageView.lh_top+10;
        scoreTitleLabel.lh_height = 20;
        scoreTitleLabel.lh_width = WIDTH - imageView.lh_right - 20;

        scoreStarView.lh_left = scoreTitleLabel.lh_left;
        scoreStarView.lh_centerY = imageView.lh_centerY - 5;


        scoreLabel.lh_height = 20;
        scoreLabel.lh_width = 60;
        scoreLabel.lh_left = scoreStarView.lh_right + 5;
        scoreLabel.lh_centerY = scoreStarView.lh_centerY;


        answerPercentageLabel.lh_size = scoreTitleLabel.lh_size;
        answerPercentageLabel.lh_left = scoreTitleLabel.lh_left;
        answerPercentageLabel.lh_bottom = imageView.lh_bottom - 10;

        lineView1.lh_left = 0;
        lineView1.lh_top = imageView.lh_bottom + 10;
        lineView1.lh_size = CGSizeMake(WIDTH, 5);

        [telephoneLabel sizeToFit];
        telephoneLabel.lh_left = 10;
        telephoneLabel.lh_top = lineView1.lh_bottom + 10;

        drawView.lh_left = 10;
        drawView.lh_top = telephoneLabel.lh_bottom + 10;

        lineView2.lh_left = 0;
        lineView2.lh_top = drawView.lh_bottom + 10;
        lineView2.lh_size = lineView1.lh_size;

        self.lh_height = lineView2.lh_bottom;

    }
    return self;
}

- (NSAttributedString *)telephone{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"投诉咨询热线："];
    text.yy_font = [UIFont systemFontOfSize:13];
    text.yy_color = colorDeepGray;

    NSMutableAttributedString *tel = [[NSMutableAttributedString alloc] initWithString:@"010-65994868"];
    tel.yy_font = [UIFont systemFontOfSize:13];
    tel.yy_color = colorOrangeRed;

    [text appendAttributedString:tel];

    return text;
}

- (void)setData:(NSDictionary *)data{
    [imageView sd_setImageWithURL:data[@"log"] placeholderImage:[CZWManager defaultIconImage]];

    NSString *score = data[@"myd"]?data[@"myd"]:@"0";
    [scoreStarView setStar:[score integerValue]];

    NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分",score]];
    scoreAtt.yy_font = [UIFont systemFontOfSize:14];
    scoreAtt.yy_color = colorOrangeRed;
    [scoreAtt yy_setColor:colorDeepGray range:[scoreAtt.string rangeOfString:@"分"]];


    scoreLabel.attributedText = scoreAtt;

    NSString *percentage = data[@"hfl"]?data[@"hfl"]:@"";
    NSString *text = [NSString stringWithFormat:@"厂家回复率：%@",percentage];

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.yy_font = [UIFont systemFontOfSize:14];
    att.yy_color = colorDeepGray;
    [att yy_setColor:colorOrangeRed range:[text rangeOfString:percentage]];

    answerPercentageLabel.attributedText = att;
}

@end



@interface LCComplainListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;

    FmdbManager *_fmdb;

    LCComplainListHeaderView *headerView;
}

@end

@implementation LCComplainListViewController
-(void)loadData{

    NSString *url = [URLFile url_complainlistWithTitle:nil sid:self.sid p:_count s:10];
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
            [_dataArray addObject:[HomepageComplainModel mj_objectWithKeyValues:dict]];
        }

        [_tableView reloadData];


    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)loadDataHeader{
    [HttpRequest GET:[URLFile url_s_complainWithSid:_sid] success:^(id responseObject) {
        [headerView setData:responseObject];
    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _count = 1;
    [self dataInitialization];
    [self createTableView];

    headerView = [[LCComplainListHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    _tableView.tableHeaderView = headerView;

    [self loadDataHeader];
}

//初始化数据
-(void)dataInitialization{
    _dataArray = [[NSMutableArray alloc] init];
    _fmdb = [FmdbManager shareManager];
}


- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = self.contentInsets;
    [self.view addSubview:_tableView];

    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];

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
