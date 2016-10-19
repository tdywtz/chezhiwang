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
    TTTAttributedLabel *titleLabel;//标题
    UILabel *questionDate;//问题时间
    CZWLabel *questionContent;//问题内容
    CZWLabel *answerContent;//回复内容
    UILabel *answerDate;//回复时间

    FootCommentView *footView;
}
@property (nonatomic,assign) NewsType type;
@property (nonatomic,strong) NSDictionary *dict;

@end

@implementation AnswerDetailsViewController
-(void)loadDataOne{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForGetZJDY],self.cid];

    [HttpRequest GET:url success:^(id responseObject) {

        self.dict = [responseObject copy];

        titleLabel.text = responseObject[@"question"];
        questionContent.text = _dict[@"content"];
        questionDate.text = _dict[@"date"];
        answerContent.text = _dict[@"answer"];
        answerDate.text = _dict[@"answertime"];
        [footView setReplyConut:responseObject[@"replycount"]];

    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        share.shareUrl = self.dict[@"url"]== nil?self.dict[@"FilePath"]:self.dict[@"url"];
        share.shareImage = [UIImage imageNamed:@"Icon-60"];
        NSString *html = self.dict[@"content"] == nil?self.dict[@"Content"]:self.dict[@"content"];
        if (html.length > 100) html = [html substringToIndex:99];
        share.shareContent = html;
        share.shareTitle = self.dict[@"question"];
        [share setBluffImageWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
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

    titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.numberOfLines = 0;
    titleLabel.preferredMaxLayoutWidth = WIDTH-30;

    CZWLabel *questionTitle = [[CZWLabel alloc] init];
    questionTitle.font = [UIFont systemFontOfSize:A-3];
    questionTitle.textColor = colorLightGray;
    questionTitle.text = @"  网友提问：";
    UIImage *questionImage = [UIImage imageNamed:@"答疑"];
    [questionTitle insertImage:questionImage frame:CGRectMake(0, -3, 17, 17) index:0];


    questionContent = [[CZWLabel alloc] init];
    questionContent.linesSpacing = 3;
    questionContent.textColor = colorDeepGray;
    questionContent.font = [UIFont systemFontOfSize:14];

    questionDate = [LHController createLabelWithFrame:CGRectZero Font:13 Bold:NO TextColor:colorLightGray Text:nil];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    CZWLabel *answerTitle = [[CZWLabel alloc] init];
    answerTitle.font = [UIFont systemFontOfSize:A-3];
    answerTitle.textColor = colorLightGray;
    answerTitle.text = @"  专家答复：";
    UIImage *answerTitleImage = [UIImage imageNamed:@"答疑"];
    [answerTitle insertImage:answerTitleImage frame:CGRectMake(0, -3, 17, 17) index:0];

    answerContent = [[CZWLabel alloc] init];
    answerContent.linesSpacing = 3;
    answerContent.textColor = colorDeepGray;
    answerContent.font = [UIFont systemFontOfSize:14];

    answerDate = [LHController createLabelWithFrame:CGRectZero Font:13 Bold:NO TextColor:colorLightGray Text:nil];

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
        make.centerX.equalTo(0);
        make.top.equalTo(20);
        //make.width.lessThanOrEqualTo(WIDTH-30);
    }];
    [questionTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];

    [questionContent makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionTitle.bottom).offset(10);
        make.left.equalTo(questionTitle);
        make.right.equalTo(-15);
    }];

    [questionDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionContent.bottom).offset(10);
        make.right.equalTo(-15);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(questionDate.bottom).offset(10);
        make.height.equalTo(10);
    }];

    [answerTitle makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.bottom).offset(10);
        make.left.equalTo(15);
    }];

    [answerContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(answerTitle.bottom).offset(10);
        make.right.equalTo(-15);
    }];

    [answerDate makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerContent.bottom).offset(10);
        make.right.equalTo(-15);
        make.bottom.equalTo(-20);
    }];

    [lineView2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(10);
    }];

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
    
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:self.cid andType:collectTypeAnswer];
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

        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [LHController alert:@"评论成功"];
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
