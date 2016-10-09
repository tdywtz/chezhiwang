//
//  NewsViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/17.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsViewController.h"
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
                            @"6",@"9",@"16",@"17",@"18",@"19"
                            ];
    for (int i = 0; i < toolView.titles.count;  i ++) {
        if ([toolView.titles[i] isEqualToString:@"评测"]) {
            [array addObject:[[NewsTestViewController alloc] init]];
        }else{
            NewsListViewController *vc = [[NewsListViewController alloc] init];
            vc.urlString =  [NSString stringWithFormat:[URLFile urlStringForNewsList],typeArray[i],@"&p=%ld&s=%ld"];
            [array addObject:vc];
        }
    }


file:///Users/bangong/Desktop/%E9%A1%B9%E7%9B%AE%E7%BB%84/%E8%BD%A6%E8%B4%A8%E7%BD%91/chezhiwang/chezhiwang/%E6%96%B0%E9%97%BB/view/HomepageSectionFootView.h: warning: Missing file: /Users/bangong/Desktop/项目组/车质网/chezhiwang/chezhiwang/新闻/view/HomepageSectionFootView.h is missing from working copy







    newsView = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    newsView.LHDelegate = self;
    newsView.controllers = array;
    [newsView setViewControllerWithCurrent:0];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];



    LHLabel *label = [[LHLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    label.preferredMaxLayoutWidth = 200;
    [self.view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(CGPointZero);
    }];
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
    _searchIndex = index;
    [newsView setViewControllerWithCurrent:index];
}
-(void)clickRight:(NSInteger)index{
    _searchIndex = index;
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
