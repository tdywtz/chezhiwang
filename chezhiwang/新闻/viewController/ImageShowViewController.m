//
//  ImageShowViewController.m
//  chezhiwang
//
//  Created by bangong on 16/6/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ImageShowViewController.h"
#import "LTInfiniteScrollView.h"
#import "JT3DScrollView.h"

@interface ImageShowViewController ()<LTInfiniteScrollViewDataSource,LTInfiniteScrollViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) LTInfiniteScrollView *LTScollView;
@property (nonatomic,strong) JT3DScrollView *JTScrollView;

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.titleLabel];
    
    self.LTScollView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectZero];
    self.LTScollView.verticalScroll = NO;
    self.LTScollView.delegate = self;
    self.LTScollView.dataSource = self;
    self.LTScollView.maxScrollDistance = 13;
   
    [self.view addSubview:self.LTScollView];
    
    self.JTScrollView = [[JT3DScrollView alloc] initWithFrame:CGRectZero];
    self.JTScrollView.effect = JT3DScrollViewEffectDepth;
    [self.view addSubview:self.JTScrollView];
    
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.top.equalTo(64);
        make.height.equalTo(50);
    }];
    
    [self.JTScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom);
        make.bottom.equalTo(self.LTScollView.top);
        make.left.equalTo(80);
        make.right.equalTo(-80);
    }];
    
    [self.LTScollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(100);
    }];
    

    
    [self.LTScollView layoutIfNeeded];
    [self.LTScollView reloadDataWithInitialIndex:0];

    
    
    self.LTScollView.contentInset = UIEdgeInsetsMake(0, 100+100/4.0, 0, 100+100/4.0);
    
    [self.JTScrollView layoutIfNeeded];
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
}

- (void)createCardWithColor
{
    
    CGFloat width = CGRectGetWidth(self.JTScrollView.frame);
    CGFloat height = CGRectGetHeight(self.JTScrollView.frame);
    
    CGFloat x = self.JTScrollView.subviews.count * width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    view.backgroundColor = [UIColor colorWithRed:33/255. green:158/255. blue:238/255. alpha:1.];
    
    view.layer.cornerRadius = 8.;
    
    [self.JTScrollView addSubview:view];
    self.JTScrollView.contentSize = CGSizeMake(x + width, height);
}


# pragma mark - LTInfiniteScrollView dataSource
- (NSInteger)numberOfViews
{
    return 20;
}

- (NSInteger)numberOfVisibleViews
{
    return 3;
}

# pragma mark - LTInfiniteScrollView delegate
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    if (view) {
        ((UILabel *)view).text = [NSString stringWithFormat:@"%ld", index];
        return view;
    }
    
    UILabel *aView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    aView.backgroundColor = [UIColor blackColor];
    aView.backgroundColor = [UIColor darkGrayColor];
    aView.textColor = [UIColor whiteColor];
    aView.textAlignment = NSTextAlignmentCenter;
    aView.text = [NSString stringWithFormat:@"%ld", index];
    return aView;
}

- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    CGFloat scale = 1 - fabs(progress) * 0.15;
    view.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)scrollView:(LTInfiniteScrollView *)scrollView didScrollToIndex:(NSInteger)index{
    NSLog(@"%ld",index);
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
