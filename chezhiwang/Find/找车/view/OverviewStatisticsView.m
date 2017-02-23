//
//  OverviewStatisticsView.m
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewStatisticsView.h"

@implementation OverviewStatisticsExampleModel


@end

@implementation OverviewStatisticsModel

- (NSString *)year{
    if (_year == nil) {
        _year = @"null";
    }
    return _year;
}

- (NSString *)A{
    if (_A == nil) {
        _A = @"0";
    }
    return  _A;
}

- (NSString *)B{
    if (_B == nil) {
        _B = @"0";
    }
    return  _B;
}

- (NSString *)C{
    if (_C == nil) {
        _C = @"0";
    }
    return  _C;
}

- (NSString *)D{
    if (_D == nil) {
        _D = @"0";
    }
    return  _D;
}

- (NSString *)E{
    if (_E == nil) {
        _E = @"0";
    }
    return  _E;
}

- (NSString *)F{
    if (_F == nil) {
        _F = @"0";
    }
    return  _A;
}

- (NSString *)G{
    if (_G == nil) {
        _G = @"0";
    }
    return  _G;
}

- (NSString *)H{
    if (_H == nil) {
        _H = @"0";
    }
    return  _H;
}

- (NSString *)total{
    if (_total == nil) {
        _total = @"0";
    }
    return _total;
}


@end

#pragma mark - BreakdownStatisticsView
@interface BreakdownStatisticsView : UIView
{
    UILabel *countLabel;
}
@property (nonatomic,strong) OverviewStatisticsModel *model;

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


        NSArray *titles = @[@"发动机",@"制动系统",@"变速器",@"轮胎",@"前后桥及悬挂系统",@"离合器",@"转向系统",@"车身附件及电器"];
        CGFloat y = systemLabel.lh_bottom;
        UIView *temp = nil;
        for (int i = 0; i < 8; i ++) {

            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = colorBlack;
            label.text = titles[i];

            UILabel *numLabel = [[UILabel alloc] init];
            numLabel.font = [UIFont systemFontOfSize:14];
            numLabel.textColor = colorYellow;
            numLabel.tag = 100 + i;


            [self addSubview:label];
            [self addSubview:numLabel];

            CGFloat labelWidth = WIDTH/2 - 20;
            if (i%2 == 0) {
                UIView *verticalLine = [[UIView alloc] init];
                verticalLine.backgroundColor = colorLineGray;

                UIView *lineView = [[UIView alloc] init];
                lineView.backgroundColor = colorLineGray;

                [self addSubview:verticalLine];
                [self addSubview:lineView];

                label.lh_left = 10;
                label.lh_top = y;
                label.lh_size = CGSizeMake(labelWidth - 30, 40);

                verticalLine.lh_size = CGSizeMake(1, 20);
                verticalLine.lh_centerX = WIDTH/2;
                verticalLine.lh_centerY = label.lh_centerY;

                numLabel.lh_size = CGSizeMake(30, 40);
                numLabel.lh_top = label.lh_top;
                numLabel.lh_right = WIDTH/2-10;
                numLabel.textAlignment = NSTextAlignmentRight;

                lineView.lh_top = label.lh_bottom;
                lineView.lh_left = 0;
                lineView.lh_size = CGSizeMake(self.frame.size.width, 1);
                if (i == 6) {
                    lineView.lh_height = 5;
                    lineView.backgroundColor = colorBackGround;
                }
                y = lineView.lh_bottom;

            }else{

                label.lh_left = WIDTH/2 + 10;
                label.lh_top = temp.lh_top;
                label.lh_size = CGSizeMake(labelWidth - 30, 40);

                numLabel.lh_size = CGSizeMake(30, 40);
                numLabel.lh_top = label.lh_top;
                numLabel.lh_right = self.frame.size.width-10;
                numLabel.textAlignment = NSTextAlignmentRight;
            }

            temp = label;
        }
        self.lh_height = y;
    }
    return self;
}

- (void)setModel:(OverviewStatisticsModel *)model{
    _model = model;

    NSArray *arr = @[@"A",@"E",@"B",@"F",@"G",@"C",@"D",@"H"];

    for (int i = 0; i < arr.count; i ++) {
        UIView *view = (UILabel *)[self viewWithTag:100 + i];
        if (view == nil || [view isKindOfClass:[UILabel class]] == NO) {
            continue;
        }
        NSString *str = [_model valueForKey:arr[i]];
        ((UILabel *)view).text = str?str:@"0";
    }

    countLabel.text = [NSString stringWithFormat:@"共%@个",_model.total?_model.total:@"0"];
}

@end

#pragma mark -StatisticsChangeView
@interface StatisticsChangeView : UIView
{
    UIScrollView *_scorllView;
    UIView *moveView;
}
@property (nonatomic,strong) NSArray<NSString *> *titles;
@property (nonatomic,copy) void (^click)(NSInteger index, NSString *text);

@end

@implementation StatisticsChangeView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        _scorllView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scorllView];
        if (titles.count) {
            [self setTitles:titles];
        }
    }
    return self;
}

- (void)setTitles:(NSArray<NSString *> *)titles{
    _titles = titles;
    for (UIView *view in _scorllView.subviews) {
        if (view != moveView) {
            [view removeFromSuperview];
        }
    }
    UIView *temp = nil;
    for (int i = 0; i < titles.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
        [btn setTitleColor:colorBlack forState:UIControlStateNormal];
        [btn setTitleColor:colorYellow forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        if (i == 0) {
            btn.selected = YES;
        }

        [btn sizeToFit];
        btn.lh_width += 20;
        if (temp) {
            btn.lh_left = temp.lh_right + 25;
            btn.lh_height = self.lh_height;
        }else{
            btn.lh_left = 0;
            btn.lh_height = self.lh_height;
        }
        temp = btn;
        [_scorllView addSubview:btn];

        if (i == 0) {
            moveView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, btn.lh_width, 2)];
            moveView.backgroundColor = colorYellow;
            [_scorllView addSubview:moveView];
        }
    }

    _scorllView.contentSize = CGSizeMake(temp.lh_right, 0);
}

- (void)buttonClick:(UIButton *)button{

    for (int i = 0; i < _titles.count; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100 + i];
        if (btn == nil || [btn isKindOfClass:[UIButton class]] == NO) {
            continue;
        }
        if (btn == button) {
            btn.selected = YES;
            [UIView animateWithDuration:0.3 animations:^{
                moveView.lh_centerX = btn.lh_centerX;
            }];
            if (self.click) {
                self.click(i,button.titleLabel.text);
            }
        }else{
            btn.selected = NO;
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
    NSDictionary *_dictionary;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 18)];
        nameLabel.text = @"车型故障统计";
        nameLabel.font = [UIFont boldSystemFontOfSize:PT_FROM_PX(20)];
        nameLabel.textColor = colorBlack;

        changeView = [[StatisticsChangeView alloc] initWithFrame:CGRectMake(10, 39, WIDTH-20, 40) titles:nil];
        __weak __typeof(self)_self = self;
        changeView.click = ^(NSInteger index, NSString *text){
            if (index >= 0 && index < _models.count) {
                [_self setBreak_example:_self.models[index]];
                [_self resetLayout];
            }
        };

        breakdownView = [[BreakdownStatisticsView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
        exampleTitleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        exampleTitleLabel.text = @"典型故障";

        exampleLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        exampleLabel.numberOfLines = 0;

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
        _lineView.backgroundColor = colorBackGround;

        [self addSubview:nameLabel];
        [self addSubview:changeView];
        [self addSubview:breakdownView];
        [self addSubview:exampleTitleLabel];
        [self addSubview:exampleLabel];
        [self addSubview:_lineView];

        [self resetLayout];
    }
    return self;
}

- (void)resetLayout{

    changeView.lh_left = 10;
    changeView.lh_top = 35;

    breakdownView.lh_left = 0;
    breakdownView.lh_top = changeView.lh_bottom;
    if (changeView.titles.count == 0) {
        breakdownView.lh_top = 35;
    }

    exampleTitleLabel.lh_left = 10;
    exampleTitleLabel.lh_top = breakdownView.lh_bottom;
    exampleTitleLabel.lh_size = CGSizeMake(breakdownView.lh_width, 40);

    exampleLabel.lh_width = WIDTH - 20;
    exampleLabel.lh_height = 1000;
    [exampleLabel sizeToFit];
    exampleLabel.lh_left = exampleTitleLabel.lh_left;
    exampleLabel.lh_top = exampleTitleLabel.lh_bottom - 1;
    exampleLabel.lh_width = WIDTH - 20;

    _lineView.lh_left = 0;
    _lineView.lh_top = exampleLabel.lh_bottom + 10;
    _lineView.lh_size = CGSizeMake(WIDTH, 5);

    self.lh_width = WIDTH;
    self.lh_height = _lineView.lh_bottom;

    if (self.block) {
        self.block(CGRectZero);
    }
}


- (void)setModels:(NSArray<OverviewStatisticsModel *> *)models{
    _models = models;

    NSMutableArray *titles = [NSMutableArray array];
    for (OverviewStatisticsModel *model in models) {
        [titles addObject:model.year];
    }
    [changeView setTitles:titles];
    if (_models.count) {
        [self setBreak_example:_models[0]];
    }else{
        [self setBreak_example:nil];
    }

    [self resetLayout];
    if (self.block) {
        self.block(self.bounds);
    }
}


- (void)setBreak_example:(OverviewStatisticsModel *)model{
    [breakdownView setModel:model];
    exampleLabel.attributedText = [self attribute:model.exampleModels];
}

- (NSAttributedString *)attribute:(NSArray<OverviewStatisticsExampleModel *> *)arrray{
    if (arrray == nil || arrray.count == 0) {
        return [[NSAttributedString alloc] initWithString:@"暂无故障" attributes:@{NSFontAttributeName:   [UIFont systemFontOfSize:13],NSForegroundColorAttributeName:colorBlack}];
    }
    NSMutableAttributedString *mAtt = [[NSMutableAttributedString alloc] init];
    for (int i = 0; i < arrray.count; i ++) {
        OverviewStatisticsExampleModel *exampleModel = arrray[i];

        CGFloat maxWidth = WIDTH - 20;
        CGFloat widthNum = 60;
        CGFloat width = (maxWidth - widthNum)/2;
        CGFloat height = 25;

        [mAtt appendAttributedString:[self textAchment:exampleModel.bw textColor:[UIColor whiteColor] backColor:RGB_color(172, 92, 158, 1) size:CGSizeMake(width, height) close:YES]];
        [mAtt appendAttributedString:[self textAchment:exampleModel.ques textColor:RGB_color(172, 92, 158, 1) backColor:[UIColor whiteColor] size:CGSizeMake(width, height) close:YES]];
        [mAtt appendAttributedString:[self textAchment:[NSString stringWithFormat:@"%@个",exampleModel.count] textColor:colorOrangeRed backColor:[UIColor whiteColor] size:CGSizeMake(widthNum, height) close:NO]];
        [mAtt appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    mAtt.yy_lineSpacing = 6;
    return mAtt;
}

- (NSAttributedString *)textAchment:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor size:(CGSize)size close:(BOOL)close{

    UILabel *label = [self LabelWithText:text textColor:textColor backColor:backColor];
    label.lh_size = size;
    UIImage *image = [self imageWithView:label];
    if (!close) {

        CGRect rect = CGRectMake(1*[UIScreen mainScreen].scale, 0, (size.width-1)*[UIScreen mainScreen].scale, (size.height+1)*[UIScreen mainScreen].scale);
        CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

        UIGraphicsBeginImageContext(smallBounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, smallBounds, subImageRef);
        UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);

        image = smallImage;
        size.width -= 1;
    }

    NSMutableAttributedString *att = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:size alignToFont:[UIFont systemFontOfSize:1] alignment:YYTextVerticalAlignmentCenter];

    return att;
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

- (UILabel *)LabelWithText:(NSString *)text textColor:(UIColor *)textColor backColor:(UIColor *)backColor{


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 10)];

    label.backgroundColor = backColor;
    label.layer.borderColor = colorPurple.CGColor;
    label.layer.borderWidth = 1;
    label.textAlignment = NSTextAlignmentCenter;

    if (text == nil) {
        text = @"";
    }
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:text];
    matt.yy_font = [UIFont systemFontOfSize:14];
    matt.yy_color = textColor;

    label.attributedText = matt;
    [label sizeToFit];
    label.lh_width += 6;
    label.lh_height += 2;

    return label;
}

/**gets*/
- (NSDictionary *)dictionary{
    return  _dictionary;
}


@end

