//
//  NewsTableHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTableHeaderView.h"

@interface NewsTableHeaderView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *buttonTop;
@property (nonatomic,strong) UIButton *buttonLeft;
@property (nonatomic,strong) UIButton *buttonRight;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControll;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UILabel *imageTitleLabel;
@property (nonatomic,strong) NSArray *pointNews;
@property (nonatomic,strong) NSArray *pointImages;

@end

@implementation NewsTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
        
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
        for (int i = 0; i < [responseObject count]; i ++) {
            NSDictionary *dict = responseObject[i];
            if (i == 0) {
                [weakSelf.buttonTop setTitle:dict[@"title"] forState:UIControlStateNormal];
            }else if (i == 1){
                [weakSelf.buttonLeft setTitle:dict[@"title"] forState:UIControlStateNormal];
            }else if (i == 2){
                [weakSelf.buttonRight setTitle:dict[@"title"] forState:UIControlStateNormal];
            }
        }

    } failure:^(NSError *error) {
        
    }];

    [HttpRequest GET:[URLFile urlStringForFocuspic] success:^(id responseObject) {
        weakSelf.pointImages = responseObject;
        
        for (UIView *view in weakSelf.scrollView.subviews) {
            [view removeFromSuperview];
        }
        for (int i = 0; i < weakSelf.pointImages.count+2; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH*i-WIDTH, 0, WIDTH, weakSelf.scrollView.frame.size.height)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 100+i;
            [weakSelf.scrollView addSubview:imageView];
            NSInteger index = i-1;
            if (index == -1) {
                index = weakSelf.pointImages.count-1;
            }
            if (index == weakSelf.pointImages.count){
                index = 0;
            }
            NSDictionary *dict = weakSelf.pointImages[index];
            //imageView.image = [UIImage imageNamed:@"新闻"];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
        }
        weakSelf.scrollView.contentInset = UIEdgeInsetsMake(0, WIDTH, 0, WIDTH*self.pointImages.count+WIDTH);
        weakSelf.pageControll.currentPage = 0;
        weakSelf.pageControll.numberOfPages = weakSelf.pointImages.count;
        if (weakSelf.timer == nil) {
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:weakSelf selector:@selector(scrollPages) userInfo:nil repeats:YES];
        }

    } failure:^(NSError *error) {
        
    }];
}

-(void)makeUI{
    self.buttonTop   = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:nil];
    self.buttonTop.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.buttonTop setTitleColor:colorOrangeRed forState:UIControlStateNormal];
    
    self.buttonLeft  = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:nil];
     self.buttonLeft.titleLabel.font = [UIFont systemFontOfSize:13];

    self.buttonRight = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick:) Text:nil];
     self.buttonRight.titleLabel.font = [UIFont systemFontOfSize:13];
    
    self.scrollView  = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.scrollsToTop = NO;
    
    self.imageTitleLabel = [LHController createLabelWithFrame:CGRectZero Font:15 Bold:NO TextColor:colorDeepGray Text:nil];
    self.imageTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.pageControll = [[UIPageControl alloc] init];
    self.pageControll.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControll.currentPageIndicatorTintColor = [UIColor colorWithRed:204/255.0 green:5/255.0 blue:10/255.0 alpha:1];
    
    
    [self addSubview:self.buttonTop];
    [self addSubview:self.buttonLeft];
    [self addSubview:self.buttonRight];
    [self addSubview:self.scrollView];
    [self addSubview:self.imageTitleLabel];
    [self addSubview:self.pageControll];
    
    [self.buttonTop makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.centerX.equalTo(0);
        make.size.lessThanOrEqualTo(CGSizeMake(WIDTH, 20));
    }];
    
    [self.buttonLeft makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonTop.bottom);
        make.left.greaterThanOrEqualTo(10);
        make.height.equalTo(20);
        make.right.equalTo(-WIDTH/2-10);
    }];
    
    [self.buttonRight makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonLeft);
        make.right.lessThanOrEqualTo(-10);
        make.left.equalTo(self.buttonLeft.right).offset(10);
        make.height.equalTo(self.buttonLeft);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonLeft.bottom);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(self.imageTitleLabel.top);
    }];
    
    
    [self.imageTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(30);
    }];
    
    [self.pageControll makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(self.scrollView);
        make.height.equalTo(20);
    }];
}



-(void)buttonClick:(UIButton *)button{
    NSInteger index = 0;
    if (button == _buttonTop) {
        index = 0;
    }else if (button == _buttonLeft){
        index = 1;
    }else{
        index = 2;
    }
    NSDictionary *dict = self.pointNews[index];
    if (self.block) {
        self.block(dict[@"id"],dict[@"title"]);
    }
}

#pragma mark - 图片手势
-(void)tap:(UITapGestureRecognizer *)tap{
    NSInteger index = self.pageControll.currentPage;
    if (index >= 0 && index < self.pointImages.count) {
         NSDictionary *dict = self.pointImages[index];
        if (self.block) {
            self.block(dict[@"id"],dict[@"title"]);
        }
    }

}


#pragma mark - 定时切换图片
-(void)scrollPages{
    
    [UIView animateWithDuration:0.1 animations:^{
        _scrollView.contentOffset = CGPointMake(WIDTH+_scrollView.contentOffset.x, 0);
    }];
    if (self.scrollView.contentOffset.x > self.pointImages.count*WIDTH-1) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (self.scrollView.contentOffset.x < 0) {
        self.scrollView.contentOffset = CGPointMake(WIDTH*self.pointImages.count-WIDTH, 0);
    }
    NSInteger index = self.scrollView.contentOffset.x/WIDTH;
    self.pageControll.currentPage = index;
    
    self.imageTitleLabel.text = self.pointImages[index][@"title"];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   
    if (self.scrollView.contentOffset.x < 0) {
        self.scrollView.contentOffset = CGPointMake(WIDTH*(self.pointImages.count-1), 0);
    }
    if (self.scrollView.contentOffset.x > WIDTH*self.pointImages.count-1) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }

    NSInteger index = scrollView.contentOffset.x/WIDTH;
    if(index >= 0 && index < self.pointImages.count){
    
        self.pageControll.currentPage = index;
        self.imageTitleLabel.text = self.pointImages[index][@"title"];
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
    [self.timer invalidate];
    self.timer = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
