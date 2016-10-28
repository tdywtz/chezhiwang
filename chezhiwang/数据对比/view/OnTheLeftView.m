//
//  OnTheLeftView.m
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OnTheLeftView.h"

@implementation OnTheLeftView
{
    UIButton *highlightButton;
    UIButton *hideButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
        self.layer.borderWidth = 0.5;

        highlightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [highlightButton setTitle:@"高亮差异参数" forState:UIControlStateNormal];
        [highlightButton setTitleColor:colorBlack forState:UIControlStateNormal];
        [highlightButton setTitleColor:colorLightBlue forState:UIControlStateSelected];
       // [highlightButton setBackgroundImage:[UIImage imageNamed:@"kk(1)"] forState:UIControlStateSelected];
        highlightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        highlightButton.layer.cornerRadius = 3;
        highlightButton.layer.masksToBounds = YES;
        highlightButton.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
        highlightButton.layer.borderWidth = 1;
        [highlightButton addTarget:self action:@selector(highlightButtonClick) forControlEvents:UIControlEventTouchUpInside];

        hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [hideButton setTitle:@"隐藏相同参数" forState:UIControlStateNormal];
        [hideButton setTitleColor:colorBlack forState:UIControlStateNormal];
        [hideButton setTitleColor:colorLightBlue forState:UIControlStateSelected];
      //  [hideButton setBackgroundImage:[UIImage imageNamed:@"kk(1)"] forState:UIControlStateSelected];
        hideButton.titleLabel.font = [UIFont systemFontOfSize:12];
        hideButton.layer.cornerRadius = 3;
        hideButton.layer.masksToBounds = YES;
        hideButton.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
        hideButton.layer.borderWidth = 1;
        [hideButton addTarget:self action:@selector(hideButtonClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:highlightButton];
        [self addSubview:hideButton];

        [highlightButton makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(80, 30));
            make.top.equalTo(10);
            make.left.equalTo(10);
        }];
        [hideButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-10);
            make.left.equalTo(10);
            make.size.equalTo(CGSizeMake(80, 30));
        }];
    }
    return self;
}

- (void)highlightButtonClick{
    highlightButton.selected = !highlightButton.selected;
    if ([self.delegate respondsToSelector:@selector(highlightButtonClick:)]) {
        [self.delegate highlightButtonClick:highlightButton.selected];
    }
    [self resetBordColor];
}

- (void)hideButtonClick{
    hideButton.selected = !hideButton.selected;
    if ([self.delegate respondsToSelector:@selector(hideButtonClick:)]) {
        [self.delegate hideButtonClick:hideButton.selected];
    }
    [self resetBordColor];
}

- (BOOL)highlight{
    return hideButton.selected;
}

- (void)resetButton{
    highlightButton.selected = NO;
    hideButton.selected = NO;
    [self resetBordColor];
}

- (void)resetBordColor{
    if (hideButton.selected) {
        hideButton.layer.borderColor = colorLightBlue.CGColor;
    }else{
        hideButton.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
    }

    if (highlightButton.selected) {
        highlightButton.layer.borderColor = colorLightBlue.CGColor;
    }else{
    highlightButton.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
    }
}
@end
