//
//  AnswerDetailsViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerDetailsViewController.h"
#import "CommentListViewController.h"
#import "CustomCommentView.h"
#import "LoginViewController.h"
#import "CZWShareViewController.h"
#import "FootCommentView.h"

@interface AnswerDetailsViewController ()<FootCommentViewDelegate>
{
    CGFloat A;

    CustomCommentView *_commentView;
    YYLabel *titleLabel;//标题
    UILabel *questionDate;//问题时间
    YYLabel *questionContent;//问题内容
    YYLabel *answerContent;//回复内容
    UILabel *answerDate;//回复时间

    FootCommentView *footView;
}
@property (nonatomic,assign) NewsType type;
@property (nonatomic,strong) NSDictionary *dict;

@end

@implementation AnswerDetailsViewController
-(void)loadDataOne{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForGetZJDY],self.cid];
    __weak __typeof(self) _self = self;
    [HttpRequest GET:url success:^(id responseObject) {

        _self.dict = [responseObject copy];

        if (responseObject[@"question"]) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:responseObject[@"question"]];
            att.yy_font = titleLabel.font;
            att.yy_color = titleLabel.textColor;
            att.yy_lineSpacing = 4;
            titleLabel.attributedText = att;
        }
        if (responseObject[@"content"]) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:responseObject[@"content"]];
            att.yy_font = questionContent.font;
            att.yy_color = questionContent.textColor;
            att.yy_lineSpacing = 4;
            questionContent.attributedText = att;
        }
        if (responseObject[@"answer"]) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:responseObject[@"answer"]];
            att.yy_font = answerContent.font;
            att.yy_color = answerContent.textColor;
            att.yy_lineSpacing = 4;
            answerContent.attributedText = att;
        }
        questionDate.text = responseObject[@"date"];
        answerDate.text = responseObject[@"answertime"];
        [footView setReplyConut:responseObject[@"replycount"]];

    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答疑";
    A = [LHController setFont];
    self.type = NewsTypeAnswer;
    [self createRightItems];
    [self createScrollViewSubViews];
    [self createFootView];
    [self loadDataOne];
}


-(void)createRightItems{
    FmdbManager *fb = [FmdbManager shareManager];

    NSDictionary *dict = [fb selectFromCollectWithId:_cid andType:collectTypeAnswer];
    BOOL isSelect = NO;
    if ([dict allKeys].count > 0) {
        isSelect = YES;
    }

    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];

        UIButton *btn = [LHController createButtnFram:CGRectMake(5, 0, 20, 20) Target:self Action:@selector(rightItemClick:) Text:nil];
        btn.tag = 100+i;
        if (i == 1) {
            btn.frame = CGRectMake(0, 0, 23, 23);
            [btn setBackgroundImage:[UIImage imageNamed:@"comment_收藏"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"comment_收藏_yes"] forState:UIControlStateSelected];
            btn.selected = isSelect;
        }else{

            [btn setBackgroundImage:[UIImage imageNamed:@"comment_转发"] forState:UIControlStateNormal];
        }
        [bg addSubview:btn];
        btn.center = CGPointMake(bg.frame.size.width/2, bg.frame.size.height/2);
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bg];
        [btnArray addObject:item];
    }

    self.navigationItem.rightBarButtonItems = btnArray;
}

-(void)rightItemClick:(UIButton *)btn{

    if (btn.tag == 101) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [self favorate];
        }else{
            [self deleteFavorate];
        }
    }else{
        CZWShareViewController *share = [[CZWShareViewController alloc] initWithParentViewController:self];
        share.shareUrl = self.dict[@"filepath"];
        share.shareContent = self.dict[@"content"];
        share.shareTitle = self.dict[@"question"];
        [self presentViewController:share animated:YES completion:nil];
    }
}


#pragma mark - 数据显示
-(void)createScrollViewSubViews{

    CGRect rect = self.scrollView.frame;
    rect.size.height -= 49;
    self.scrollView.frame = rect;

    self.contentView = [[UIView alloc] init];
    [self.scrollView addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
        make.width.equalTo(WIDTH);
    }];

    titleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = colorDeepBlack;
    titleLabel.preferredMaxLayoutWidth = WIDTH-20;

    YYLabel *questionTitle = [[YYLabel alloc] init];
    questionTitle.font = [UIFont systemFontOfSize:16];
    questionTitle.textColor = colorDeepGray;
    questionTitle.attributedText = [self titleAtt:@"  网友提问：" image:[UIImage imageNamed:@"auto_answerDetail_question"]];

    questionContent = [[YYLabel alloc] init];
    questionContent.textColor = colorBlack;
    questionContent.font = [UIFont systemFontOfSize:16];
    questionContent.numberOfLines = 0;
    questionContent.preferredMaxLayoutWidth = WIDTH - 20;

    questionDate = [LHController createLabelWithFrame:CGRectZero Font:14 Bold:NO TextColor:colorDeepGray Text:nil];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorBackGround;

    YYLabel *answerTitle = [[YYLabel alloc] init];
    answerTitle.font = [UIFont systemFontOfSize:16];
    answerTitle.textColor = colorDeepGray;
    answerTitle.attributedText = [self titleAtt:@"  专家答复：" image:[UIImage imageNamed:@"auto_answerDetail_answer"]];
  

    answerContent = [[YYLabel alloc] init];
    answerContent.textColor = colorBlack;
    answerContent.font = [UIFont systemFontOfSize:16];
    answerContent.numberOfLines = 0;
    answerContent.preferredMaxLayoutWidth = WIDTH - 20;

    answerDate = [LHController createLabelWithFrame:CGRectZero Font:14 Bold:NO TextColor:colorLightGray Text:nil];

    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = colorLineGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:questionTitle];
    [self.contentView addSubview:questionContent];
    [self.contentView addSubview:questionDate];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:answerTitle];
    [self.contentView addSubview:answerContent];
    [self.contentView addSubview:answerDate];
    [self.contentView addSubview:lineView2];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(23);
        make.width.lessThanOrEqualTo(WIDTH-20);
    }];
    
    [questionTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(23);
    }];

    [questionContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionTitle.bottom).offset(10);
        make.left.equalTo(questionTitle);
        make.right.equalTo(-10);
    }];

    [questionDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionContent.bottom).offset(10);
        make.right.equalTo(-10);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(questionDate.bottom).offset(10);
        make.height.equalTo(10);
    }];

    [answerTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(20);
        make.left.equalTo(10);
    }];

    [answerContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(answerTitle.bottom).offset(12);
        make.right.equalTo(-10);
    }];

    [answerDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerContent.bottom).offset(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(-20);
    }];

    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(10);
    }];

}

- (NSAttributedString *)titleAtt:(NSString *)text image:(UIImage *)image{
    NSMutableAttributedString *attchment = [NSMutableAttributedString yy_attachmentStringWithContent:image  contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(17, 17) alignToFont:[UIFont systemFontOfSize:16] alignment:YYTextVerticalAlignmentCenter];

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.yy_font = [UIFont systemFontOfSize:16];
    att.yy_color = colorDeepGray;
    [att insertAttributedString:attchment atIndex:0];
    return att;
}

#pragma mark - 底部横条
-(void)createFootView{
    footView = [[FootCommentView alloc] initWithFrame:CGRectZero];
    footView.delegate = self;
    [self.view addSubview:footView];

    [footView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(49);
    }];
}

#pragma mark - 底部右侧按钮响应方法
-(void)btnClick:(UIButton *)btn{

    CommentListViewController *uct = [[CommentListViewController alloc] init];
    uct.cid = _cid;
    uct.type = self.type;
    uct.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:uct animated:YES];

}

#pragma  mark - 收藏
-(void)favorate{

    if (titleLabel.text && questionDate.text && self.cid) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.cid andTime:questionDate.text andTitle:titleLabel.text andType:collectTypeAnswer];
        [LHController alert:@"收藏成功"];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:self.cid andType:collectTypeAnswer];
    [LHController alert:@"取消收藏成功"];
}


#pragma mark - 提交评论
-(void)submitComment:(NSString *)content{

    if (![LHController judegmentSpaceChar:content]) {
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].userID forKey:@"uid"];
    [dict setObject:@"0" forKey:@"fid"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",self.type];
    [dict setObject:appOrigin forKey:@"origin"];

    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {

        if (responseObject[@"success"]) {
            [LHController alert:responseObject[@"success"]];
            [footView addReplyCont];

        }else{
            [LHController alert:@"评论失败"];
        }

    } failure:^(NSError *error) {
        [LHController alert:@"评论失败"];
    }];
}

#pragma mark - FootCommentViewDelegate
- (void)clickButton:(NSInteger)slected{
    if (slected == 0) {
        if ([CZWManager manager].isLogin) {
        
            CustomCommentView *commentView = [[CustomCommentView alloc] init];
            [commentView show];
            [commentView send:^(NSString *content) {
                [self submitComment:content];
            }];
        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
    }else{
        CommentListViewController *comment = [[CommentListViewController alloc] init];
        comment.type = self.type;
        comment.cid = self.cid;
        [self.navigationController pushViewController:comment animated:YES];
    }
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
