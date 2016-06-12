//
//  ContrastChartViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/25.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ContrastChartViewController.h"
#import "ContrasChartCollectionView.h"

@interface ContrastChartViewController ()<UIScrollViewDelegate,ContrasChartCollectionViewScrollDelegate>
{
    UIScrollView *_scrollView;
}
@end

@implementation ContrastChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftItemBack];
   ;
  dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self createChart];
  });
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:0] forKey:@"forCellWithReuseIdentifier"];
}

-(void)createChart{
    //可左右滑动tableView父视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100, 0, WIDTH-100, HEIGHT)];
    // _scrollView.contentSize = CGSizeMake((_arrX.count-1)*130, _arrY.count*50);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    //设置边框，形成表格
//    _scrollView.layer.borderWidth = .5f;
//    _scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_scrollView];
    
    //第一列表
    ContrasChartCollectionView *collectionView = [ContrasChartCollectionView initWithFrame:CGRectMake(0, 64, 100, HEIGHT-64)];
    collectionView.ChartDelegate = self;
    collectionView.clipsToBounds = NO;
    [self.view addSubview:collectionView];

    for (int i = 0; i < 20; i++)
    {
        ContrasChartCollectionView *tableView = [ContrasChartCollectionView initWithFrame:CGRectMake(80*i, 0, 80, HEIGHT-64)];
        tableView.ChartDelegate = self;
        [_scrollView addSubview:tableView];
    }
    _scrollView.contentSize = CGSizeMake(80*20, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollDelegate
-(void)scrollContentOffSet:(CGPoint)contentOffSet
{

    for (UIView *subView in _scrollView.subviews)
    {
        if ([subView isKindOfClass:[ContrasChartCollectionView class]])
        {
            [((ContrasChartCollectionView *)subView) setScrollContentOffSet:contentOffSet];
        }
    }
    
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[ContrasChartCollectionView class]])
        {
            [((ContrasChartCollectionView *)subView) setScrollContentOffSet:contentOffSet];
        }
    }
}

#pragma mark - UIScrollViewDelegate
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint p = scrollView.contentOffset;
//  //  NSLog(@"%@",NSStringFromCGPoint(p));
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
