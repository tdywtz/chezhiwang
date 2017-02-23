//
//  LCReputationViewController.m
//  chezhiwang
//
//  Created by bangong on 17/2/6.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LCReputationViewController.h"
#import "ReputationCell.h"
#import "LHStarView.h"
#import "LCReputationDetailsViewController.h"


@implementation LCReputationChangeView
{
    UIView *moveView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *lineView = [UIView new];
        lineView.backgroundColor = colorBackGround;

        moveView = [UIView new];
        moveView.backgroundColor = colorYellow;

        [self addSubview:lineView];
        [self addSubview:moveView];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];

        [self setTitles:@[@"最新的",@"最有道理的"]];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (titles.count) {
        CGFloat leftSpace = 10;
        CGFloat btnWidth = (self.lh_width - leftSpace * 2) / titles.count;
        for (int i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:colorBlack forState:UIControlStateNormal];
            [btn setTitleColor:colorYellow forState:UIControlStateSelected];
            btn.frame = CGRectMake(10 + i * btnWidth, 0, btnWidth, self.lh_height - 1);
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100 + i;
            [self addSubview:btn];

            if (i == 0) {
                btn.selected = YES;

                moveView.lh_size = CGSizeMake(btnWidth, 2);
                moveView.lh_left = btn.lh_left;
                moveView.lh_bottom = self.lh_height;
            }
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (btn == view) {
                btn.selected = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    moveView.lh_centerX = btn.lh_centerX;
                }];

            }else{
                ((UIButton *)view).selected = NO;
            }
        }
    }
    if (self.change) {
        self.change(btn.tag - 100);
    }
}

@end


@interface LCReputationHeaderView : UIView
{
    UIImageView *imageView;
    LHStarView *scoreStarView;
    UILabel *scoreLabel;//评分
    UILabel *takeInLabel;//参与人数
    LCReputationChangeView *changeView;
}
@property (nonatomic, copy) void (^click)(NSInteger);

@end

@implementation LCReputationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    imageView = [[UIImageView alloc] init];

    UILabel *scoreTitleLabel = [[UILabel alloc] init];
    scoreTitleLabel.text = @"平均分：";
    scoreTitleLabel.font = [UIFont systemFontOfSize:14];
    scoreTitleLabel.textColor = colorDeepGray;

    scoreStarView = [[LHStarView alloc] initWithFrame:CGRectZero draw:YES];
    [scoreStarView setStarWidth:20 space:3];

    scoreLabel = [[UILabel alloc] init];

    takeInLabel = [[UILabel alloc] init];
    takeInLabel.font = [UIFont systemFontOfSize:14];
    takeInLabel.textColor = colorLightGray;

    UIView *lineView = [UIView new];
    lineView.backgroundColor = colorBackGround;


    __weak __typeof(self)weakSelf = self;
    changeView = [[LCReputationChangeView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    [changeView setChange:^(NSInteger index) {
        if (weakSelf.click) {
            weakSelf.click(index);
        }
    }];

    [self addSubview:imageView];
    [self addSubview:scoreTitleLabel];
    [self addSubview:scoreStarView];
    [self addSubview:scoreLabel];
    [self addSubview:takeInLabel];
    [self addSubview:lineView];
    [self addSubview:changeView];

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


    takeInLabel.lh_size = scoreTitleLabel.lh_size;
    takeInLabel.lh_left = scoreTitleLabel.lh_left;
    takeInLabel.lh_bottom = imageView.lh_bottom - 20;

    lineView.lh_left = 0;
    lineView.lh_top = imageView.lh_bottom + 10;
    lineView.lh_size = CGSizeMake(WIDTH, 4);

    changeView.lh_left = 0;
    changeView.lh_top = lineView.lh_bottom;

    self.lh_width = WIDTH;
    self.lh_height = changeView.lh_bottom;
}

- (void)setdata:(NSDictionary *)data{

    [imageView sd_setImageWithURL:[NSURL URLWithString:data[@"logo"]] placeholderImage:[CZWManager defaultIconImage]];
    NSString *score = [NSString stringWithFormat:@"%@分",data[@"avg"]];
    NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:score];
    scoreAtt.yy_font = [UIFont systemFontOfSize:15];
    scoreAtt.yy_color = colorOrangeRed;
    [scoreAtt yy_setColor:colorDeepGray range:[score rangeOfString:@"分"]];

    scoreLabel.attributedText = scoreAtt;

    [scoreStarView setStar:[data[@"avg"] floatValue]];

    takeInLabel.text = [NSString stringWithFormat:@"(%@人参与)",data[@"people"]];
}
@end


@interface LCReputationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
    NSString *_iOrder;

    LCReputationHeaderView *headerView;
}

@end

@implementation LCReputationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = self.contentInsets;
    _tableView.estimatedRowHeight = 200;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

   __weak __typeof(self)weakSelf = self;
     __weak __typeof(_tableView)weakTableView = _tableView;
    headerView = [[LCReputationHeaderView alloc] initWithFrame:CGRectZero];
    [headerView setClick:^(NSInteger index) {
        if (index == 0) {
            _iOrder = @"0";
        }else{
            _iOrder = @"1";
        }
        _count = 1;
        [weakTableView.mj_header beginRefreshing];
    }];
    _tableView.tableHeaderView = headerView;


    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];
    _iOrder = @"0";
    _count = 1;
    [_tableView.mj_header beginRefreshing];

    _tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
    
        _count ++;
        [weakSelf loadData];
    }];
    _tableView.mj_footer.automaticallyHidden = YES;

    [self loadHeaderData];
}

- (void)loadData{

    [HttpRequest GET:[URLFile url_reputationlistWithSid:_sid iOrder:_iOrder p:_count s:5] success:^(id responseObject) {

        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[ReputationModel mj_objectArrayWithKeyValuesArray:responseObject[@"rel"]]];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)loadHeaderData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(headerView) weakHeaderView = headerView;
    [HttpRequest GET:[URLFile url_s_reputationWithSid:_sid] success:^(id responseObject) {
        [weakHeaderView setdata:responseObject];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReputationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ReputationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReputationModel *model = _dataArray[indexPath.row];
    LCReputationDetailsViewController *details = [[LCReputationDetailsViewController alloc] init];
    details.ID = model.ID;
    [self.navigationController pushViewController:details animated:YES];
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
