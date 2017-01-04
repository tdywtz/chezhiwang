//
//  BasicViewController.m
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@implementation BasicBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"auto_backgruondView_暂无"];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = colorBlack;

        [self addSubview:_imageView];
        [self addSubview:_contentLabel];

        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-20);
        }];

        [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.width.lessThanOrEqualTo(WIDTH - 30);
            make.top.equalTo(_imageView.bottom).offset(20);
        }];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return  nil;
}

@end

#pragma mark - BasicViewController
@interface BasicViewController ()

@end

@implementation BasicViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController) {
        [self.navigationController setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    if (self.navigationController.viewControllers.count > 1) {
        [self createLeftItemBack];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [MobClick endLogPageView:@"PageOne"];
}

#pragma mark - 注册通知
-(void)keyboardNotificaion{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{

}

-(void)keyboardHide:(NSNotification *)notification
{

}

-(void)createLeftItemBack{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 40);
    UIImage *leftImage = [UIImage imageNamed:@"bar_btn_icon_returntext"];
    [button setImage:leftImage forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [button addTarget:self action:@selector(leftItemBackClick) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

-(void)leftItemBackClick{
    if (self.navigationController.viewControllers.count > 1) {
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [self.scrollView addSubview:_contentView];
        [_contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
            make.width.equalTo(WIDTH);
        }];
    }
    return _contentView;
}

- (BasicBackgroundView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[BasicBackgroundView alloc] initWithFrame:self.view.frame];
        _backgroundView.hidden = YES;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
