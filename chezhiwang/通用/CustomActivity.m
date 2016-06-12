//
//  CustomActivity.m
//  chezhiwang
//
//  Created by bangong on 15/10/13.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CustomActivity.h"

@implementation CustomActivity
{
    UIActivityIndicatorView *_activity;
}

-(instancetype)initWithCenter:(CGPoint)center{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 140, 70);
        self.center = center;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self createActivity];
        self.hidden = YES;
    }
    return self;
}


-(void)createActivity{
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 20, 20, 30)];
    [self addSubview:_activity];
    
    
    UILabel *lable = [LHController createLabelWithFrame:CGRectMake(50, 25, 80, 20) Font:[LHController setFont]-4 Bold:NO TextColor:[UIColor whiteColor] Text:@"加载中..."];
    [self addSubview:lable];
}

-(void)animationStarting{
    self.hidden = NO;
    [_activity startAnimating];
}
-(void)animationStoping{
    [_activity stopAnimating];
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
