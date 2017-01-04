//
//  OverviewScoreView.m
//  chezhiwang
//
//  Created by bangong on 16/12/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewScoreView.h"

#pragma mark - 模型
@implementation OverviewViewCotextViewModel
- (instancetype)initWithName:(NSString *)name value:(NSString *)vule color:(UIColor *)color{
    if (self = [super init]) {
        _name = name;
        _value = vule;
        _color = color;
    }
    return self;
}
@end

#pragma mark - k线图
@implementation OverviewViewCotextView
{
    CGFloat  _spanLength;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        _origin = CGPointMake(50, 20);
        _minValue = 0;
        _maxValue = 100;
        _spanNumber = 10;
    }
    return self;
}

- (void)setKlineArray:(NSArray<OverviewViewCotextViewModel *> *)KlineArray{
    _KlineArray = KlineArray;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();// 获取绘图上下文
    [self drawCoordinateSystem:context rect:rect];
    [self drawKline:context rect:rect];
}

- (void)drawCoordinateSystem:(CGContextRef)context rect:(CGRect)rect{

    CGPoint origin = CGPointMake(_origin.x, rect.size.height - _origin.y);
    CGContextSetStrokeColorWithColor(context, colorLineGray.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, origin.x, 0);
    CGContextAddLineToPoint(context, origin.x, origin.y);
    CGContextAddLineToPoint(context, rect.size.width, origin.y);
    CGContextDrawPath(context, kCGPathStroke);


    CGFloat width = (rect.size.width-_origin.x)/(_spanNumber+1);
    _spanLength = width * _spanNumber;
    for (int i = 0; i <= _spanNumber; i ++) {
        if (i > 0) {
            CGContextSetStrokeColorWithColor(context, colorLineGray.CGColor);
            CGContextMoveToPoint(context, i*width+origin.x, origin.y);
            CGContextAddLineToPoint(context, i*width+origin.x, origin.y - 5);
            CGContextDrawPath(context, kCGPathStroke);
        }

        CGPoint point = CGPointMake(i*width+origin.x, origin.y);
        NSString *str = [NSString stringWithFormat:@"%0.f",i*(_maxValue - _minValue)/_spanNumber];
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PT_FROM_PX(15)],NSForegroundColorAttributeName:colorLightGray}];
        CGFloat textWidth = [att boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics context:nil].size.width;
        point.x -= textWidth/2;
        [att drawAtPoint:point];
    }
}

- (void)drawKline:(CGContextRef)context rect:(CGRect)rect{

    CGPoint origin = CGPointMake(_origin.x, rect.size.height - _origin.y);
    for (int i = 0; i < _KlineArray.count; i ++) {
        OverviewViewCotextViewModel *model = _KlineArray[i];
        CGContextSetFillColorWithColor(context, model.color.CGColor);
        CGRect frame = CGRectMake(origin.x, origin.y - i * 30 - 40, model.value.floatValue/100*_spanLength, 18);
        CGContextAddRect(context, frame);
        CGContextDrawPath(context, kCGPathFill);

        CGPoint point = frame.origin;
        NSAttributedString *att = [[NSAttributedString alloc] initWithString:model.name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:colorDeepGray}];
        CGSize size = [att boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics context:nil].size;
        point.x = origin.x - size.width-5;
        point.y -= att.yy_font.descender;
        [att drawAtPoint:point];
        if (model.value) {
            att = [[NSAttributedString alloc] initWithString:model.value attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PT_FROM_PX(18)],NSForegroundColorAttributeName:model.color}];
            size = [att boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesDeviceMetrics context:nil].size;
            point.x = frame.origin.x + frame.size.width + 5;
            point.y = frame.origin.y - att.yy_font.descender;
            [att drawAtPoint:point];
        }
    }
}
@end


#pragma mark - 综合得分
@implementation OverviewScoreView
{
    UILabel *scoreLabel;
    OverviewViewCotextView *coretextView;
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

        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, WIDTH, 1)];
        lineView.backgroundColor = colorLineGray;

        coretextView = [[OverviewViewCotextView alloc] initWithFrame:CGRectZero];

        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"查看调查结果" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
        leftButton.backgroundColor = colorBackGround;
        leftButton.layer.cornerRadius = 3;
        leftButton.layer.masksToBounds = YES;
        [leftButton setTitleColor:colorLightGray forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

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
        [self addSubview:lineView];
        [self addSubview:coretextView];
        [self addSubview:leftButton];
        [self addSubview:rightButton];
        [self addSubview:_lineView];

        [self resetLayout];
        [self setData];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button{

}

- (void)setData{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"综合得分：98"];
    [att yy_setColor:colorBlack range:NSMakeRange(0, 5)];
    [att yy_setColor:colorOrangeRed range:NSMakeRange(5, 2)];
    [att yy_setFont:[UIFont systemFontOfSize:PT_FROM_PX(25)] range:NSMakeRange(5, 2)];
    scoreLabel.attributedText = att;

    OverviewViewCotextViewModel *model1 = [[OverviewViewCotextViewModel alloc] initWithName:@"平均分：" value:@"80" color:colorOrangeRed];
    OverviewViewCotextViewModel *model2 = [[OverviewViewCotextViewModel alloc] initWithName:@"最低分：" value:@"50" color:colorLightBlue];
    OverviewViewCotextViewModel *model3 = [[OverviewViewCotextViewModel alloc] initWithName:@"最高分：" value:@"100" color:colorLightBlue];
    coretextView.KlineArray = @[model1,model2,model3];
}


- (void)resetLayout{

    coretextView.lh_left = 0;
    coretextView.lh_bottom = scoreLabel.lh_bottom + 20;
    coretextView.lh_width = WIDTH;
    coretextView.lh_height = 140;

    leftButton.lh_size = CGSizeMake(130, 38.5);
    leftButton.lh_top = coretextView.lh_bottom + 10;
    leftButton.lh_right = WIDTH/2 - 10;

    rightButton.lh_size = leftButton.lh_size;
    rightButton.lh_top = leftButton.lh_top;
    rightButton.lh_left = WIDTH/2 + 10;


    _lineView.lh_size = CGSizeMake(WIDTH, 5);
    _lineView.lh_left = 0;
    _lineView.lh_top = rightButton.lh_bottom + 10;
    
    self.lh_width = WIDTH;
    self.lh_height = _lineView.lh_bottom;
}
@end

