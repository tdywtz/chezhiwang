//
//  OverviewScoreView.m
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewScoreView.h"
#import "NewsDetailViewController.h"


#pragma mark - scoreView.model
@implementation OverviewScoreViewModel

@end



@interface OverviewSliderView : UIView

@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *frontCoclor;
@property (nonatomic,copy) void(^proress)(CGFloat);
@property (nonatomic,copy) void(^finished)();

@end

@implementation OverviewSliderView
{
    CGFloat _progress;
    CGFloat oldProgress;
    CGFloat newProgress;
    CADisplayLink *_displayLink;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIColor *)backColor{
    if (_backColor == nil) {
        _backColor = [UIColor lightGrayColor];
    }
    return _backColor;
}

- (UIColor *)frontCoclor{
    if (_frontCoclor == nil) {
        _frontCoclor = [UIColor redColor];
    }
    return  _frontCoclor;
}

- (void)setProgress:(CGFloat)progress{

    [self setProgress:progress animar:NO];
}

- (void)setProgress:(CGFloat)progress animar:(BOOL)animar{
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    if (animar) {
        if (_displayLink) {
            [_displayLink invalidate];
            _displayLink = nil;
        }

        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeeds)];
        _displayLink.preferredFramesPerSecond = 100;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    }else{
        [self setNeedsDisplay];
    }
}

- (void)setNeeds{
    NSInteger count = 30 * _progress;
    newProgress += (_progress/count);

    if (newProgress > _progress) {
        newProgress =  _progress;
        [_displayLink invalidate];
    }
    if (self.proress) {
        self.proress(newProgress);
    }
    if (newProgress == _progress) {
        if (self.finished) {
            self.finished();
        }
    }
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, self.backColor.CGColor);
    CGFloat cornerWidth = rect.size.width > rect.size.height?CGRectGetHeight(rect)/2:CGRectGetWidth(rect)/2;
    CGPathRef path = CGPathCreateWithRoundedRect(rect, cornerWidth, CGRectGetHeight(rect)/2,nil);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);

    CGContextSetFillColorWithColor(context, self.frontCoclor.CGColor);
    CGRect frame = rect;
    frame.size.width *= newProgress;
    CGFloat fCornerWidth = frame.size.width > frame.size.height?CGRectGetHeight(frame)/2:CGRectGetWidth(frame)/2;
    CGPathRef fPath = CGPathCreateWithRoundedRect(frame, fCornerWidth, CGRectGetHeight(rect)/2, nil);
    CGContextAddPath(context, fPath);
    CGContextDrawPath(context, kCGPathFill);
}

@end


#pragma mark - 综合得分
@implementation OverviewScoreView
{
    UILabel *scoreLabel;
    OverviewSliderView *maxView;
    OverviewSliderView *aveView;
    OverviewSliderView *minView;

    UILabel *maxScoreLabel;
    UILabel *aveScoreLabel;
    UILabel *minScoreLabel;

    UIButton *leftButton;
    UIButton *rightButton;
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 18)];
        scoreLabel.textColor = colorDeepGray;
        scoreLabel.font = [UIFont boldSystemFontOfSize:PT_FROM_PX(20)];

        maxView = [[OverviewSliderView alloc] initWithFrame:CGRectZero];
        maxView.backColor = colorBackGround;
        maxView.frontCoclor = colorGreen;

        aveView = [[OverviewSliderView alloc] initWithFrame:CGRectZero];
        aveView.backColor = colorBackGround;
        aveView.frontCoclor = colorOrangeRed;

        minView = [[OverviewSliderView alloc] initWithFrame:CGRectZero];
        minView.backColor = colorBackGround;
        minView.frontCoclor = colorLightBlue;

        UILabel *maxLabel = [self scoreLabelWithTitle:@"最高分："];
        UILabel *aveLabel = [self scoreLabelWithTitle:@"平均分："];
        UILabel *minLabel = [self scoreLabelWithTitle:@"最低分："];

        maxScoreLabel = [self scoreLabelWithTitle:nil];
        maxScoreLabel.textColor = colorGreen;

        aveScoreLabel = [self scoreLabelWithTitle:nil];
        aveScoreLabel.textColor = colorOrangeRed;

        minScoreLabel = [self scoreLabelWithTitle:nil];
        minScoreLabel.textColor = colorLightBlue;

        // coretextView = [[OverviewViewCotextView alloc] initWithFrame:CGRectZero];

        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"查看调查结果" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
        leftButton.backgroundColor = colorBackGround;
        leftButton.layer.cornerRadius = 3;
        leftButton.layer.masksToBounds = YES;
        [leftButton setTitleColor:colorLightGray forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.enabled = NO;


        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitle:@"参与此次车型调查" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
        rightButton.backgroundColor = colorBackGround;
        rightButton.layer.cornerRadius = 3;
        rightButton.layer.masksToBounds = YES;
        [rightButton setTitleColor:colorLightGray forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
        _lineView.backgroundColor = colorBackGround;

        [self addSubview:scoreLabel];
        [self addSubview:maxView];
        [self addSubview:aveView];
        [self addSubview:minView];
        [self addSubview:maxLabel];
        [self addSubview:aveLabel];
        [self addSubview:minLabel];
        [self addSubview:maxScoreLabel];
        [self addSubview:aveScoreLabel];
        [self addSubview:minScoreLabel];
        [self addSubview:leftButton];
        [self addSubview:rightButton];
        [self addSubview:_lineView];

        [maxLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(maxView.left);
            make.centerY.equalTo(maxView);
        }];

        [aveLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(maxLabel);
            make.centerY.equalTo(aveView);
        }];

        [minLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(maxLabel);
            make.centerY.equalTo(minView);
        }];

        [self resetLayout];
    }
    return self;
}

- (UILabel *)scoreLabelWithTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = colorDeepGray;
    label.text = title;
    return label;
}

- (void)buttonClick:(UIButton *)button{
    if (button == leftButton) {
        NewsDetailViewController *detail = [[NewsDetailViewController alloc] init];
        detail.ID = _model.reportId ;
        detail.invest = YES;

        [self.parentVC.navigationController pushViewController:detail animated:YES];
    }
}

- (void)setModel:(OverviewScoreViewModel *)model{

    _model = model;

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"综合得分："];
    att.yy_color = colorBlack;
    att.yy_font = [UIFont systemFontOfSize:PT_FROM_PX(20)];

    if (model.score) {
        NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:model.score];
        scoreAtt.lh_font = [UIFont systemFontOfSize:PT_FROM_PX(25)] ;
        scoreAtt.yy_color = colorOrangeRed;
        [att appendAttributedString:scoreAtt];

    }
    scoreLabel.attributedText = att;

    __weak __typeof(maxScoreLabel) weakmaxScoreLabel = maxScoreLabel;
    __weak __typeof(aveScoreLabel) weakaveScoreLabel = aveScoreLabel;
    __weak __typeof(minScoreLabel) weakminScoreLabel = minScoreLabel;
    [maxView setProress:^(CGFloat progress) {
        weakmaxScoreLabel.text = [NSString stringWithFormat:@"%0.1f",[model.maxScore floatValue] * progress];
    }];
    [maxView setFinished:^{
        weakmaxScoreLabel.text = model.maxScore;
    }];
    [aveView setProress:^(CGFloat progress) {
        weakaveScoreLabel.text = [NSString stringWithFormat:@"%0.1f",[model.avgScore floatValue] * progress];
    }];
    [aveView setFinished:^{
        weakaveScoreLabel.text = model.avgScore;
    }];
    [minView setProress:^(CGFloat progress) {
        weakminScoreLabel.text = [NSString stringWithFormat:@"%0.1f",[model.minScore floatValue] * progress];
    }];
    [minView setFinished:^{
        weakminScoreLabel.text = model.minScore;
    }];
    [maxView setProgress:[model.maxScore floatValue]/100.0 animar:YES];
    [aveView setProgress:[model.avgScore floatValue]/100.0 animar:YES];
    [minView setProgress:[model.minScore floatValue]/100.0 animar:YES];


    if (model.report) {
        leftButton.enabled = YES;
        leftButton.backgroundColor = colorYellow;
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)resetLayout{

    maxView.lh_left = 68;
    maxView.lh_top = scoreLabel.lh_bottom + 20;
    maxView.lh_size = CGSizeMake(WIDTH - maxView.lh_left - 40, 10);

    aveView.lh_left = maxView.lh_left;
    aveView.lh_top = maxView.lh_bottom + 20;
    aveView.lh_size = maxView.lh_size;

    minView.lh_left = maxView.lh_left;
    minView.lh_top = aveView.lh_bottom + 20;
    minView.lh_size = maxView.lh_size;

    maxScoreLabel.lh_size = CGSizeMake(60, 20);
    maxScoreLabel.lh_left = maxView.lh_right + 10;
    maxScoreLabel.lh_centerY = maxView.lh_centerY;

    aveScoreLabel.lh_size = maxScoreLabel.lh_size;
    aveScoreLabel.lh_left = maxScoreLabel.lh_left;
    aveScoreLabel.lh_centerY = aveView.lh_centerY;

    minScoreLabel.lh_size = maxScoreLabel.lh_size;
    minScoreLabel.lh_left = maxScoreLabel.lh_left;
    minScoreLabel.lh_centerY = minView.lh_centerY;

    leftButton.lh_size = CGSizeMake(130, 38.5);
    leftButton.lh_top = minView.lh_bottom + 20;
    leftButton.lh_centerX = WIDTH/2;

    rightButton.lh_size = leftButton.lh_size;
    rightButton.lh_top = leftButton.lh_top;
    rightButton.lh_left = WIDTH/2 + 10;
    rightButton.hidden = YES;
    
    _lineView.lh_size = CGSizeMake(WIDTH, 5);
    _lineView.lh_left = 0;
    _lineView.lh_top = leftButton.lh_bottom + 10;
    
    self.lh_width = WIDTH;
    self.lh_height = _lineView.lh_bottom;
}
@end

