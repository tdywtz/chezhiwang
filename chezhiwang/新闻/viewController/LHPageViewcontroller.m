//
//  PageViewcontroller.m
//  autoService
//
//  Created by bangong on 16/4/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHPageViewcontroller.h"
#import "UIViewController+LH.h"

@interface LHPageViewcontroller ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) CGFloat space;
@property (nonatomic,assign) BOOL beginScrollProgress;
@property (nonatomic,assign) NSInteger toIndex;
@property (nonatomic,assign) NSInteger toLeftAndRgiht;
@property (nonatomic,assign) NSInteger current;

@end

@implementation LHPageViewcontroller

+(instancetype)initWithSpace:(CGFloat)space withParentViewController:(UIViewController *)controller{
    LHPageViewcontroller *page = [[LHPageViewcontroller alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@(space),NSBackgroundColorDocumentAttribute:[UIColor blackColor]}];
  
    page.space = space;
    
    [controller addChildViewController:page];
    page.view.frame = controller.view.frame;
   // page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [controller.view addSubview:page.view];
   
    
    return page;
}

-(instancetype)initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary<NSString *,id> *)options{
    if (self = [super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options]) {
        _current = 0;
        _toLeftAndRgiht = 0;
        self.delegate =self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIView *view in self.view.subviews) {
       // _UIQueuingScrollView
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            ((UIScrollView *)view).scrollsToTop = NO;
        }
    }
}

#pragma mark - sets
-(void)setViewControllerWithCurrent:(NSInteger)current{
    UIPageViewControllerNavigationDirection Direction = UIPageViewControllerNavigationDirectionForward;
    if (current < self.current) {
        Direction = UIPageViewControllerNavigationDirectionReverse;
    }

    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [weakSelf setViewControllers:@[weakSelf.controllers[current
                                                    ]] direction:Direction animated:YES completion:nil];
    });
    //赋值
     self.current = current;
}

-(void)setCurrent:(NSInteger)current{
    
     UIViewController *old = self.controllers[_current];
     UIViewController *new = self.controllers[current];
    [old viewDisappear];
    [new viewApper];

    _current = current;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_current > 0 && _current < self.controllers.count-1) {
        self.beginScrollProgress = YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.LHDelegate respondsToSelector:@selector(didScroll:)]) {
        [self.LHDelegate didScroll:scrollView];
    }

    CGFloat width = self.view.frame.size.width;
    CGFloat contentOffX = scrollView.contentOffset.x;
   // NSLog(@"%f",scrollView.contentOffset.x);
    //CGFloat mainProgress = contentOffX
 
    if (self.beginScrollProgress && self.controllers.count) {

            if (scrollView.contentOffset.x <= width && _current > 0) {

                if ([self.LHDelegate respondsToSelector:@selector(scrollViewDidScrollLeft:)]) {
                    [self.LHDelegate scrollViewDidScrollLeft:(1-contentOffX/width)];
                }
            }else if (scrollView.contentOffset.x >= width+self.space*2 && _current < self.controllers.count-1){

                if ([self.LHDelegate respondsToSelector:@selector(scrollViewDidScrollRight:)]) {
                    [self.LHDelegate scrollViewDidScrollRight:(contentOffX-width-self.space*2)/width];
                }
            }
    }
    
    if (scrollView.dragging) {
        
        if (scrollView.contentOffset.x < 0 ||  scrollView.contentOffset.x > (width+self.space)*2) {
            if ([self.LHDelegate respondsToSelector:@selector(didFinishAnimatingApper:)]) {
                [self.LHDelegate didFinishAnimatingApper:self.toIndex];
            }
     
             self.current = self.toIndex;
        }
    }
    
    if (scrollView.contentOffset.x < 10) {
        self.toLeftAndRgiht = -1;
    }else if ( scrollView.contentOffset.x > ((width+self.space)*2-10)){
        self.toLeftAndRgiht = 1;
    }else{
        self.toLeftAndRgiht = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.LHDelegate respondsToSelector:@selector(DidEndDecelerating:)]) {
        [self.LHDelegate DidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([self.LHDelegate respondsToSelector:@selector(DidEndScrollingAnimation:)]) {
        [self.LHDelegate DidEndScrollingAnimation:scrollView];
    }
}

#pragma mark - UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    NSInteger index = [self.controllers indexOfObject:viewController];

    if (index+1 < self.controllers.count) {
        
        return self.controllers[index+1];
    }

     self.beginScrollProgress = NO;
    return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    NSInteger index = [self.controllers indexOfObject:viewController];
    
    if (index-1 >= 0) {
     
        return self.controllers[index-1];
    }

     self.beginScrollProgress = NO;
    return nil;
}

//-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 10;
//}
//
//-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//    return 0;
//}

#pragma mark - UIPageViewControllerDelegate
// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0){
    self.beginScrollProgress = YES;
    UIViewController *vc = pendingViewControllers[0];
    NSInteger index = [self.controllers indexOfObject:vc];
    self.toIndex = index;
}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
   
    self.beginScrollProgress = NO;

    if (self.toLeftAndRgiht == 1 || self.toLeftAndRgiht == -1) {
        if ([self.LHDelegate respondsToSelector:@selector(didFinishAnimatingApper:)]) {
            [self.LHDelegate didFinishAnimatingApper:self.toIndex];
        }
         self.current = self.toIndex;
    }else{
        if ([self.LHDelegate respondsToSelector:@selector(didFinishAnimatingApper:)]) {
            [self.LHDelegate didFinishAnimatingApper:self.current];
        }
    }
}



//#pragma mark LHToolScrollViewDelegate
//-(void)clickLeft:(NSInteger)index{
//    [self setViewControllers:@[self.controllers[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
//}
//
//-(void)clickRight:(NSInteger)index{
//    [self setViewControllers:@[self.controllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//
//}


// Delegate may specify a different spine location for after the interface orientation change. Only sent for transition style 'UIPageViewControllerTransitionStylePageCurl'.
// Delegate may set new view controllers or update double-sided state within this method's implementation as well.
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation{
//    
//}
//
//- (UIInterfaceOrientationMask)pageViewControllerSupportedInterfaceOrientations:(UIPageViewController *)pageViewController{
//    
//}
//- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController {
//     
//}



@end
