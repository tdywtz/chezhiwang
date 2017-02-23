//
//  TransitionAnima.h
//  chezhiwang
//
//  Created by bangong on 16/8/17.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransitionAnimaType) {
    TransitionAnimaNomal,
    TransitionAnimaCube,//立方体
    TransitionAnimaMoveIn,//新视图移到旧视图上面
    TransitionAnimaReveal,//显露效果(将旧视图移开,显示下面的新视图)
    TransitionAnimaFade,//交叉淡化过渡(不支持过渡方向)    (默认为此效果)
    TransitionAnimaPageCurl,// 向上翻一页
    TransitionAnimaPageUnCurl,//向下翻一页
    TransitionAnimaSuckEffect,//收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
    TransitionAnimaRippleEffect,//滴水效果,(不支持过渡方向)
    TransitionAnimaOglFlip,//上下左右翻转效果
    TransitionAnimaRotate,//旋转效果
    TransitionAnimaPush,//
    TransitionAnimaCameraIrisHollowOpen,//相机镜头打开效果(不支持过渡方向)
    TransitionAnimaCameraIrisHollowClose//相机镜头关上效果(不支持过渡方向)
};

@interface TransitionAnima : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, assign) CGRect toRect;
@property (nonatomic, strong) UIImage *transitionImage;

+ (CATransition *)transitionAnimationWithType:(TransitionAnimaType)type;

@end
