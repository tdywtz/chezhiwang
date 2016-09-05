//
//  TestCellIntroduceView.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TestCellIntroduceView.h"

@implementation TestCellIntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        _buttons = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"外观",@"内饰",@"性能",@"空间",@"安全"];
        CGFloat btnWidth = 35;
        if (WIDTH > 330 ) {
            btnWidth = 40;
        }
        CGFloat space = (WIDTH-130-btnWidth*titles.count)/(titles.count-1);
        for (int i = 0; i < titles.count; i ++) {
            TestCustonBtn *btn = [[TestCustonBtn alloc] initWithFrame:CGRectMake((btnWidth+space)*i, 0, btnWidth, btnWidth+21)];
            btn.customTitleLabel.text = titles[i];
            [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_buttons addObject:btn];
            if (i == 0) {
                //设置选中颜色
                [btn setCustomBarTitleColor:colorYellow];
            }else{
                //未选中颜色
                [btn setCustomBarTitleColor:colorLightBlue];
            }
        }

        TestCustonBtn *btn = _buttons[0];
        _contentLabel = [[TestLabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(btn.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-btn.frame.size.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.cornerRadius = 2;
        _contentLabel.lineBreakMode = kCTLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 2;
        _contentLabel.textAlignment = kCTTextAlignmentJustified;
        _contentLabel.textInsets = UIEdgeInsetsMake(15, 5, 5, 25);
        _contentLabel.draw_x = btnWidth/2;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = colorLightGray;
        _contentLabel.lineSpacing = 1;
        _contentLabel.userInteractionEnabled = NO;
        //_contentLabel.firstLineHeadIndent = 20;
        [self addSubview:_contentLabel];
       // _contentLabel.backgroundColor = [UIColor redColor];
    }

    return self;
}

-(void)titleClick:(TestCustonBtn *)btn{
    if (btn.gray) {
        return;
    }
    _contentLabel.draw_x = btn.center.x;

    NSInteger index = [self.buttons indexOfObject:btn];
    _model.descCurrent = index;
    if (index < self.buttons.count) {
        _contentLabel.text = _descArray[index][@"font"];//描述内容
    }else{
        _contentLabel.text = @"";
    }

    NSArray *imageNames   = @[@"pc_wg",@"pc_ns",@"pc_xn",@"pc_kj",@"pc_aq"];
    NSArray *imageNames_h = @[@"pc_wg_h",@"pc_ns_h",@"pc_xn_h",@"pc_kj_h",@"pc_aq_h"];

    for (int i = 0; i < self.buttons.count; i ++) {
        TestCustonBtn *testBtn = self.buttons[i];
        testBtn.gray = NO;
        if ([testBtn isEqual:btn]) {

            [testBtn setCustomBarTitleColor:RGB_color(218, 165, 101, 1)];
            testBtn.customImageView.image = [UIImage imageNamed:imageNames_h[i]];

        }else{
            [testBtn setCustomBarTitleColor:RGB_color(102, 160, 178, 1)];
            testBtn.customImageView.image = [UIImage imageNamed:imageNames[i]];
        }
    }
    [self setGray];
}

- (void)setDescArray:(NSArray *)descArray{
    _descArray = descArray;
    [self titleClick:self.buttons[_model.descCurrent]];
}

- (void)setModel:(NewsTestTableViewModel *)model{
    _model = model;
}

- (void)setGray{
    NSInteger index = [_model.gray integerValue];
    index--;

    if (index > 0 && index < 5) {
        TestCustonBtn *btn = self.buttons[index];
        btn.gray = YES;
        NSArray *imageNames_g = @[@"pc_wg_g",@"pc_ns_g",@"pc_xn_g",@"pc_kj_g",@"pc_aq_g"];
        btn.customTitleLabel.textColor = colorLineGray;
        btn.customImageView.image = [UIImage imageNamed:imageNames_g[index]];
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
