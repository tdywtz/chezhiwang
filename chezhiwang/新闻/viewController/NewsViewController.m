//
//  NewsViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/17.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsInvestigateViewController.h"
#import "NewsListViewController.h"
#import "LHPageViewcontroller.h"
#import "LHToolScrollView.h"
#import "NewsSearchViewController.h"
#import "NewsTestViewController.h"

@interface NewsViewController ()<LHPageViewcontrollerDelegate,LHToolScrollViewDelegate>
{
    LHPageViewcontroller *newsView;
    LHToolScrollView *toolView;

    NSInteger _searchIndex;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    toolView = [[LHToolScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    toolView.LHDelegate = self;
    toolView.titles =  @[@"最新",@"行业",@"新车",@"谍照",@"评测",@"导购",@"召回",
                         @"用车",@"零部件",@"缺陷报道",@"分析报告",@"投诉销量比",
                         @"可靠性调查",@"满意度调查",@"新车调查"];
    toolView.current = 0;
    self.navigationItem.titleView = toolView;
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
     NSArray *typeArray = @[
                            @"0",@"1",@"5",@"14",@"4",@"15",@"2",@"13",
                            @"6",@"9",@"16",@"17",@"18",@"19",@""
                            ];
    for (int i = 0; i < toolView.titles.count-1;  i ++) {
        if ([toolView.titles[i] isEqualToString:@"评测"]) {
            [array addObject:[[NewsTestViewController alloc] init]];
        }else{
            NewsListViewController *vc = [[NewsListViewController alloc] init];
            if (i == 0) {
                vc.tableHeaderViewHave = YES;
            }
            vc.urlString =  [NSString stringWithFormat:[URLFile urlStringForNewsList],typeArray[i],@"&p=%ld&s=%ld"];
            [array addObject:vc];
        }
    }
    NewsInvestigateViewController *investigate = [[NewsInvestigateViewController alloc] init];
    [array addObject:investigate];
    
    newsView = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    newsView.LHDelegate = self;
    newsView.controllers = array;
    [newsView setViewControllerWithCurrent:0];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

#pragma mark - 搜索按钮
-(void)searchClick{
    NSArray *typeArray = @[
                           @"0",@"1",@"5",@"14",@"4",@"15",@"2",@"13",
                           @"6",@"9",@"16",@"17",@"18",@"19",@""
                           ];
    
    NewsSearchViewController *search = [[NewsSearchViewController alloc] init];
    search.style =  typeArray[_searchIndex];
    search.numType = 1;
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -LHPageViewcontrollerDelegate
//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current{
    toolView.current = current;
    _searchIndex = current;
}
//滑动进度
-(void)scrollViewDidScrollLeft:(CGFloat)leftProgress{
    [toolView setProgressLeft:leftProgress];
}
-(void)scrollViewDidScrollRight:(CGFloat)rightProgress{
    [toolView setProgressRight:rightProgress];
}

#pragma mark - LHToolScrollViewDelegate
-(void)clickLeft:(NSInteger)index{
    [newsView setViewControllerWithCurrent:index];
}
-(void)clickRight:(NSInteger)index{
    [newsView setViewControllerWithCurrent:index];
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
