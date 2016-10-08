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

@interface AnswerDetailsViewController ()
{
    CGFloat A;

    UILabel *numLabel;
    CustomCommentView *_commentView;
    CZWLabel *titleLabel;//标题
    UILabel *questionDate;//问题时间
    CZWLabel *questionContent;//问题内容

    CZWLabel *answerContent;//回复内容
    UILabel *answerDate;//回复时间
}
@property (strong,nonatomic) UIView *contentView;
@property (nonatomic,strong) NSDictionary *dict;

@end

@implementation AnswerDetailsViewController
-(void)loadDataOne{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForGetZJDY],self.cid];

    [HttpRequest GET:url success:^(id responseObject) {
        if ([responseObject count] == 0) {
            return ;
        }
        self.dict = responseObject[0];

        questionContent.text = _dict[@"Content"];
        questionDate.text = _dict[@"IssueDate"];
        answerContent.text = _dict[@"Answer"];
        answerDate.text = _dict[@"AnswerTime"];


    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    A = [LHController setFont];
    self.type = @"3";
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
        NSString *iamgeName = [NSString stringWithFormat:@"share%d",3-i];
        [btn setBackgroundImage:[UIImage imageNamed:iamgeName] forState:UIControlStateNormal];
        if (i == 1) {
            btn.frame = CGRectMake(0, 0, 25, 25);
            [btn setBackgroundImage:[UIImage imageNamed:@"xin"] forState:UIControlStateSelected];
            btn.selected = isSelect;
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
        share.shareTitle = self.textTitle;
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

    titleLabel = [[CZWLabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = self.textTitle;



    UILabel *questionTitle = [LHController createLabelWithFrame:CGRectZero Font:A-3 Bold:NO TextColor:colorLightGray Text:@"网友提问："];

    questionContent = [[CZWLabel alloc] init];
    questionContent.linesSpacing = 3;
    questionContent.firstLineHeadIndent = 28;
    questionContent.textColor = colorDeepGray;
    questionContent.font = [UIFont systemFontOfSize:14];

    questionDate = [LHController createLabelWithFrame:CGRectZero Font:13 Bold:NO TextColor:colorLightGray Text:nil];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    UILabel *answerTitle = [LHController createLabelWithFrame:CGRectZero Font:A-3 Bold:NO TextColor:colorLightGray Text:@"专家答复："];

    answerContent = [[CZWLabel alloc] init];
    answerContent.linesSpacing = 3;
    answerContent.firstLineHeadIndent = 28;
    answerContent.textColor = colorDeepGray;
    answerContent.font = [UIFont systemFontOfSize:14];

    answerDate = [LHController createLabelWithFrame:CGRectZero Font:13 Bold:NO TextColor:colorLightGray Text:nil];

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:questionTitle];
    [self.contentView addSubview:questionContent];
    [self.contentView addSubview:questionDate];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:answerTitle];
    [self.contentView addSubview:answerContent];
    [self.contentView addSubview:answerDate];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(20);
        make.width.lessThanOrEqualTo(WIDTH-30);
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
        make.height.equalTo(1);
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

}


#pragma mark - 底部横条
-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    view.backgroundColor = [UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1];
    [self.view addSubview:view];

    UIButton *write =  [LHController createButtnFram:CGRectMake(10, 10,WIDTH-80, 28) Target:self Action:@selector(writeClick) Text:nil];
    write.backgroundColor = [UIColor whiteColor];
    [view addSubview:write];

    [write setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [write setTitle:@"写评论" forState:UIControlStateNormal];
    [write setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [write setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    write.titleLabel.font = [UIFont systemFontOfSize:14];

    UIButton *btn = [LHController createButtnFram:CGRectMake(write.frame.origin.x+write.frame.size.width+10, 9, 30, 30) Target:self Action:@selector(btnClick:) Text:nil];
    [btn setImage:[UIImage imageNamed:@"share1"] forState:UIControlStateNormal];
    [view addSubview:btn];
    numLabel = [LHController createLabelWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width, btn.frame.origin.y, 20, 30) Font:A-3 Bold:NO TextColor:[UIColor whiteColor] Text:nil];
    numLabel.textColor = [UIColor whiteColor];
    [view addSubview:numLabel];
    [self loadDataTotal];
}
//


#pragma mark - 取得总评论数
-(void)loadDataTotal{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForPL_total],_cid,self.type];
    [HttpRequest GET:url success:^(id responseObject) {
        NSDictionary *dict = responseObject[0];
        numLabel.text = dict[@"count"] == nil?@"0":dict[@"count"];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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

    if (self.textTitle && self.dict[@"IssueDate"] && self.cid) {
        FmdbManager *fb = [FmdbManager shareManager];
        [fb insertIntoCollectWithId:self.cid andTime:self.dict[@"IssueDate"] andTitle:self.textTitle andType:collectTypeAnswer];
    }
}

#pragma mark - 取消收藏成功
-(void)deleteFavorate{
    FmdbManager *fb = [FmdbManager shareManager];
    [fb deleteFromCollectWithId:self.cid andType:collectTypeAnswer];
}


#pragma mark - 点击评论按钮
-(void)writeClick{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        _commentView = [[CustomCommentView alloc] init];
        [_commentView show];
        [_commentView send:^(NSString *content) {
            [self submitComment:content];
        }];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:my animated:YES];
    }
}


#pragma mark - 提交评论
-(void)submitComment:(NSString *)content{

    if (![LHController judegmentSpaceChar:content]) {
        return;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:user_id] forKey:@"uid"];
    [dict setObject:@"0" forKey:@"fid"];
    [dict setObject:content forKey:@"content"];
    [dict setObject:self.cid forKey:@"tid"];
    [dict setObject:self.type forKey:@"type"];
    [dict setObject:appOrigin forKey:@"origin"];

    [HttpRequest POST:[URLFile urlStringForAddcomment] parameters:dict success:^(id responseObject) {
        [self loadDataTotal];
        if ([responseObject[@"result"] isEqualToString:@"success"]) {
            [LHController alert:@"评论成功"];
            [self loadDataTotal];
        }else{
            [LHController alert:@"评论失败"];
        }

    } failure:^(NSError *error) {
        [LHController alert:@"评论失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"PageOne"];
//
//    [LHController getCustomTabBar].hidden = YES;
//
//    FmdbManager *fb = [FmdbManager shareManager];
//    NSDictionary *dict = [fb selectFromCollectWithId:self.cid andType:collectTypeAnswer];
//
//    if ([dict allKeys].count > 0) {
//        UIButton *btn = (UIButton *)[self.view viewWithTag:201];
//        btn.selected = YES;
//    }
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"PageOne"];
//}
/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
