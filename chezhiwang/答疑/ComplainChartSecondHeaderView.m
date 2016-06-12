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
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 5)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topLine];
    
    NSArray *array = @[@"  厂家满意度  ",@"  车主满意度  ",@"  新车调查排行  "];
    UIButton *temp = nil;
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (temp == nil) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(10);
                make.height.equalTo(CGRectGetHeight(self.frame)/2);
            }];
            button.selected = YES;
        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(0);
                make.left.equalTo(temp.right);
                make.height.equalTo(CGRectGetHeight(self.frame)/2);
            
            }];
        }
        temp = button;
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
    
    moveView = [[UIView alloc] init];
    moveView.backgroundColor = [UIColor greenColor];
    [self addSubview:moveView];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(CGRectGetHeight(self.frame)/2);
        make.height.equalTo(1);
    }];
    [moveView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(CGRectGetHeight(self.frame)/2-2);
        make.height.equalTo(2);
        make.width.equalTo(temp).offset(-12);
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame)-20, CGRectGetHeight(self.frame)/2)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor grayColor];
        [view addSubview:label];
        if (i == 0) {
            label.text = @"排序";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.centerY.equalTo(0);
            }];
        }else if (i == 1){
            label.text = @"品牌";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(CGPointZero);
            }];

        }else{
            label.text = @"回复率";
            [label makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-10);
                make.centerY.equalTo(0);
            }];

        }
    }
}


-(void)buttonClick:(UIButton *)button{
  
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        if ([btn isEqual:button]) {
            btn.selected = YES;
          
            [UIView animateWithDuration:0.2 animations:^{
                [moveView remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btn.left);
                    make.top.equalTo(CGRectGetHeight(self.frame)/2-2);
                    make.height.equalTo(2);
                    make.width.equalTo(btn.width);
                }];
            }];
            
        }else{
            btn.selected = NO;
        }
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
