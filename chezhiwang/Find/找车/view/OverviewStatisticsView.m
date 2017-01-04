//
//  OverviewStatisticsView.m
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewStatisticsView.h"

@interface BreakdownStatisticsView : UIView
{
    UILabel *countLabel;
}
@end

@implementation BreakdownStatisticsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        YYLabel *systemLabel = [[YYLabel alloc] init];
        systemLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(20)];
        systemLabel.textColor = colorBlack;
        systemLabel.backgroundColor = colorBackGround;
        systemLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 0);
        systemLabel.text = @"八大系统故障";

        countLabel = [[UILabel alloc] init];
        countLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(20)];
        countLabel.textAlignment = NSTextAlignmentRight;
        countLabel.textColor = colorOrangeRed;

        [self addSubview:systemLabel];
        [self addSubview:countLabel];

        systemLabel.lh_left = 0;
        systemLabel.lh_top = 0;
        systemLabel.lh_size = CGSizeMake(frame.size.width, 40);

        countLabel.lh_size = CGSizeMake(130, 40);
        countLabel.lh_top = 0;
        countLabel.lh_right = frame.size.width - 10;


        NSArray *titles = @[@"发动机",@"变速器",@"离合器",@"转向系统",@"制动系统",@"轮胎",@"前后桥及悬挂系统",@"车身附件及电器"];
        CGFloat y = systemLabel.lh_bottom;
        for (int i = 0; i < 8; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@""];

            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:PT_FROM_PX(20)];
            label.textColor = colorDeepGray;
            label.text = titles[i];

            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
            numLabel.textColor = colorBlack;
            numLabel.tag = 100 + i;

            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = colorLineGray;

            [self addSubview:imageView];
            [self addSubview:label];
            [self addSubview:numLabel];
            [self addSubview:lineView];

            imageView.lh_left = 0;
            imageView.lh_top = y;
            imageView.lh_size = CGSizeMake(50, 40);

            label.lh_left = imageView.lh_right;
            label.lh_top = imageView.lh_top;
            label.lh_size = CGSizeMake(200, 40);

            numLabel.lh_size = CGSizeMake(60, 40);
            numLabel.lh_top = label.lh_top;
            numLabel.lh_right = self.frame.size.width-10;
            numLabel.textAlignment = NSTextAlignmentRight;

            lineView.lh_top = label.lh_bottom;
            lineView.lh_left = 0;
            lineView.lh_size = CGSizeMake(self.frame.size.width, 1);

            y = lineView.lh_bottom;
        }

        self.layer.borderColor = colorLineGray.CGColor;
        self.layer.borderWidth = 1;
        self.lh_height = y;

        [self setNumbar];
    }
    return self;
}

- (void)setNumbar{
    NSArray *arr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    for (int i = 0; i < arr.count; i ++) {
        UIView *view = (UILabel *)[self viewWithTag:100 + i];
        if (view == nil || [view isKindOfClass:[UILabel class]] == NO) {
            continue;
        }
        ((UILabel *)view).text = arr[i];
    }

    countLabel.text = @"共58个";
}
@end

@interface StatisticsChangeView : UIView
{
    UIView *moveView;
}

@property (nonatomic,copy) void (^click)(NSInteger index);

- (void)setTitels:(NSArray *)titles;

@end

@implementation StatisticsChangeView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        if (titles.count) {
            [self setTitels:titles];
        }
    }
    return self;
}

- (void)setTitels:(NSArray *)titles{
    CGFloat width = CGRectGetWidth(self.frame)/titles.count;
    for (int i = 0; i < titles.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, self.frame.size.height - 2);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
        [btn setTitleColor:colorLightGray forState:UIControlStateNormal];
        [btn setTitleColor:colorLightBlue forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        if (i == 0) {
            btn.selected = YES;
        }
        [self addSubview:btn];
    }

    moveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, width, 2)];
    moveView.backgroundColor = colorLightBlue;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
    lineView.backgroundColor = colorLineGray;

    [self addSubview:lineView];
    [self addSubview:moveView];
}

- (void)buttonClick:(UIButton *)button{
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100 + i];
        if (btn == nil || [btn isKindOfClass:[UIButton class]] == NO) {
            continue;
        }
        if (btn == button) {
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                moveView.lh_centerX = btn.lh_centerX;
            }];
        }else{
            btn.selected = NO;
        }
        if (self.click) {
            self.click(i);
        }
    }
}
@end

#pragma mark - 故障统计
@implementation OverviewStatisticsView
{
    UIView *_lineView;
    StatisticsChangeView *changeView;
    BreakdownStatisticsView *breakdownView;
    YYLabel *exampleTitleLabel;//典型
    YYLabel *exampleLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 18)];
        nameLabel.text = @"车型故障统计";
        nameLabel.font = [UIFont boldSystemFontOfSize:PT_FROM_PX(20)];
        nameLabel.textColor = colorBlack;

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 1)];
        lineView.backgroundColor = colorLineGray;

        changeView = [[StatisticsChangeView alloc] initWithFrame:CGRectMake(10, 39, WIDTH-20, 40) titles:@[@"2015",@"2013",@"2016",@"2000"]];

        breakdownView = [[BreakdownStatisticsView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, 10)];

        exampleTitleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        exampleTitleLabel.text = @"典型故障";
        exampleTitleLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 0);
        exampleTitleLabel.backgroundColor = colorBackGround;
        exampleTitleLabel.layer.borderColor = colorLineGray.CGColor;
        exampleTitleLabel.layer.borderWidth = 1;

        exampleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        exampleLabel.layer.borderWidth = 1;
        exampleLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        exampleLabel.numberOfLines = 0;
        exampleLabel.layer.borderColor = colorLineGray.CGColor;


        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
        _lineView.backgroundColor = colorBackGround;

        [self addSubview:nameLabel];
        [self addSubview:lineView];
        [self addSubview:changeView];
        [self addSubview:breakdownView];
        [self addSubview:exampleTitleLabel];
        [self addSubview:exampleLabel];
        [self addSubview:_lineView];

       // [self resetLayout];
        [self setdata];
    }
    return self;
}

- (void)resetLayout{

    changeView.lh_left = 10;
    changeView.lh_top = 39;

    breakdownView.lh_left = changeView.lh_left;
    breakdownView.lh_top = changeView.lh_bottom + 5;

    exampleTitleLabel.lh_left = 10;
    exampleTitleLabel.lh_top = breakdownView.lh_bottom + 10;
    exampleTitleLabel.lh_size = CGSizeMake(breakdownView.lh_width, 40);


    exampleLabel.lh_left = exampleTitleLabel.lh_left;
    exampleLabel.lh_top = exampleTitleLabel.lh_bottom - 1;
    exampleLabel.lh_width = WIDTH - 20;
    exampleLabel.lh_height = 1000;
    [exampleLabel sizeToFit];
    exampleLabel.lh_width = WIDTH - 20;

    _lineView.lh_left = 0;
    _lineView.lh_top = exampleLabel.lh_bottom + 10;
    _lineView.lh_size = CGSizeMake(WIDTH, 5);

    self.lh_width = WIDTH;
    self.lh_height = _lineView.lh_bottom;
}

- (void)setdata{
    NSArray *arr = @[
                     @{@"parentTitle":@"sd44447ff",@"title":@"uueuu",@"count":@"12"},
                     @{@"parentTitle":@"sd7ff",@"title":@"ueuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uueuu",@"count":@"12"},
                     @{@"parentTitle":@"sd7ff",@"title":@"uuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uuuu",@"count":@"12"},
                     @{@"parentTitle":@"sdf7f",@"title":@"uuuu",@"count":@"12"}
                     ];
    exampleLabel.attributedText = [self attribute:arr];
    [self resetLayout];
}

- (UIImage *)imageWithView:(UIView *)view{
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (NSAttributedString *)attribute:(NSArray *)arrray{
    if ([arrray isKindOfClass:[NSArray class]] == NO) {
        return nil;
    }

    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < arrray.count; i ++) {
        NSDictionary *dict = arrray[i];
        [mAtt appendAttributedString:[self textAchment:dict[@"parentTitle"] textColor:[UIColor whiteColor] backColor:RGB_color(172, 92, 158, 1)]];
        [mAtt appendAttributedString:[self textAchment:dict[@"title"] textColor:RGB_color(172, 92, 158, 1) backColor:[UIColor whiteColor]]];
        [mAtt appendAttributedString:[self textAchment:[NSString stringWithFormat:@"%@个",dict[@"count"]] textColor:colorOrangeRed backColor:[UIColor whiteColor]]];
        if (i < arrray.count - 1) {
            [mAtt appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:[UIColor clearColor]}]];

        }
    }
    mAtt.yy_lineSpacing = 4;
    return mAtt;
}

- (NSAttributedString *)blankAttrubute{
    unichar objectReplacementChar           = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    return [[NSAttributedString alloc] initWithString:objectReplacementString];
}

- (NSAttributedString *)textAchment:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor{
//
//    NSTextAttachment *achment = [[NSTextAttachment alloc] init];
//    UIImage *image = [self imageWithView:[self LabelWithText:text textColor:textColor backColor:backColor]];
//    achment.image = image;
//    achment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIImage *image = [self imageWithView:[self LabelWithText:text textColor:textColor backColor:backColor]];

    NSMutableAttributedString *att = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:image.size alignToFont:[UIFont systemFontOfSize:1] alignment:YYTextVerticalAlignmentCenter];

    
    return att;
}

- (UIView *)LabelWithText:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor{


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 10)];

    label.backgroundColor = backColor;
    label.layer.borderColor = colorPurple.CGColor;
    label.layer.borderWidth = 1;
    label.textAlignment = NSTextAlignmentCenter;

    if (text == nil) {
        text = @"";
    }
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:text];
    matt.yy_font = [UIFont systemFontOfSize:12];
    matt.yy_color = textColor;

    label.attributedText = matt;
    [label sizeToFit];
    label.lh_width += 6;
    label.lh_height += 2;

    return label;
}

@end

