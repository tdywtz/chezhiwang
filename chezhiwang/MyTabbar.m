
//
//  MyTabbar.m
//  chezhiwang
//
//  Created by bangong on 16/6/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyTabbar.h"

@interface MyTabbar ()

@end
@implementation MyTabbar
{
    UIButton *button;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        //隐藏阴影线
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        
        button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(100, -100, 100, 200);
        [self addSubview:button];
        button.backgroundColor = [UIColor redColor];
       // [button addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
        [self makeUI];
    }
    return self;
}
-(void)d2{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //CGSize size = self.frame.size;
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 10, 10);
    CGPathAddLineToPoint(path, NULL, 100, 0.0);
    CGPathAddLineToPoint(path, NULL, 150, 300);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}

-(void)button{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:view];
    view.backgroundColor = [UIColor orangeColor];



    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = 2;
    springAnimation.springBounciness = 10;
    
    springAnimation.dynamicsFriction = 0.4;
    springAnimation.springSpeed = 2;
    springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(100, -300, 50, 50)];
    springAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 5, 5)];
    
    [view pop_removeAnimationForKey:@"POPSpringAnimationKey"];
    [view pop_addAnimation:springAnimation forKey:@"POPSpringAnimationKey"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        POPBasicAnimation *textColorSpringAnimation = [POPBasicAnimation easeInAnimation];
        textColorSpringAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
        textColorSpringAnimation.removedOnCompletion = YES;
        textColorSpringAnimation.beginTime = 2;

        textColorSpringAnimation.toValue = [UIColor whiteColor];
        textColorSpringAnimation.fromValue = [UIColor redColor];
        
        [view pop_removeAnimationForKey:@"POPSpringAnimationKeyColor"];
        [view pop_addAnimation:textColorSpringAnimation forKey:@"POPSpringAnimationKeyColor"];
    });
}

- (void)makeUI{
    NSArray *titles = @[@"汽车图片",@"对比",@"排行榜",@"html5"];
    for (int i = 0; i < titles.count; i ++) {
          UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 20*i, button.frame.size.width, 20);
        [button addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }


}

- (void)btnClick:(UIButton *)btn{
   
    if ([btn.titleLabel.text isEqualToString:@"汽车图片"]) {
            UIViewController *vc = [[NSClassFromString(@"VehicleImageViewController") alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)self.theVC pushViewController:vc animated:YES];
         
    }else if ([btn.titleLabel.text isEqualToString:@"对比"]){
            UIViewController *chart = [[NSClassFromString(@"ContrastChartViewController") alloc] init];
            chart.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)self.theVC pushViewController:chart animated:YES];


    }else if ([btn.titleLabel.text isEqualToString:@"排行榜"]){

        Class cls = NSClassFromString(@"ComplainChartViewController");
        UIViewController *chart = [[cls alloc] init];
        chart.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.theVC pushViewController:chart animated:YES];

    }else if ([btn.titleLabel.text isEqualToString:@"html5"]){

        Class cls = NSClassFromString(@"Html5ViewController");
        UIViewController *chart = [[cls alloc] init];
        chart.hidesBottomBarWhenPushed = YES;
        [(UINavigationController *)self.theVC pushViewController:chart animated:YES];
    }
}

//超视界响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [button convertPoint:point fromView:self];
        if (CGRectContainsPoint(button.bounds, tempoint))
        {
            view = button;

            for (UIView *vi in button.subviews) {

                if (CGRectContainsPoint(vi.frame, tempoint))
                {
                    return vi;
                }
                
            }
        }

    }
    return view;
}

@end
