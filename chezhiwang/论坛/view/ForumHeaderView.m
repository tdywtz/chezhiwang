//
//  ForumHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/11/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumHeaderView.h"

@implementation ForumHeaderView
{
    UIButton *allButton;
    UIButton *bestButton;
    UIView *moveView;
    UIButton *newButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [allButton setTitleColor:colorYellow forState:UIControlStateSelected];
    allButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [allButton addTarget:self action:@selector(allButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    allButton.selected = YES;

    bestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bestButton setTitle:@"精华" forState:UIControlStateNormal];
    [bestButton setTitleColor:colorBlack forState:UIControlStateNormal];
    [bestButton setTitleColor:colorYellow forState:UIControlStateSelected];
    bestButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [bestButton addTarget:self action:@selector(bestButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:@"最新回复" forState:UIControlStateNormal];
    [newButton setTitleColor:colorYellow forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [newButton addTarget:self action:@selector(newButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    newButton.tag = 100;

    moveView = [[UIView alloc] init];
    moveView.backgroundColor = colorYellow;

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB_color(240, 240, 240, 1);


    [self addSubview:allButton];
    [self addSubview:bestButton];
    [self addSubview:moveView];
    [self addSubview:newButton];
    [self addSubview:lineView];

    allButton.lh_size = CGSizeMake(60, 30);
    allButton.lh_left = 10;
    allButton.lh_centerY = self.lh_height/2;

    bestButton.lh_size = CGSizeMake(60, 30);
    bestButton.lh_left = allButton.lh_right+10;
    bestButton.lh_centerY = allButton.lh_centerY;

    moveView.lh_size = CGSizeMake(60, 2);
    moveView.lh_centerX = allButton.lh_centerX;
    moveView.lh_bottom = self.lh_height-1;

    [newButton sizeToFit];
    newButton.lh_height = 30;
    newButton.lh_right = WIDTH-10;
    newButton.lh_centerY = bestButton.lh_centerY;

    lineView.lh_size = CGSizeMake(WIDTH, 1);
    lineView.lh_left = 0;
    lineView.lh_bottom = self.lh_height;
}

- (void)allButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    button.selected = YES;
    bestButton.selected = NO;

    moveView.lh_centerX = allButton.lh_centerX;

    [self didSelectOrderType:0 topicType:newButton.tag-100];
}

- (void)bestButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    allButton.selected = NO;
    bestButton.selected = YES;

    moveView.lh_centerX = bestButton.lh_centerX;

    [self didSelectOrderType:1 topicType:newButton.tag-100];
}

- (void)newButtonClick:(UIButton *)button{

}

- (void)didSelectOrderType:(NSInteger)orderType topicType:(NSInteger)topicType{
    [self.delegate didSelectOrderType:orderType topicType:topicType];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
