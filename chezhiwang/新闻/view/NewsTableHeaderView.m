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
#import <TTTAttributedLabel.h>

@interface NewsTableHeaderImageView : UIImageView

@property (nonatomic,strong) NSDictionary *dictionary;

@end

@implementation NewsTableHeaderImageView


@end

@interface NewsTableHeaderView ()<LHLabelDelegate,LHPageViewDataSource,LHPageViewDelegate>

@property (nonatomic,strong) UIButton *buttonTop;
@property (nonatomic,strong) LHLabel  *toplabel;

@property (nonatomic,strong) UIPageControl *pageControll;
@property (nonatomic,strong) LHPageView *pageView;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) TTTAttributedLabel *imageTitleLabel;
@property (nonatomic,strong) NSArray *pointNews;
@property (nonatomic,strong) NSArray *pointImages;
@property (nonatomic,strong) NSMutableArray *imageViews;

@end

@implementation NewsTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        [self  addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             [self loadData];
        });
    }
    return self;
}

-(void)loadData{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:[URLFile urlStringForFocusnews] success:^(id responseObject) {
        weakSelf.pointNews = responseObject;

        if ([responseObject count] >= 3) {

            [weakSelf.buttonTop setTitle:responseObject[0][@"title"] forState:UIControlStateNormal];

            NSString *text1 = responseObject[1][@"title"];
            NSString *text2 = responseObject[2][@"title"];
            NSString *text = [NSString stringWithFormat:@"[%@]    [%@]",text1,text2];
            weakSelf.toplabel.text = text;
            [weakSelf.toplabel addData:responseObject[1] range:[text rangeOfString:text1]];
           [weakSelf.toplabel addData:responseObject[2] range:[text rangeOfString:text2]];
        }
    } failure:^(NSError *error) {
        
    }];

    [HttpRequest GET:[URLFile urlStringForFocuspic] success:^(id responseObject) {
        weakSelf.pointImages = responseObject;

        if (weakSelf.imageViews == nil) {
            weakSelf.imageViews = [[NSMutableArray alloc] init];
        }
        for (NSDictionary *dict in responseObject) {
            NewsTableHeaderImageView *imageView = [[NewsTableHeaderImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
            imageView.dictionary = dict;
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor orangeColor];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
            [weakSelf.imageViews addObject:imageView];
        }
        if (weakSelf.imageViews.count) {
            NewsTableHeaderImageView *imageView  = weakSelf.imageViews[0];
            [weakSelf.pageView setView:imageView direction:0 anime:NO];
            weakSelf.imageTitleLabel.text = imageView.dictionary[@"title"];
            weakSelf.pageControll.numberOfPages = weakSelf.imageViews.count;
            weakSelf.pageControll.currentPage = 0;
        }
        [weakSelf scheduledTimer];

    } failure:^(NSError *error) {
        
    }];
}

-(void)makeUI{


    self.buttonTop   = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:nil];
    self.buttonTop.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.buttonTop setTitleColor:RGB_color(237, 27, 36, 1) forState:UIControlStateNormal];
    

    self.toplabel = [[LHLabel alloc] init];
    self.toplabel.textAlignment = kCTTextAlignmentCenter;
    self.toplabel.textColor = colorDeepGray;
    self.toplabel.linkColor = colorDeepGray;
    self.toplabel.numberOfLines = 1;
    self.toplabel.preferredMaxLayoutWidth = WIDTH-20;
    self.toplabel.font = [UIFont systemFontOfSize:13];
    self.toplabel.delegate = self;


    self.pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0) space:0];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;

    
    self.imageTitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    self.imageTitleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.imageTitleLabel.textInsets = UIEdgeInsetsMake(0, 10, 0, 95);
    self.imageTitleLabel.textColor = [UIColor whiteColor];
    self.imageTitleLabel.textAlignment = kCTTextAlignmentLeft;
    
    self.pageControll = [[UIPageControl alloc] init];
    self.pageControll.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControll.currentPageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:5/255.0 blue:10/255.0 alpha:1];

    
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
        detail.titleLabelText = dict[@"title"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }else if(type == 2){
        //投诉
        ComplainDetailsViewController *detail = [[ComplainDetailsViewController alloc] init];
        detail.textTitle = dict[@"title"];
        detail.cid = dict[@"id"];
        detail.type = @"2";
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];

    }else if (type == 3){
        //答疑
        AnswerDetailsViewController *detail = [[AnswerDetailsViewController alloc] init];
        detail.textTitle = dict[@"title"];
        detail.cid = dict[@"id"];
        detail.type = @"3";
        detail.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:detail animated:YES];
    }else if (type == 4){
       //新车调查
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = dict[@"id"];
        detail.titleLabelText = dict[@"title"];
        detail.invest = YES;
        detail.type = dict[@"type"];
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


#pragma mark - LHLabelDelegate
- (void)storage:(LHLabelTextStorage *)storage{

    NSDictionary *dict = storage.returnData;
    [self pushWithDict:dict];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
