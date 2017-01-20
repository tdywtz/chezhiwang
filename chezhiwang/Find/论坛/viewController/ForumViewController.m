//
//  ForumViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumViewController.h"
#import "LHPageViewcontroller.h"
#import "ForumListViewController.h"
#import "ForumCatalogueViewController.h"
#import "LHSegmentView.h"

@interface ForumViewController ()<LHPageViewcontrollerDelegate>
{
    LHPageViewcontroller *pageViewController;
    LHSegmentView *segmentView;
    NSInteger _current;
}
@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    pageViewController = [LHPageViewcontroller initWithSpace:0 withParentViewController:self];
    pageViewController.LHDelegate = self;
    pageViewController.controllers = @[[[ForumListViewController alloc] init],[[ForumCatalogueViewController alloc] init]];
    [pageViewController setViewControllerWithCurrent:0];
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];


    segmentView = [LHSegmentView initWithFrame:CGRectMake(0, 0, 300, 30) titles:@[@"帖子列表",@"论坛分类"] textColor:colorLightBlue highlightColor:[UIColor whiteColor]];
    segmentView.layer.borderColor = [UIColor whiteColor].CGColor;
    segmentView.layer.borderWidth = 1;
    segmentView.layer.cornerRadius = 15;
    segmentView.layer.masksToBounds = YES;
    segmentView.lh_width = segmentView.contentSize.width;
    self.navigationItem.titleView = segmentView;

    __weak __typeof(pageViewController) weakVC = pageViewController;
    segmentView.setScrollClosure = ^(NSInteger index) {
        [weakVC setViewControllerWithCurrent:index];
        _current = index;
    };

    [segmentView scrollTo:0 animer:NO];
}

#pragma mark -LHPageViewcontrollerDelegate
//变化当前停留在窗口的视图
-(void)didFinishAnimatingApper:(NSInteger)current{
    [segmentView scrollTo:current animer:NO];
}

//滑动进度
-(void)scrollViewDidScrollLeft:(CGFloat)leftProgress{
    [segmentView resetToIndex:-leftProgress];
    [segmentView progress:-leftProgress];
}

-(void)scrollViewDidScrollRight:(CGFloat)rightProgress{

    [segmentView resetToIndex:rightProgress];
    [segmentView progress:rightProgress];
}

- (void)didScroll:(UIScrollView *)scrollView{
    if (scrollView.dragging) {
        return;
    }
    CGFloat offX = scrollView.contentOffset.x;

    if (offX < WIDTH && offX >= 0) {
        [segmentView progress:-fabs((offX - WIDTH)/WIDTH)];
    }else if (offX > WIDTH && WIDTH <= WIDTH*2){
        [segmentView progress:fabs((offX - WIDTH)/WIDTH)];
    }
}

- (void)DidEndScrollingAnimation:(UIScrollView *)scrollView{
    [segmentView scrollTo:_current animer:NO];
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
