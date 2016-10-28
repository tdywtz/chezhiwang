//
//  FootCommentView.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "FootCommentView.h"

@implementation FootCommentView
{
    UIButton *writeButton;
    UIButton *replyCountButton;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_color(255, 255, 255, 1);
        
        writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        writeButton.layer.borderWidth = 1;
        writeButton.layer.borderColor = RGB_color(221, 221, 221, 1).CGColor;
        [writeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        replyCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [replyCountButton setImage:[UIImage imageNamed:@"comment_评论"] forState:UIControlStateNormal];
        [replyCountButton setTitle:@"0" forState:UIControlStateNormal];
        [replyCountButton setTitleColor:RGB_color(64, 124, 207, 1) forState:UIControlStateNormal];
        [replyCountButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 10)];
        [replyCountButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:writeButton];
        [self addSubview:replyCountButton];

        [writeButton makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(7, 10, 7, 80));
        }];

        [replyCountButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.centerY.equalTo(0);
        }];

    //写评论按钮上的UI
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_写评论"]];

        UILabel *label = [[UILabel alloc] init];
        label.text = @"写评论";
        label.font = [UIFont systemFontOfSize:PT_FROM_PX(21)];
        label.textColor = colorLightGray;

        [writeButton addSubview:imageView];
        [writeButton addSubview:label];

        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.centerY.equalTo(0);
        }];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.right).offset(10);
            make.centerY.equalTo(0);
        }];
    }
    return self;
}

- (void)oneButton{
    [replyCountButton removeFromSuperview];
 [writeButton remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(UIEdgeInsetsMake(7, 10, 7, 10));
 }];
}

- (void)buttonClick:(UIButton *)btn{
    NSInteger slected = 0;
    if (btn == replyCountButton) {
        slected = 1;
    }
    [self.delegate clickButton:slected];
}


- (void)setReplyConut:(NSString *)replyCount{
    if (replyCount == nil) {
        replyCount = @"0";
    }
    [replyCountButton setTitle:replyCount forState:UIControlStateNormal];
}

- (void)addReplyCont{
    NSInteger num = [replyCountButton.titleLabel.text integerValue];
    num += 1;
    NSString *text = [NSString stringWithFormat:@"%ld",num];

    [self setReplyConut:text];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

     writeButton.layer.cornerRadius = (rect.size.height-14)/2;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, RGB_color(221, 221, 221, 1).CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0);
    CGContextStrokePath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
