
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
        self.backgroundColor = [UIColor blackColor];
        //隐藏阴影线
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
        
        button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame = CGRectMake(100, -100, 100, 200);
        [self addSubview:button];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
       
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
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self addSubview:view];
    view.text = @"asfasdfa";
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


//超视界响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [button convertPoint:point fromView:self];
        if (CGRectContainsPoint(button.bounds, tempoint))
        {
            view = button;
        }
    }
    return view;
}

@end
