//
//  NewsTableHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTableHeaderView.h"
#import "LHPageView.h"
#import "NewsDetailViewController.h"
#import "ComplainDetailsViewController.h"
#import "AnswerDetailsViewController.h"
#import "AdvertisementViewController.h"

@interface NewsTableHeaderImageView : UIImageView

@property (nonatomic,strong) NSDictionary *dictionary;

@end

@implementation NewsTableHeaderImageView


@end

@interface NewsTableHeaderView ()<LHPageViewDataSource,LHPageViewDelegate>

@property (nonatomic,strong) UIButton *buttonTop;
@property (nonatomic,strong) YYLabel  *toplabel;

@property (nonatomic,strong) UIPageControl *pageControll;
@property (nonatomic,strong) LHPageView *pageView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) TTTAttributedLabel *imageTitleLabel;

@property (nonatomic,strong) NSArray *imageViews;

@end

@implementation NewsTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI{


    self.buttonTop   = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:nil];
    self.buttonTop.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23.5)];
    [self.buttonTop setTitleColor:RGB_color(237, 27, 36, 1) forState:UIControlStateNormal];
    

    self.toplabel = [[YYLabel alloc] init];
    self.toplabel.textAlignment = kCTTextAlignmentCenter;
    self.toplabel.textColor = RGB_color(119, 119, 119, 1);
    self.toplabel.numberOfLines = 1;
    self.toplabel.preferredMaxLayoutWidth = WIDTH-20;
    self.toplabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    self.toplabel.textAlignment = NSTextAlignmentCenter;

    self.pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300) space:0];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;

    
    self.imageTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.imageTitleLabel.backgroundColor = RGB_color(0, 0, 0, 0.6);
    self.imageTitleLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 95);
    self.imageTitleLabel.textColor = [UIColor whiteColor];
    self.imageTitleLabel.textAlignment = kCTTextAlignmentLeft;
    
    self.pageControll = [[UIPageControl alloc] init];
    self.pageControll.pageIndicatorTintColor = RGB_color(149, 149, 149, 1);
    self.pageControll.currentPageIndicatorTintColor = RGB_color(246, 162, 3, 1);

    
    [self addSubview:self.buttonTop];
    [self addSubview:self.toplabel];
    [self addSubview:self.pageView];
    [self addSubview:self.imageTitleLabel];
    [self addSubview:self.pageControll];



    [self.buttonTop makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.centerX.equalTo(0);
        make.size.lessThanOrEqualTo(CGSizeMake(WIDTH, 25));
    }];
    

    [self.toplabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.size.lessThanOrEqualTo(WIDTH-20);
        make.top.equalTo(self.buttonTop.bottom).offset(5);
    }];
    
    [self.imageTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(35);
    }];
    
    [self.pageControll makeConstraints:^(MASConstraintMaker *make) {

        make.right.equalTo(-15);
        make.centerY.equalTo(self.imageTitleLabel);
        make.height.equalTo(20);
    }];

    [self.pageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toplabel.bottom).offset(10);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
    }];

}



-(void)buttonClick:(UIButton *)button{

    NSDictionary *dict = self.pointNews[0];
    [self pushWithDict:dict];
}

#pragma mark - 图片手势
-(void)tap:(UITapGestureRecognizer *)tap{

    NSInteger index = self.pageControll.currentPage;
    if (index >= 0 && index < self.pointImages.count) {
         NSDictionary *dict = self.pointImages[index];
        [self pushWithDict:dict];
    }
}

#pragma mark - set
- (void)setPointNews:(NSArray *)pointNews{
    _pointNews = pointNews;

    if ([_pointNews count] >= 3) {

        [self.buttonTop setTitle:_pointNews[0][@"title"] forState:UIControlStateNormal];

        NSString *text1 = _pointNews[1][@"title"];
        NSString *text2 = _pointNews[2][@"title"];
        NSString *text = [NSString stringWithFormat:@"[%@]    [%@]",text1,text2];

        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:text];
        one.yy_color = RGB_color(119, 119, 119, 1);
        one.yy_font = [UIFont systemFontOfSize:PT_FROM_PX(18)];

        __weak __typeof(self)weakSelf = self;
        YYTextHighlight *highlight1 = [YYTextHighlight new];
        [highlight1 setColor:colorLightBlue];
        highlight1.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            [weakSelf pushWithDict:_pointNews[1]];
        };


        YYTextHighlight *highlight2 = [YYTextHighlight new];
        [highlight2 setColor:colorLightBlue];
        highlight2.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            [weakSelf pushWithDict:_pointNews[2]];
        };



        [one yy_setTextHighlight:highlight1 range:[text rangeOfString:text1]];
        [one yy_setTextHighlight:highlight2 range:[text rangeOfString:text2]];

        self.toplabel.attributedText = one;
    }

}

- (void)setPointImages:(NSArray *)pointImages{
    if (pointImages.count == 0) {
        return;
    }
    _pointImages = pointImages;

    NSMutableArray *imageViews = [[NSMutableArray alloc] init];

    for (NSDictionary *dict in pointImages) {
        NewsTableHeaderImageView *imageView = [[NewsTableHeaderImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 300)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        imageView.dictionary = dict;
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor orangeColor];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        [imageViews addObject:imageView];
    }
    self.imageViews = imageViews;

    if (self.imageViews.count) {
        NewsTableHeaderImageView *imageView  = self.imageViews[0];
        [self.pageView setView:imageView direction:0 anime:NO];
        self.imageTitleLabel.text = imageView.dictionary[@"title"];
        self.pageControll.numberOfPages = self.imageViews.count;
        self.pageControll.currentPage = 0;
    }
    [self scheduledTimer];
}

#pragma mark - 定时切换图片
-(void)scrollPages{

    NSInteger index = [self.imageViews indexOfObject:_pageView.currentView];
    index ++;
    if (index >= self.imageViews.count) {
        index = 0;
    }
    [_pageView setView:self.imageViews[index] direction:LHPageViewDirectionReverse anime:YES];
}

- (void)scheduledTimer{
    if (_timer) {
         [self cancelTimer];
    }

     _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];
}

- (void)cancelTimer{
        [_timer invalidate];
        _timer = nil;
}

#pragma mark - 页面跳转方法
- (void)pushWithDict:(NSDictionary *)dict{

    NSInteger type = [dict[@"type"] integerValue];
    if (type == 1 || type == 0) {
        //新闻
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = dict[@"id"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }else if(type == 2){
        //投诉
        ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
        detail.cid = dict[@"id"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];

    }else if (type == 3){
        //答疑
        AnswerDetailsViewController *detail = [[AnswerDetailsViewController alloc] init];
      
        detail.cid = dict[@"id"];

        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }else if (type == 4){
       //新车调查
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = dict[@"id"];

        detail.invest = YES;
       // detail.type = dict[@"type"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];

    }else if (type == 99){
        //广告
        AdvertisementViewController *adver = [[AdvertisementViewController alloc] init];
        adver.url = dict[@"url"];
        adver.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:adver animated:YES];
    }
}
#pragma mark - LHPageViewDataSource
- (UIView *)pageView:(LHPageView *)pageView viewBeforeView:(UIView *)view{
    NSInteger index = [self.imageViews indexOfObject:view];
    //关闭
    [self cancelTimer];
    index--;
    if (index < 0) {
        index = self.imageViews.count-1;
    }
    if (index >= 0) {
        return self.imageViews[index];
    }
    return nil;
}
- (UIView *)pageView:(LHPageView *)pageViewController viewAfterView:(UIView *)view{
    NSInteger index = [self.imageViews indexOfObject:view];
    index++;
    //关闭
    [self cancelTimer];
    if (index >= self.imageViews.count) {
        index = 0;
    }
    if (index < self.imageViews.count) {
        return self.imageViews[index];
    }
    return nil;
}

- (NSInteger)presentationCountForPageView:(LHPageView *)pageView{
    return self.imageViews.count;
}
- (NSInteger)presentationIndexForPageView:(LHPageView *)pageView{
    return [self.imageViews indexOfObject:pageView.currentView];
}

#pragma mark - LHPageViewDelegate
- (void)pageView:(LHPageView *)pageView didFinishAnimating:(BOOL)finished previousView:(UIView *)previousView transitionCompleted:(BOOL)completed{
    if (completed) {
        //是手势拖动，重新开启
        [self scheduledTimer];
    }
  //设置page
    self.pageControll.currentPage = [self.imageViews indexOfObject:previousView];
    //设置title
    NewsTableHeaderImageView *imageView = (NewsTableHeaderImageView *)previousView;
    self.imageTitleLabel.text = imageView.dictionary[@"title"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
