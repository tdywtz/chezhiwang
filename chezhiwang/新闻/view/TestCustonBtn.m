//
//  TestCustonBtn.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TestCustonBtn.h"

@implementation TestCustonBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetWidth(frame))];
        _customTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height-17, frame.size.width, 17)];
        _customTitleLabel.font = [UIFont systemFontOfSize:15];
        _customTitleLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_customImageView];
        [self addSubview:_customTitleLabel];
    }

    return self;
}

//设置选中view的背景颜色和标题颜色
- (void)setCustomBarTitleColor:(UIColor *)color{
    _customTitleLabel.textColor = [UIColor colorWithCGColor:color.CGColor];
    //_customImageView.backgroundColor = [UIColor colorWithCGColor:color.CGColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
