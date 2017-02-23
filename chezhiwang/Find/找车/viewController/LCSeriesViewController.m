//
//  LCSeriesViewController.m
//  chezhiwang
//
//  Created by bangong on 17/1/12.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LCSeriesViewController.h"

#import "LHPageViewcontroller.h"
#import "LHToolScrollView.h"

#import "OverviewViewController.h"
#import "ParameterViewController.h"
#import "LCComplainListViewController.h"
#import "LCReputationViewController.h"
#import "AnswerViewController.h"
#import "NewsListViewController.h"
#import "ForumClassifyListViewController.h"
#import "NewsDetailViewController.h"

#import "ComplainViewController.h"
#import "AskViewController.h"
#import "CZWShareViewController.h"
#import "LoginViewController.h"

@interface LCSeriesViewController ()<LHPageViewcontrollerDelegate,LHToolScrollViewDelegate>
{
    LHPageViewcontroller *pageViewController;
    LHToolScrollView *toolView;
}

@end

@implementation LCSeriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    toolView = [[LHToolScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    toolView.LHDelegate = self;
    toolView.titles =  @[@"综述",@"车型参数",@"投诉",@"口碑",@"答疑",@"新闻",@"评测",@"论坛"];
    toolView.current = 0;
    toolView.backgroundColor = [UIColor whiteColor];

    pageViewController = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    pageViewController.LHDelegate = self;

    NSMutableArray *array = [[NSMutableArray alloc] init];
    UIEdgeInsets insets = UIEdgeInsetsMake(64 + 44, 0, 0, 0);

    OverviewViewController *vc = [[OverviewViewController alloc] init];
    vc.contentInsets = insets;
    vc.seriesID = self.seriesID;
    __weak __typeof(self)_self = self;
    __weak __typeof(toolView) weakToolView = toolView;
    __weak __typeof(pageViewController) weakPageViewController = pageViewController;
    [vc setMoreClick:^(NSInteger idx) {
        NSInteger index = 0;
        if (idx == 0) {
            index = 5;
        }else if(idx == 1){
           index = 2;
        }else{
           index = 3;
        }
        weakToolView.current = index;
        [weakPageViewController setViewControllerWithCurrent:index];
        [_self setRightItem:index];
    }];
    [array addObject:vc];

    ParameterViewController *parameter = [[ParameterViewController alloc] init];
    parameter.contentInsets = insets;
    parameter.seriesID = self.seriesID;
    [array addObject:parameter];


    LCComplainListViewController *complain = [[LCComplainListViewController alloc] init];
    complain.contentInsets = insets;
    complain.sid = self.seriesID;
    [array addObject:complain];

    LCReputationViewController *reputation = [[LCReputationViewController alloc] init];
    reputation.contentInsets = insets;
    reputation.sid = self.seriesID;
    [array addObject:reputation];
    

    AnswerViewController *answer = [[AnswerViewController alloc] init];
    answer.contentInsets = insets;
    answer.sid = self.seriesID;
    [array addObject:answer];

    NSString *parameterText = [URLFile url_newslistWithStyle:nil title:nil sid:_seriesID];
    NSString *url =  [NSString stringWithFormat:@"%@%@",parameterText,@"&p=%ld&s=%ld"];
    NewsListViewController *news = [[NewsListViewController alloc] init];
    news.urlString = url;
    news.contentInsets = insets;
    [array addObject:news];

    NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
    detail.sid = _seriesID;
    detail.contentInsets = insets;
    [array addObject:detail];

    ForumClassifyListViewController *forum = [[ForumClassifyListViewController alloc] init];
    forum.sid = _seriesID;
    forum.forumType = forumClassifyBrand;
    forum.contentInsets = insets;
    [array addObject:forum];


    pageViewController.controllers = array;
    [pageViewController setViewControllerWithCurrent:0];

    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [self.view addSubview:toolView];

    [self loadDataScore];
}

- (void)loadDataScore{
    __weak __typeof(self)_self = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:[URLFile urlString_s_index],_seriesID];
    [HttpRequest GET:url success:^(id responseObject) {


        BOOL pc =  [responseObject[@"operation"][@"pc"] boolValue];
        if (pc == NO) {
            [self deleteText];
        }
        [MBProgressHUD hideHUDForView:_self.view animated:YES];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_self.view animated:YES];
    }];
}


- (void)deleteText{


    NSMutableArray *titles = [toolView.titles mutableCopy];
    [titles removeObjectAtIndex:titles.count - 2];
    toolView.titles = titles;
    toolView.current = 0;

    NSMutableArray *marr = [pageViewController.controllers mutableCopy];
    [marr removeObjectAtIndex:marr.count - 2];
    pageViewController.controllers = marr;
    [pageViewController setViewControllerWithCurrent:0];
}


- (void)setRightItem:(NSInteger)index{

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + index;
        NSString *imageName;
        if (index == 2){
            imageName = @"auto_投诉列表_投诉";
        }else if (index == 4){
            imageName = @"answer_question_right";
        }else if (index == 6 && pageViewController.controllers.count == 8){
            imageName = @"comment_转发";
        }else{
            self.navigationItem.rightBarButtonItem = nil;
            return;
        }
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 20, 20);
        [btn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}

- (void)rightItemClick:(UIButton *)btn{
    if (btn.tag == 102) {
        if ([CZWManager manager].isLogin) {
            ComplainViewController *complain = [[ComplainViewController alloc] init];
            complain.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:complain animated:YES];
        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
    }else if (btn.tag == 104){
        if ([CZWManager manager].isLogin) {
            AskViewController *ask = [[AskViewController alloc] init];
            ask.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ask animated:YES];
        }else{

            [self presentViewController:[LoginViewController instance] animated:YES completion:nil];
        }
    }else if (btn.tag == 106){
        NewsDetailViewController *detail = pageViewController.controllers[6];
        if ([detail respondsToSelector:@selector(shareWeb)]) {
            [detail shareWeb];
        }
    }
}

#pragma mark -LHPageViewcontrollerDelegate
//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current{
    toolView.current = current;
    [self setRightItem:current];
}

#pragma mark - LHToolScrollViewDelegate
-(void)clickLeft:(NSInteger)index{
    [self setRightItem:index];
    [pageViewController setViewControllerWithCurrent:index];
}
-(void)clickRight:(NSInteger)index{
    [self setRightItem:index];
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
