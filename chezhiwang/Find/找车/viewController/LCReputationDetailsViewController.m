//
//  LCReputationDetailsViewController.m
//  chezhiwang
//
//  Created by bangong on 17/2/8.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LCReputationDetailsViewController.h"
#import "ReputationCell.h"
#import "LHStarView.h"
#import "FootCommentView.h"
#import "CustomCommentView.h"
#import "LoginViewController.h"

@interface LCReputationDetailsHeaderView : UIView
{
    UILabel *seriesnameLabel;
    UIImageView *iconImageView;
    UILabel *userNameLabel;
    UILabel *dateLabel;
    YYLabel *scoreLabel;
    ReputationCellContentView *contentView;
    UILabel *numLabel;
    UIView *lineView3;
    UIView *lineView4;
}
@end

@implementation LCReputationDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    seriesnameLabel = [[UILabel alloc] init];
    seriesnameLabel.textColor = colorBlack;

    iconImageView = [[UIImageView alloc] init];

    UIView *lineView1 = [UIView new];
    lineView1.backgroundColor = colorBackGround;

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = colorLineGray;

    lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = colorBackGround;

    lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = colorLineGray;

    userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = colorLightBlue;
    userNameLabel.font = [UIFont systemFontOfSize:15];

    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = colorLightGray;
    dateLabel.font = [UIFont systemFontOfSize:13];

    scoreLabel = [[YYLabel alloc] init];
    //    scoreLabel.font = [UIFont systemFontOfSize:12];
    //    scoreLabel.textColor = colorLightGray;
    //    scoreLabel.text = @"综合评价：";

    contentView = [[ReputationCellContentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, 100) praise:NO];
    contentView.backgroundColor = [UIColor clearColor];

    numLabel = [[UILabel alloc] init];
    numLabel.textColor = colorOrangeRed;
    numLabel.font = [UIFont systemFontOfSize:14];

    [self addSubview:seriesnameLabel];
    [self addSubview:lineView1];
    [self addSubview:lineView2];
    [self addSubview:iconImageView];
    [self addSubview:userNameLabel];
    [self addSubview:dateLabel];
    [self addSubview:scoreLabel];
    [self addSubview:contentView];
    [self addSubview:numLabel];
    [self addSubview:lineView3];
    [self addSubview:lineView4];

    [seriesnameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(10);
    }];

    [lineView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(seriesnameLabel.bottom).offset(10);
        make.height.equalTo(4);
    }];

    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(lineView1.bottom).offset(10);
        make.size.equalTo(40);
    }];

    [userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView.top);
        make.right.lessThanOrEqualTo(0);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.bottom.equalTo(iconImageView.bottom);
        make.width.equalTo(115);
    }];

    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(dateLabel);
    }];

    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(dateLabel.bottom).offset(10);
        make.height.equalTo(1);
    }];

    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(0);
        make.top.equalTo(lineView2.bottom);
    }];

//    [lineView3 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(0);
//        make.bottom.equalTo(numLabel.top).offset(-10);
//        make.height.equalTo(4);
//    }];
//
//    [numLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(10);
//        make.height.equalTo(16);
//        make.bottom.equalTo(lineView4.top).offset(-10);
//    }];
//
//    [lineView4 makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(0);
//        make.height.equalTo(1);
//        make.bottom.equalTo(0);
//    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];

    lineView3.lh_left = 0;
    lineView3.lh_top = contentView.lh_bottom + 15;
    lineView3.lh_size = CGSizeMake(WIDTH, 4);

    numLabel.lh_top = lineView3.lh_bottom + 10;
    numLabel.lh_left = 10;
    numLabel.lh_size = CGSizeMake(200, 16);

    lineView4.lh_top = numLabel.lh_bottom + 10;
    lineView4.lh_left = 0;
    lineView4.lh_size = CGSizeMake(WIDTH, 1);

    self.lh_height = lineView4.lh_bottom;
}

- (void)setModel:(ReputationModel *)model{

    NSURL *imageUrl = [NSURL URLWithString:model.headurl];
    [iconImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"auto_reputation_avatar"]];


    seriesnameLabel.text = model.seriesname;
    userNameLabel.text = model.username;
    dateLabel.text = model.date;

    LHStarView *starView = [[LHStarView alloc] initWithFrame:CGRectZero];
    [starView setStar:[model.stars floatValue]];

    [contentView setdata:model];


    NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:@"综合评分："];
    scoreAtt.yy_font = [UIFont systemFontOfSize:13];
    scoreAtt.yy_color = colorDeepGray;

    UIImage *image =  [starView getImage];

    CGSize size = CGSizeMake(starView.frame.size.width * (14.0/starView.frame.size.height), 14);
    NSMutableAttributedString *star = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:size alignToFont:scoreAtt.yy_font alignment:YYTextVerticalAlignmentCenter];
    [scoreAtt appendAttributedString:star];

    scoreLabel.attributedText = scoreAtt;

    numLabel.text =  [NSString stringWithFormat:@"全部评论(%@)",model.pl?model.pl:@"0"];
}

@end

#pragma mark - LCReputationDetailsCellModel
@interface LCReputationDetailsCellModel : NSObject

@property (nonatomic, copy) NSString *p_content;
@property (nonatomic, copy) NSString *p_logo;
@property (nonatomic, copy) NSString *p_time;
@property (nonatomic, copy) NSString *p_uname;

@end

@implementation LCReputationDetailsCellModel


@end

#pragma mark - LCReputationDetailsCell
@interface LCReputationDetailsCell : UITableViewCell
{
    UIImageView *iconImageView;
    UILabel *userNameLabel;
    UILabel *contentLabel;
    UILabel *dateLabel;
}
@property (nonatomic, strong) LCReputationDetailsCellModel *model;
@end

@implementation LCReputationDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeCenter;

        userNameLabel  = [[UILabel alloc] init];
        userNameLabel.textColor = colorLightBlue;
        userNameLabel.font = [UIFont systemFontOfSize:15];

        contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = colorBlack;
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;


        dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = colorLightGray;
        dateLabel.font = [UIFont systemFontOfSize:14];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = colorBackGround;

        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:userNameLabel];
        [self.contentView addSubview:contentLabel];
        [self.contentView addSubview:dateLabel];
        [self.contentView addSubview:lineView];

        iconImageView.layer.cornerRadius = 20;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(10);
            make.size.equalTo(CGSizeMake(40, 40));
        }];

        [userNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.right).offset(10);
            make.top.equalTo(20);
        }];

        [contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userNameLabel);
            make.right.equalTo(-10);
            make.top.equalTo(userNameLabel.bottom).offset(15);
        }];

        [dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.bottom).offset(15);
            make.right.equalTo(-10);
        }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.top.equalTo(dateLabel.bottom).offset(15);
            make.height.equalTo(1);
        }];
    }
    return self;
}

- (void)setModel:(LCReputationDetailsCellModel *)model{
    _model = model;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.p_logo] placeholderImage:[CZWManager defaultIconImage]];
    userNameLabel.text = _model.p_uname;

    NSString *content = _model.p_content?_model.p_content:@"";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:content];
    att.yy_lineSpacing = 4;
    contentLabel.attributedText = att;
    dateLabel.text = _model.p_time;
}

@end

#pragma mark - LCReputationDetailsViewController
@interface LCReputationDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,FootCommentViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _count;
    LCReputationDetailsHeaderView *headerView;
    FootCommentView *footView;
}


@end

@implementation LCReputationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];

    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // _tableView.contentInset = self.contentInsets;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.lh_height -= 49;


    footView = [[FootCommentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    footView.delegate = self;
    [footView oneButton];
     footView.lh_bottom = self.view.lh_bottom;

    [self.view addSubview:_tableView];
    [self.view addSubview:footView];


    __weak __typeof(self)weakSelf = self;
    headerView = [[LCReputationDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    _tableView.tableHeaderView = headerView;

    _tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _count = 1;
        [weakSelf loadData];
    }];

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

    [HttpRequest GET:[URLFile url_reputationPLWithID:_ID p:_count s:10] success:^(id responseObject) {
      
        [_tableView.mj_header endRefreshing];
        if ([responseObject[@"rel"] count] == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_tableView.mj_footer endRefreshing];
        }
        if (_count == 1) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[LCReputationDetailsCellModel mj_objectArrayWithKeyValuesArray:responseObject[@"rel"]]];
        [_tableView reloadData];

    } failure:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)loadHeaderData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(headerView) weakHeaderView = headerView;
    __weak __typeof(_tableView) weakTabelView = _tableView;
    [HttpRequest GET:[URLFile url_reputationlistWithBid:nil sid:nil mid:nil ID:_ID iOrder:nil p:0 s:0] success:^(id responseObject) {
        [weakHeaderView setModel:[ReputationModel mj_objectWithKeyValues:responseObject]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakTabelView.tableHeaderView = nil;
            weakTabelView.tableHeaderView  = weakHeaderView;
        });
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - FootCommentViewDelegate
- (void)clickButton:(NSInteger)slected{
    if ([CZWManager manager].isLogin == NO) {

        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        return;
    }
    CustomCommentView *comment = [[CustomCommentView alloc] init];
    [comment send:^(NSString *content) {
        if (![NSString isNotNULL:content]) {
           MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"内容不能为空";
            [hud hide:YES afterDelay:1];
        }else if (content.length > 400){
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"内容最多400个字符";
            [hud hide:YES afterDelay:1];

        }else{
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"uid"] = [CZWManager manager].userID;
            dict[@"content"] = content;
             __weak __typeof(self) weakSelf = self;
             [HttpRequest POST:[URLFile url_reputationReplyWithID:_ID] parameters:dict success:^(id responseObject) {
                 if (responseObject[@"success"]) {
                     MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = responseObject[@"success"];
                     [hud hide:YES afterDelay:1];
                 }else if (responseObject[@"error"]){
                     MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     hud.mode = MBProgressHUDModeText;
                     hud.labelText = responseObject[@"error"];
                     [hud hide:YES afterDelay:1.5];
                 }
                 _count = 1;
                 [weakSelf loadData];
             } failure:^(NSError *error) {

             }];
        }
    }];
    [comment show];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCReputationDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LCReputationDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = _dataArray[indexPath.row];
    return cell;
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
