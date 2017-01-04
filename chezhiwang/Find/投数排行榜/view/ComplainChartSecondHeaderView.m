//
//  ComplainChartSecondHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartSecondHeaderView.h"

@interface ComplainChartSecondHeaderView ()
{
    UIView *moveView;
    UILabel *brandSeriesLabel;
    UILabel *percentageLabel;//百分比
}
@end

@implementation ComplainChartSecondHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 7)];
    topLine.backgroundColor = colorBackGround;
    [self addSubview:topLine];
    
    NSArray *array = @[@" 厂家回复率 ",@" 车主满意度 ",@" 新车调查排行 "];
    UIButton *temp = nil;
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:colorDeepGray forState:UIControlStateNormal];
        [button setTitleColor:colorLightBlue forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (temp == nil) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(15);
                make.left.equalTo(10);
            }];
            button.selected = YES;
        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(15);
                make.left.equalTo(temp.right).offset(10);
            }];
        }
        temp = button;
    }

    moveView = [[UIView alloc] init];
    moveView.backgroundColor = colorLightBlue;
    [self addSubview:moveView];

   
    [moveView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(-36);
        make.height.equalTo(2);
        make.width.equalTo(temp).offset(-12);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-45, CGRectGetWidth(self.frame), 35)];
    view.backgroundColor = colorBackGround;
    [self addSubview:view];
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = colorDeepGray;
        [view addSubview:label];
        if (i == 0) {
            label.text = @"排序";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(20);
                make.centerY.equalTo(0);
            }];
        }else if (i == 1){
            brandSeriesLabel = label;
            label.text = @"品牌";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(CGPointZero);
            }];

        }else{
            percentageLabel = label;
            label.text = @"回复率";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-20);
                make.centerY.equalTo(0);
            }];

        }
    }
}


-(void)buttonClick:(UIButton *)button{
    
    _current = button.tag-100;
    if (_current == 0) {
        brandSeriesLabel.text = @"品牌";
        percentageLabel.text = @"回复率";
    }else if (_current == 1){
        brandSeriesLabel.text = @"品牌";
        percentageLabel.text = @"满意度";
    }else if (_current == 2){
        brandSeriesLabel.text = @"调查车型";
        percentageLabel.text = @"综合评分";
    }

    for (int i = 0; i < 3; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        if ([btn isEqual:button]) {
            btn.selected = YES;
           
            [UIView animateWithDuration:0.2 animations:^{
                [moveView remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btn.left);
                    make.bottom.equalTo(-36);
                    make.height.equalTo(2);
                    make.width.equalTo(btn.width);
                }];
                [moveView layoutIfNeeded];
            }];
            
        }else{
            btn.selected = NO;
        }
    }
    //回调
    if (self.click) {
        self.click(_current);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
