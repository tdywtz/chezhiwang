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

    UIButton *newButton1;
    UIButton *newButton2;
    UIView *backView;

    NSInteger _orderType;
    NSInteger _topicType;
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


    UIImage *image = [UIImage imageNamed:@"xuanze"];
    //需要对图片进行特殊处理
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:@"最新发布" forState:UIControlStateNormal];
    [newButton setTitleColor:colorYellow forState:UIControlStateNormal];
    newButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [newButton setImage:image forState:UIControlStateNormal];
    [newButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    [newButton setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, -75)];
    [newButton setTintColor:colorYellow];
    [newButton addTarget:self action:@selector(newButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    _orderType = 1;

    moveView = [[UIView alloc] init];
    moveView.backgroundColor = colorYellow;

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorBackGround;


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


    newButton.lh_height = 30;
    newButton.lh_width = 90;
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
    _topicType = 0;
    [self didSelectOrderType:_orderType topicType:_topicType];
}

- (void)bestButtonClick:(UIButton *)button{
    if (button.selected) {
        return;
    }
    allButton.selected = NO;
    bestButton.selected = YES;

    moveView.lh_centerX = bestButton.lh_centerX;

    _topicType = 1;
    [self didSelectOrderType:_orderType topicType:_topicType];
}

- (void)newButtonClick:(UIButton *)button{
    if (newButton1 == nil) {
        newButton1= [UIButton buttonWithType:UIButtonTypeCustom];
        [newButton1 setTitle:@"最新回复" forState:UIControlStateNormal];
        newButton1.titleLabel.font = [UIFont systemFontOfSize:17];
        [newButton1 setTitleColor:colorLightGray forState:UIControlStateNormal];
        [newButton1 addTarget:self action:@selector(newClick:) forControlEvents:UIControlEventTouchUpInside];

        newButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [newButton2 setTitle:@"最新发布" forState:UIControlStateNormal];
        newButton2.titleLabel.font = [UIFont systemFontOfSize:17];
        [newButton2 setTitleColor:colorLightGray forState:UIControlStateNormal];
        [newButton2 addTarget:self action:@selector(newClick:) forControlEvents:UIControlEventTouchUpInside];

        backView = [[UIView alloc] init];
        backView.hidden = YES;
        backView.backgroundColor = RGB_color(0, 0, 0, 0.5);

        UIView *whiteView = [[UIView alloc] init];
        whiteView.backgroundColor = [UIColor whiteColor];

        [backView addSubview:whiteView];
        [backView addSubview:newButton1];
        [backView addSubview:newButton2];

        if (self.showChooseView) {
            [self.showChooseView addSubview:backView];

        }else{
            [self.superview addSubview:backView];
        }

        [newButton1 sizeToFit];
        [newButton2 sizeToFit];

        CGRect frame = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
        backView.lh_top = frame.origin.y + frame.size.height;
        backView.lh_left = 0;
        backView.lh_width = WIDTH;
        backView.lh_height = HEIGHT;

        newButton1.lh_height = 40;
        newButton1.lh_width += 20;
        newButton1.lh_right = WIDTH-20;
        newButton1.lh_top = 0;

        newButton2.lh_height = newButton1.lh_height;
        newButton2.lh_width = newButton1.lh_width;
        newButton2.lh_right = WIDTH-20;
        newButton2.lh_top = newButton1.lh_bottom-1;

        whiteView.lh_left = 0;
        whiteView.lh_top = 0;
        whiteView.lh_width = WIDTH;
        whiteView.lh_height = newButton2.lh_bottom;
    }

    if (backView.hidden) {
        backView.hidden = NO;

    }else{
        backView.hidden = YES;
    }
}

- (void)newClick:(UIButton *)button{
    backView.hidden = YES;
    [newButton setTitle:button.titleLabel.text forState:UIControlStateNormal];
    if ([button.titleLabel.text isEqualToString:@"最新回复"]) {
        _orderType = 0;
    }else{
        _orderType = 1;
    }
    [self didSelectOrderType:_orderType topicType:_topicType];
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
