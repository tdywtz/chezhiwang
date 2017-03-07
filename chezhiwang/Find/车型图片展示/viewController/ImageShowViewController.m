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
#import "BasicNavigationController.h"

@interface ImageShowViewController ()<LTInfiniteScrollViewDataSource,LTInfiniteScrollViewDelegate,LHPageViewDataSource,LHPageViewDelegate>
{
    LHPageView *_pageView;
    NSMutableArray *_viewArray;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) LTInfiniteScrollView *LTScollView;

@end

@implementation ImageShowViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        // self.transitionAnimaType = TransitionAnimaRippleEffect;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    _viewArray = [[NSMutableArray alloc] init];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    _pageView = [[LHPageView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 300) space:10];
    _pageView.delegate = self;
    _pageView.dataSource = self;

    self.LTScollView = [[LTInfiniteScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT-100, WIDTH, 100)];
    self.LTScollView.verticalScroll = NO;
    self.LTScollView.delegate = self;
    self.LTScollView.dataSource = self;
    self.LTScollView.maxScrollDistance = 2;
    //self.LTScollView.contentInset = UIEdgeInsetsMake(0, 100+100/4.0, 0, 100+100/4.0);

    [self.view addSubview:self.titleLabel];
    [self.view addSubview:_pageView];
    [self.view addSubview:self.LTScollView];
    

    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(64+10);
        make.height.equalTo(50);
    }];

    [_pageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.titleLabel.bottom).offset(20);
        make.bottom.equalTo(self.LTScollView.top).offset(-20);
    }];

    [self.LTScollView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(-30);
        make.height.equalTo(100);
    }];

    [self createRightItem];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [((BasicNavigationController *)self.navigationController) bengingAlph];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.LTScollView removeFromSuperview];
     [((BasicNavigationController *)self.navigationController) endAlph];
}

- (void)createRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"图片下载"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)rightItemClick{
    UIImage *image = ((UIImageView *)_pageView.currentView).image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"已存入手机相册"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];

    }else{

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"保存失败"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }

}


- (void)loadData{
    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@&mid=%@",[URLFile urlString_modelPlicList],self.mid];
    [HttpRequest GET:url success:^(id responseObject) {
        weakSelf.imageUrlArray = responseObject[@"rel"];
        weakSelf.titleLabel.text = responseObject[@"modelname"];
        [weakSelf setImage];
    } failure:^(NSError *error) {

    }];
}

- (void)setImage{
    if (self.imageUrlArray.count == 0) {
        return;
    }

    [self.LTScollView layoutIfNeeded];
    [self.LTScollView reloadDataWithInitialIndex:0];
     [self.LTScollView scrollToIndex:self.pageIndex animated:NO];
    self.LTScollView.contentInset = UIEdgeInsetsMake(0, 100+100/4.0, 0,125);

    for (int i = 0; i < self.imageUrlArray.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor clearColor];
        [_viewArray addObject:imageView];
    }


    [_pageView layoutIfNeeded];
    if (_viewArray.count > _pageIndex){
        UIImageView *imageView = _viewArray[_pageIndex];
        NSURL *url = [NSURL URLWithString:self.imageUrlArray[_pageIndex][@"url"]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];

        [_pageView setView:imageView direction:LHPageViewDirectionForward anime:NO];
    }
    
    [self setTitleLabelTextWithIndex:_pageIndex];
}


- (void)setTitleLabelTextWithIndex:(NSInteger)index{
//    NSDictionary *dict = self.imageUrlArray[index];
//    _titleLabel.text = dict[@"image"];
    self.title = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageUrlArray.count];
}

# pragma mark - LTInfiniteScrollViewDataSource
- (NSInteger)numberOfViews
{
    return _imageUrlArray.count;
}

- (NSInteger)numberOfVisibleViews
{
    return 3;
}

- (UIView *)viewAtIndex:(NSInteger)index reusingView:(UIView *)view;
{

    if (view) {
        NSDictionary *dict = self.imageUrlArray[index];
        [((UIImageView *)view) sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        return view;
    }
    CGFloat width = WIDTH/3;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width*(145.0/217.0))];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSDictionary *dict = self.imageUrlArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"url"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    return imageView;
}

#pragma mark - LTInfiniteScrollViewDelegate
- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction
{
    CGFloat scale = 1 - fabs(progress) * 0.18;
    view.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)scrollView:(LTInfiniteScrollView *)scrollView didScrollToIndex:(NSInteger)index{

    if (index == _pageIndex) {
        return;
    }
    if (index > _viewArray.count-1) {
        return;
    }
    UIImageView *imageView = (UIImageView *)_viewArray[index];
    NSURL *url = [NSURL URLWithString:self.imageUrlArray[index][@"url"]];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    if (index > _pageIndex) {
     [_pageView setView:imageView direction:LHPageViewDirectionReverse anime:YES];
    }else if (index < _pageIndex){
     [_pageView setView:imageView direction:LHPageViewDirectionForward anime:YES];
    }
    _pageIndex = index;
    [self setTitleLabelTextWithIndex:index];
}


#pragma mark - LHPageViewDataSource
- (UIView *)pageView:(LHPageView *)pageView viewBeforeView:(UIView *)view{
    NSInteger index = [_viewArray indexOfObject:view];
    index--;
    if (index >= 0 && index < _viewArray.count) {
        UIImageView *imageView = (UIImageView *)_viewArray[index];
        NSURL *url = [NSURL URLWithString:self.imageUrlArray[index][@"url"]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];

        return imageView;
    }
    return nil;
}
- (UIView *)pageView:(LHPageView *)pageViewController viewAfterView:(UIView *)view{
    NSInteger index = [_viewArray indexOfObject:view];
    index++;
    if (index < _viewArray.count) {
        UIImageView *imageView = _viewArray[index];
        NSURL *url = [NSURL URLWithString:self.imageUrlArray[index][@"url"]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];

        return imageView;
    }
    return nil;
}
#pragma mark - LHPageViewDelegate
- (void)pageView:(LHPageView *)pageView didFinishAnimating:(BOOL)finished previousView:(UIView *)previousView transitionCompleted:(BOOL)completed{
    NSInteger index = [_viewArray indexOfObject:previousView];
    if (index != NSNotFound) {
        [self.LTScollView scrollToIndex:index animated:YES];
        [self setTitleLabelTextWithIndex:index];
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
