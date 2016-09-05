//
//  BezierPathView.m
//  chezhiwang
//
//  Created by bangong on 16/6/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BezierPathView.h"

@interface BezierPathView ()
{
    CGRect _rect;
}
@end

@implementation BezierPathView

- (instancetype)initWithFrame:(CGRect)frame bezierRect:(CGRect)rect radius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        _rect = rect;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, frame.size.width, frame.size.height)cornerRadius:0];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
        
        [path appendPath:circlePath];
        [path setUsesEvenOddFillRule:YES];
   
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule =kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.5;
        [self.layer addSublayer:fillLayer];
        
        [self createSubView];
       
    }
    return self;
}

- (void)createSubView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pc"]];
    [self addSubview:imageView];
    imageView.tag = 101;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rect.origin.y+_rect.size.height/2);
        make.left.equalTo(_rect.size.width/2+_rect.origin.x);
    }];
    
    
    UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-100);
        make.width.equalTo(80);
    }];
}

- (void)btnClick{
    
     [self hideArrow];
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

-(void)hideArrow{
   
    [UIView beginAnimations:@"HideArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    //[UIView setAnimationDelegate:self];
    self.alpha = 0.0;
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
}
// Called at the end of the preceding animation.

- (void)showArrow
{
   
    [UIView beginAnimations:@"ShowArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:1.0];
    self.alpha = 1.0;
    [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
