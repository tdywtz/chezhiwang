//
//  LookCarViewController.m
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LookCarViewController.h"
#import "LHPageViewcontroller.h"
#import "LHToolScrollView.h"
#import "OverviewViewController.h"
#import "ParameterViewController.h"

@interface LookCarViewController ()<LHPageViewcontrollerDelegate,LHToolScrollViewDelegate>
{
    LHPageViewcontroller *pageViewController;
    LHToolScrollView *toolView;
}
@end

@implementation LookCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    toolView = [[LHToolScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    toolView.LHDelegate = self;
    toolView.titles =  @[@"综述",@"车型参数"];
    toolView.current = 0;
    toolView.backgroundColor = [UIColor whiteColor];

    NSMutableArray *array = [[NSMutableArray alloc] init];

    OverviewViewController *vc = [[OverviewViewController alloc] init];
    vc.contentInsets = UIEdgeInsetsMake(64 + 44, 0, 0, 0);
    [array addObject:vc];

    ParameterViewController *parameter = [[ParameterViewController alloc] init];
    parameter.contentInsets = UIEdgeInsetsMake(64 + 44, 0, 0, 0);
    [array addObject:parameter];



    pageViewController = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    pageViewController.LHDelegate = self;
    pageViewController.controllers = array;
    [pageViewController setViewControllerWithCurrent:0];

    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self.view addSubview:toolView];
}

#pragma mark -LHPageViewcontrollerDelegate
//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current{
    toolView.current = current;
}

#pragma mark - LHToolScrollViewDelegate
-(void)clickLeft:(NSInteger)index{

    [pageViewController setViewControllerWithCurrent:index];
}
-(void)clickRight:(NSInteger)index{

    [pageViewController setViewControllerWithCurrent:index];
}

#pragma mark - LHToolScrollViewDelegate
- (void)clickItem:(NSInteger)index{
    toolView.current = index;
    [pageViewController setViewControllerWithCurrent:index];
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
