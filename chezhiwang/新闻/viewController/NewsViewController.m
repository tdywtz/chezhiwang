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
#import "LHNewsChooseView.h"

@interface NewsViewController ()<LHPageViewcontrollerDelegate,LHToolScrollViewDelegate,LHNewsChooseViewDelegate>
{
    LHPageViewcontroller *newsView;
    LHToolScrollView *toolView;
    LHNewsChooseView *chooseView;
    NSInteger _searchIndex;
}
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新闻";
   
    toolView = [[LHToolScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 44)];
    toolView.LHDelegate = self;
    toolView.titles =  @[@"全部",@"行业",@"新车",@"谍照",@"评测",@"导购",@"召回",
                         @"用车",@"零部件",@"缺陷报道",@"分析报告",@"投诉销量比",
                         @"可靠性调查",@"满意度调查"];
    toolView.current = 0;
    toolView.backgroundColor = [UIColor whiteColor];


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


    newsView = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    newsView.LHDelegate = self;
    newsView.controllers = array;
    [newsView setViewControllerWithCurrent:0];
    [self.view addSubview:newsView.view];
    [self addChildViewController:newsView];

    [self.view addSubview:toolView];


    chooseView = [[LHNewsChooseView alloc] initWithFrame:CGRectZero];
    chooseView.delegate = self;
    [self.view addSubview:chooseView];

    [chooseView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];


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
//-(void)scrollViewDidScrollLeft:(CGFloat)leftProgress{
//    [toolView setProgressLeft:leftProgress];
//}
//-(void)scrollViewDidScrollRight:(CGFloat)rightProgress{
//    [toolView setProgressRight:rightProgress];
//}

#pragma mark - LHToolScrollViewDelegate
-(void)clickLeft:(NSInteger)index{
    _searchIndex = index;
    [newsView setViewControllerWithCurrent:index];
}
-(void)clickRight:(NSInteger)index{
    _searchIndex = index;
    [newsView setViewControllerWithCurrent:index];
}

- (void)chooseButtonClick:(BOOL)open{

    [chooseView show];

}

#pragma mark - LHToolScrollViewDelegate
- (void)clickItem:(NSInteger)index{
     toolView.current = index;
     [newsView setViewControllerWithCurrent:index];
     [chooseView dismiss];
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
