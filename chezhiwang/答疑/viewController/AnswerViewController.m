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

#import "ComplainChartViewController.h"
#import "ContrastChartViewController.h"

@interface AnswerViewController ()<AnawerToolViewDelegate,LHPageViewcontrollerDelegate>
{
    LHPageViewcontroller *newsView;
    AnawerToolView *toolView;
    
    NSInteger _searchIndex;
}
@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftItem];
    [self createRightItem]; 
    
    
    AnswerListViewController *answer1 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer2 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer3 = [[AnswerListViewController alloc] init];
    AnswerListViewController *answer4 = [[AnswerListViewController alloc] init];
    answer1.type = @"0";
    answer2.type = @"1";
    answer3.type = @"2";
    answer4.type = @"3";
    answer1.cid = self.cid;
    answer2.cid = self.cid;
    answer3.cid = self.cid;
    answer4.cid = self.cid;
    
    newsView = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    newsView.LHDelegate = self;
    newsView.controllers = @[answer1,answer2,answer3,answer4];
    [newsView setViewControllerWithCurrent:0];
    
    
    
    toolView = [[AnawerToolView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    toolView.delegate = self;
    toolView.titleArray = @[@"全部",@"维修保养",@"买车咨询",@"政策法规"];
    toolView.currentIndex = 0;
    [self.view addSubview:toolView];

}
//右侧按钮
-(void)createRightItem{
    
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
        AnswerSearchViewController *search = [[AnswerSearchViewController alloc] init];
        search.numType = 3;
        search.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:search animated:YES];
//    ComplainChartViewController *chart = [[ComplainChartViewController alloc] init];
//    chart.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chart animated:YES];
}

//左侧按钮
-(void)createLeftItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 90, 20) Target:self Action:@selector(leftItemClick) Text:@"我要提问"];
    btn.titleLabel.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 16, 14)];
    imageView.image = [UIImage imageNamed:@"answer_question_left"];
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)leftItemClick{
//    ContrastChartViewController *chart = [[ContrastChartViewController alloc] init];
//    chart.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chart animated:YES];
//    return;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        AskViewController *ask = [[AskViewController alloc] init];
        ask.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ask animated:YES];
    }else{
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypeToAsk;
        my.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:my animated:YES];
    }
}

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
