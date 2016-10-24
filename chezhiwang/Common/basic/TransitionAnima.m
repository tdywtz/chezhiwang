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

@end
