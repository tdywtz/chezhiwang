//
//  ImageShowViewController.m
//  chezhiwang
//
//  Created by bangong on 16/6/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ImageShowViewController.h"
#import "LTInfiniteScrollView.h"
#import "LHPageView.h"

@interface ImageShowViewController ()<LTInfiniteScrollViewDataSource,LTInfiniteScrollViewDelegate,LHPageViewDataSource,LHPageViewDelegate>
{
    LHPageView *_pageView;
    NSMutableArray *_viewArray;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) LTInfiniteScrollView *LTScollView;

@end

@implementation ImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _viewArray = [[NSMutableArray alloc] init];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    _pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 300) space:10];
    _pageView.delegate = self;
    _pageView.dataSource = self;

    self.LTScollView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectZero];
    self.LTScollView.verticalScroll = NO;
    self.LTScollView.delegate = self;
    self.LTScollView.dataSource = self;
    self.LTScollView.maxScrollDistance = 13;

     [self.view addSubview:self.titleLabel];
    [self.view addSubview:_pageView];
    [self.view addSubview:self.LTScollView];
    

    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(0);
        make.top.equalTo(64);
        make.height.equalTo(50);
    }];

    [_pageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.titleLabel.bottom);
        make.bottom.equalTo(self.LTScollView.top);
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
    [self.LTScollView scrollToIndex:self.pageIndex animated:NO];


    for (int i = 0; i < self.imageUrlArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSURL *url = [NSURL URLWithString:self.imageUrlArray[i][@"image"]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        [_viewArray addObject:imageView];
    }
    [_pageView layoutIfNeeded];
     _pageView.backgroundColor = [UIColor blackColor];
    [_pageView setView:_viewArray[_pageIndex] direction:LHPageViewDirectionForward anime:NO];
    [self setTitleLabelTextWithIndex:_pageIndex];
}

- (void)setTitleLabelTextWithIndex:(NSInteger)index{
    NSDictionary *dict = self.imageUrlArray[index];
    _titleLabel.text = dict[@"image"];
    NSLog(@"%@",dict);
}

# pragma mark - LTInfiniteScrollView dataSource
- (NSInteger)numberOfViews
{
    return _imageUrlArray.count;
}

- (NSInteger)numberOfVisibleViews
{
    return 3;
}

# pragma mark - LTInfiniteScrollView delegate
- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{
    if (view) {
        return view;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSDictionary *dict = self.imageUrlArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    return imageView;
}

- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    CGFloat scale = 1 - fabs(progress) * 0.15;
    view.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)scrollView:(LTInfiniteScrollView *)scrollView didScrollToIndex:(NSInteger)index{

    if (index > _pageIndex) {
     [_pageView setView:_viewArray[index] direction:LHPageViewDirectionReverse anime:YES];
    }else if (index < _pageIndex){
     [_pageView setView:_viewArray[index] direction:LHPageViewDirectionForward anime:YES];
    }

    _pageIndex = index;
    [self setTitleLabelTextWithIndex:index];
}


#pragma mark - LHPageViewDataSource
- (UIView *)pageView:(LHPageView *)pageView viewBeforeView:(UIView *)view{
    NSInteger index = [_viewArray indexOfObject:view];
    index--;
    if (index >= 0) {
        return _viewArray[index];
    }
    return nil;
}
- (UIView *)pageView:(LHPageView *)pageViewController viewAfterView:(UIView *)view{
    NSInteger index = [_viewArray indexOfObject:view];
    index++;
    if (index < _viewArray.count) {
        return _viewArray[index];
    }
    return nil;
}
#pragma mark - LHPageViewDelegate
- (void)pageView:(LHPageView *)pageView didFinishAnimating:(BOOL)finished previousView:(UIView *)previousView transitionCompleted:(BOOL)completed{
    NSInteger index = [_viewArray indexOfObject:previousView];
     [self.LTScollView scrollToIndex:index animated:YES];
     [self setTitleLabelTextWithIndex:index];
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
