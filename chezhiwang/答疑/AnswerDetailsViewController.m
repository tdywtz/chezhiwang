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
}
@property (nonatomic,strong) NSDictionary *dict;
@end

@implementation AnswerDetailsViewController
-(void)loadDataOne{
    CustomActivity *activity = [self valueForKey:@"activity"];

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForGetZJDY],self.cid];
  [HttpRequest GET:url success:^(id responseObject) {
      self.dict = responseObject[0];
      [self createScrollViewSubViews];
      [activity animationStoping];
  } failure:^(NSError *error) {
      [activity animationStoping];
  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    A = [LHController setFont];
}

#pragma mark - 数据显示
-(void)createScrollViewSubViews{
    UIScrollView *scrollView = [self valueForKey:@"scrollView"];
    
    CGSize textSize =[self.textTitle boundingRectWithSize:CGSizeMake(WIDTH-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:A]} context:nil].size;
    
    UILabel *titleLabel = [LHController createLabelWithFrame:CGRectMake(10, 30, WIDTH-20, textSize.height) Font:A Bold:NO TextColor:nil Text:self.textTitle];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:titleLabel];
    
    UILabel *complainTitle = [LHController createLabelWithFrame:CGRectMake(15, titleLabel.frame.size.height+titleLabel.frame.origin.y+25, 80, 20) Font:A-3 Bold:NO TextColor:colorLightGray Text:@"网友提问:"];
    [scrollView addSubview:complainTitle];
    
    
    NSString *str1 = self.dict[@"Content"];
    NSAttributedString *att1 = [self attString:str1 Font:A-3];
    //计算高度
    CGSize size = [att1 boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    UILabel *complainContent = [LHController createLabelWithFrame:CGRectMake(15, complainTitle.frame.origin.y+30, WIDTH-30, size.height) Font:A-3 Bold:NO TextColor:nil Text:str1];
    complainContent.attributedText = att1;
    [complainContent sizeToFit];
    [scrollView addSubview:complainContent];
    
    UILabel *questionTime = [LHController createLabelWithFrame:CGRectMake(WIDTH-145, complainContent.frame.size.height+complainContent.frame.origin.y+20, 130, 20) Font:A-5 Bold:NO TextColor:colorLightGray Text:self.dict[@"IssueDate"]];
    questionTime.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:questionTime];
    
    UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(15, questionTime.frame.size.height+questionTime.frame.origin.y+10, WIDTH-30, 1)];
    fg2.backgroundColor = colorLineGray;
    [scrollView addSubview:fg2];
    
    UILabel *answer = [LHController createLabelWithFrame:CGRectMake(15, fg2.frame.origin.y+15, 80, 20) Font:A-3 Bold:NO TextColor:colorLightGray Text:@"专家答复:"];
    [scrollView addSubview:answer];
    
    
    NSString *str2 = self.dict[@"Answer"];
    
    NSAttributedString *att2 = [self attString:str2 Font:A-3];
    CGSize size2 = [att2 boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    UILabel *answerContent = [LHController createLabelWithFrame:CGRectMake(15, answer.frame.origin.y+30, WIDTH-30, size2.height) Font:A-3 Bold:NO TextColor:nil Text:str2];
    answerContent.attributedText = att2;
    [answerContent sizeToFit];
    [scrollView addSubview:answerContent];
    
    UILabel *answerTime = [LHController createLabelWithFrame:CGRectMake(WIDTH-145, answerContent.frame.origin.y+answerContent.frame.size.height+10, 130, 20) Font:A-5 Bold:NO TextColor:colorLightGray Text:self.dict[@"AnswerTime"]];
    answerTime.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:answerTime];
    
    scrollView.contentSize = CGSizeMake(0, answerTime.frame.origin.y+answerTime.frame.size.height+40);
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size{
    if (!str) {
        return nil ;
    }
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *syyle = [[NSMutableParagraphStyle alloc] init];
    [syyle setLineSpacing:4];
    [syyle setLineBreakMode:NSLineBreakByWordWrapping];
    syyle.firstLineHeadIndent = 30;
    
    [att addAttribute:NSParagraphStyleAttributeName value:syyle range:NSMakeRange(0, str.length)];
    //[att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,str.length)];
    return att;
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
