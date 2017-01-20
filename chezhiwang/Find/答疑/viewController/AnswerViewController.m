//
//  AnswerViewController.m
//  auto
//
//  Created by bangong on 15/6/1.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerListViewController.h"
#include "LHPageViewcontroller.h"
#include "AnawerToolView.h"

#import "AskViewController.h"
#import "AnswerSearchViewController.h"
#import "LoginViewController.h"

@interface AnswerViewController ()<AnawerToolViewDelegate,LHPageViewcontrollerDelegate>
{
    LHPageViewcontroller *newsView;
    AnawerToolView *toolView;
    
    NSInteger _searchIndex;
}
@end

@implementation AnswerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"答疑";
   // [self createLeftItem];
    [self createRightItem]; 
    
    AnswerListViewController *answer1 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer2 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer3 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer4 = [[AnswerListViewController alloc] init];
    answer1.type = @"0";
    answer2.type = @"1";
    answer3.type = @"2";
    answer4.type = @"3";
    answer1.sid = self.sid;
    answer2.sid = self.sid;
    answer3.sid = self.sid;
    answer4.sid = self.sid;

    CGFloat top = _contentInsets.top;
    answer1.contentInsets = UIEdgeInsetsMake(40+top, 0, 0, 0);
    answer2.contentInsets = UIEdgeInsetsMake(40+top, 0, 0, 0);
    answer3.contentInsets = UIEdgeInsetsMake(40+top, 0, 0, 0);
    answer4.contentInsets = UIEdgeInsetsMake(40+top, 0, 0, 0);
    
    newsView = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    newsView.LHDelegate = self;
    newsView.controllers = @[answer1,answer2,answer3,answer4];
    [newsView setViewControllerWithCurrent:0];
    
    
    
    toolView = [[AnawerToolView alloc] initWithFrame:CGRectMake(0, top, WIDTH, 40)];
    toolView.delegate = self;
    toolView.titleArray = @[@"全部",@"维修保养",@"买车咨询",@"政策法规"];
    toolView.currentIndex = 0;
    toolView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolView];

}
//右侧按钮
-(void)createRightItem{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"auto_common_search"] forState:UIControlStateNormal];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake(0, 0, 30, 20);
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *askButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [askButton setImage:[UIImage imageNamed:@"answer_question_right"] forState:UIControlStateNormal];
    askButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    askButton.frame = CGRectMake(0, 0, 30, 20);
    [askButton addTarget:self action:@selector(askButtonClick) forControlEvents:UIControlEventTouchUpInside];


    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    UIBarButtonItem *complainItem = [[UIBarButtonItem alloc] initWithCustomView:askButton];
    self.navigationItem.rightBarButtonItems = @[searchItem,complainItem];
}

-(void)askButtonClick{
    if ([CZWManager manager].isLogin) {
        AskViewController *ask = [[AskViewController alloc] init];
        ask.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ask animated:YES];
    }else{

        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
    }
}

- (void)searchButtonClick{
            AnswerSearchViewController *search = [[AnswerSearchViewController alloc] init];
            search.numType = 3;
            search.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:search animated:YES];

}

//左侧按钮
//-(void)createLeftItem{
//    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(leftItemClick) Text:@"我要提问"];
//    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 16, 14)];
//    imageView.image = [UIImage imageNamed:@"answer_question_left"];
//    [btn addSubview:imageView];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.leftBarButtonItem = item;
//}

//-(void)leftItemClick{
//
//    if ([CZWManager manager].isLogin) {
//        AskViewController *ask = [[AskViewController alloc] init];
//        ask.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:ask animated:YES];
//    }else{
//        
//        [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -LHPageViewcontrollerDelegate
//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current{
    toolView.currentIndex = current;
    _searchIndex = current;
}

#pragma mark - AnawerToolViewDelegate
//**点击按钮*/
-(void)selectedButton:(NSInteger)index{
    [newsView setViewControllerWithCurrent:index];
}


@end
