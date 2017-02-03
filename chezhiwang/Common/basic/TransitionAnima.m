//
//  TransitionAnima.m
//  chezhiwang
//
//  Created by bangong on 16/8/17.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TransitionAnima.h"

@implementation TransitionAnima


+ (CATransition *)transitionAnimationWithType:(TransitionAnimaType)type{
    CATransition *animation = [CATransition animation];
    [animation setType:[self getAnimaWithType:type]];
    [animation setDuration:0.75];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
   // kCATransitionFade
    return animation;
}

+ (NSString *)getAnimaWithType:(TransitionAnimaType)type{
    if (type == TransitionAnimaCube) {
        return @"cube";//立方体

    }else if (type == TransitionAnimaMoveIn){
        return @"moveIn";//新视图移到旧视图上面

    }else if (type == TransitionAnimaReveal){
        return @"reveal";//显露效果(将旧视图移开,显示下面的新视图)

    }else if (type == TransitionAnimaFade){
        return @"fade";//交叉淡化过渡(不支持过渡方向)    (默认为此效果)

    }else if (type == TransitionAnimaPageCurl){
        return @"pageCurl";// 向上翻一页

    }else if (type == TransitionAnimaPageUnCurl){
        return @"pageUnCurl";//向下翻一页
        
    }else if (type == TransitionAnimaSuckEffect){
        return @"suckEffect";//收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)

    }else if (type == TransitionAnimaRippleEffect){
        return @"rippleEffect";//滴水效果,(不支持过渡方向)

    }else if (type == TransitionAnimaOglFlip){
        return @"oglFlip";//上下左右翻转效果
    }else if (type == TransitionAnimaRotate){
        return @"rotate";//旋转效果

    }else if (type == TransitionAnimaPush){
        return @"push";

    }else if (type == TransitionAnimaCameraIrisHollowOpen){
        return @"cameraIrisHollowOpen";//相机镜头打开效果(不支持过渡方向)

    }else if (type == TransitionAnimaCameraIrisHollowClose){
        return @"cameraIrisHollowClose";//相机镜头关上效果(不支持过渡方向)
    }

    return @"push";
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    if (self.operation == UINavigationControllerOperationPush)
    {
        UIViewController *fromVC  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC    = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];


        // Create the mask
        UIImageView *snapshot            = [[UIImageView alloc] initWithFrame:_fromRect];
        snapshot.backgroundColor    = [UIColor whiteColor];
        snapshot.image = _transitionImage;


        toVC.view.frame     = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha     = 0;

        // Add to container view
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapshot];

        // Animate
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:0.75
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             fromVC.view.alpha          = 0;
                             snapshot.layer.mask.bounds = snapshot.bounds;
                             snapshot.frame            = _toRect;
                             toVC.navigationController.toolbar.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             toVC.view.alpha   = 1;
                             [snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }

    else
    {
        UIViewController *fromVC  = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC    = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];


        UIImageView *snapshot          = [[UIImageView alloc] initWithFrame:_fromRect];
        snapshot.backgroundColor    = [UIColor whiteColor];
        snapshot.image = _transitionImage;

        toVC.view.frame         = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha         = 0;
        fromVC.view.alpha       = 0;

        // Add to container view
        [containerView addSubview:toVC.view];
        [containerView addSubview:snapshot];

        // Animate
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             toVC.view.alpha            = 1;
                             snapshot.frame            = _toRect;
                             toVC.navigationController.toolbar.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [snapshot removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
}


@end
