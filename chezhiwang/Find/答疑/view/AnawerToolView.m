//
//  ToolView.m
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AnawerToolView.h"

@interface AnawerToolView ()
//**保存按钮*/
@property (nonatomic,strong) NSMutableArray *items;

/**移动条*/
@property (nonatomic,strong) UIView *moveView;
@end

@implementation AnawerToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = colorLineGray;
        self.moveView = [[UIView alloc] init];
        self.moveView.backgroundColor = colorYellow;
        
        [self addSubview:line];
        [self addSubview:self.moveView];
        
        [line makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return self;
}


-(void)setTitleArray:(NSArray<__kindof NSString *> *)titleArray{
    _titleArray = titleArray;
    
    if (_titleArray.count == 0) {
        return;
    }
    UIButton *temp = nil;
    if (!self.items) {
        self.items = [[NSMutableArray alloc] init];
    }
    
    NSString *string = [_titleArray componentsJoinedByString:@""];
  CGFloat spaceWidth = (WIDTH-[string boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width)/_titleArray.count;
    for (int i = 0; i < _titleArray.count; i ++) {
 
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:colorBlack forState:UIControlStateNormal];
        [button setTitleColor:colorYellow forState:UIControlStateSelected];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        if (temp) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(temp.right).offset(spaceWidth);
                make.centerY.equalTo(0);
            }];
            
        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(spaceWidth/2);
                make.centerY.equalTo(0);
            }];
        }
        temp = button;
        [self.items addObject:button];
    }
}

-(void)buttonClick:(UIButton *)button{

    [self updateCurrent:button];

    if ([self.delegate respondsToSelector:@selector(selectedButton:)]) {
        [self.delegate selectedButton:button.tag-100];
    }
}

- (void)updateCurrent:(UIButton *)button{
    for (UIButton *btn in self.items) {
        btn.selected = NO;

    }
    button.selected = YES;
    
    CGFloat witdh = CGRectGetWidth(button.frame);
    CGFloat centreX = button.center.x;
    if (witdh < 10) {
        witdh = 32;
        centreX = 31;
    }
    CGRect rect = CGRectMake(0, 0,witdh + 20, 3);
    CGPoint center = CGPointMake(centreX, CGRectGetHeight(self.frame)-2);
    [UIView animateWithDuration:0.1 animations:^{
        self.moveView.frame = rect;
        self.moveView.center = center;
    }];
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
 
    if (_currentIndex >= 0 && _currentIndex < self.items.count) {

        [self updateCurrent:self.items[_currentIndex]];
    }
}

@end
