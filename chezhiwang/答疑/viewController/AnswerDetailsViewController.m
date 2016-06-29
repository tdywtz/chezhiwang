//
//  AnswerDetailsViewController.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerDetailsViewController.h"

@interface AnswerDetailsViewController ()
{
    CGFloat A;
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
    
    [self createScrollViewSubViews];
   [self loadDataOne];
}

#pragma mark - 数据显示
-(void)createScrollViewSubViews{
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
