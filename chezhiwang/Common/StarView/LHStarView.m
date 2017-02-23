//
//  LHStarView.m
//  chezhiwang
//
//  Created by bangong on 17/2/6.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import "LHStarView.h"

@implementation LHStarView
{
    //背景图
   // NSArray *backgroundImageViews;
    //前景图
    NSArray *foregroundImageViews;

    CGFloat _star;

    BOOL _draw;
    CGFloat starWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size = CGSizeMake(100, 20);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame draw:(BOOL)draw{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (draw) {
            _draw = draw;
            _highlightColor = colorYellow;
            _color = colorYellow;
             [self setStarWidth:15 space:3];
        }else{
            [self createImageView];
        }
    }
    return self;
}


- (void)createImageView{

    NSMutableArray *foreArray = [NSMutableArray array];
    for (int i = 0; i < 5; i ++) {
        UIImage *backImage = [UIImage imageNamed:@"starBackground"];
        UIImage *foreImage = [UIImage imageNamed:@"starForeground"];

        UIImageView *backImageView = [[UIImageView alloc] initWithImage:backImage];
        UIImageView *foreImageView = [[UIImageView alloc] initWithImage:foreImage];
        CGRect rect = CGRectMake(i * (backImage.size.width + 4), 0, backImage.size.width, backImage.size.height);
        backImageView.frame = rect;
        foreImageView.frame = rect;
        [self addSubview:backImageView];
        [self addSubview:foreImageView];

        [foreArray addObject:foreImageView];
        if (i == 4) {

            self.frame = CGRectMake(0, 0, CGRectGetMaxX(rect), rect.size.height);
        }
    }
    foregroundImageViews = foreArray;
}


- (void)setStar:(CGFloat)star{
    _star = star;
    if (_draw) {
        [self setNeedsDisplay];
    }else{
        [self clipView:star];
    }
}

- (void)setStarWidth:(CGFloat)width space:(CGFloat)space{
    CGRect rect = self.frame;
    rect.size.height = width * 2 + 1;
    rect.size.width = width * 5 + space * 4;
    self.frame = rect;
}

//切割前景图
- (void)clipView:(CGFloat)star{

    for (int i = 0; i < foregroundImageViews.count; i ++) {
        UIImageView *imageview = foregroundImageViews[i];
        imageview.layer.mask = nil;
        if (star - i > 0) {
            imageview.hidden = NO;
            if (star - i < 1) {
                imageview.layer.mask = [self shapeLayarWithFrame:imageview.bounds scale:star - i];
            }
        }else{
            imageview.hidden = YES;
        }
    }
}


- (CAShapeLayer *)shapeLayarWithFrame:(CGRect)frame scale:(CGFloat)scale{
    scale = scale > 1?1:scale;
    frame.size.width *= scale;

    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:frame];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.opacity = 1;
    return maskLayer;
}

//绘制⭐️
-(void)drawRect:(CGRect)rect
{
    if (!_draw) {
        [super drawRect:rect];
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0.5);

    //绘制五角星
    int num = 5;
    CGFloat space = 4;
    CGFloat width = (rect.size.width - space * (num - 1)) / num;
    if (width > rect.size.height/2) {
        width = rect.size.height/2;
        space = (rect.size.width - width * num) / (num -  1);
    }

    for (int i = 0; i < num; i++) {

        CGFloat scale = _star - i;
        //添加五角星的路径
        CGFloat x = (space + width) * i + width/2;
        [self drawStrokeFill:ctx point:CGPointMake(x, rect.size.height/2) size:width/2 fillScale:scale];
    }
}

- (void)drawStrokeFill:(CGContextRef)context point:(CGPoint)point size:(CGFloat)size fillScale:(CGFloat)scale{
    int n = 5;
    CGFloat dig = 2 * M_PI /(n * 2);
    // 移动到指定点
    CGContextSetStrokeColorWithColor(context, _color.CGColor);
    CGContextSetFillColorWithColor(context, _highlightColor.CGColor);
    for(int i = 0 ; i <= n*2 ; i++)
    {
        double sc = (i + 2) * dig;


        CGFloat length = i%2==0?size:size - size/2 ;
        CGFloat cx = sin(sc) * length + point.x;
        CGFloat cy = -cos(sc) * length + point.y;

        if (i == 0) {
            CGContextMoveToPoint(context , cx , cy);
        }else {
            // 绘制从当前点连接到指定点的线条
            CGContextAddLineToPoint(context , cx , cy);
        }
    }
    CGContextStrokePath(context);


    if (scale > 0) {
        CGContextSetStrokeColorWithColor(context, _highlightColor.CGColor);
        CGMutablePathRef mpath = CGPathCreateMutable();
        for(int i = 0 ; i <= n*2 ; i++)
        {

            double sc = (i + 2) * dig;

            CGFloat length = i%2==0?size:size - size/2;

            CGFloat cx = sin(sc) * length + point.x;
            CGFloat cy = -cos(sc) * length + point.y;

            if (i == 0) {
                CGPathMoveToPoint(mpath, nil, cx, cy);
            }else {
                // 绘制从当前点连接到指定点的线条
                CGPathAddLineToPoint(mpath, nil, cx, cy);
            }

        }
        if (scale < 1) {
            CGRect pathRect = CGPathGetBoundingBox(mpath);
            CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
            CGPoint endPoint = CGPointMake(CGRectGetMinX(pathRect) + CGRectGetWidth(pathRect) * scale, CGRectGetMinY(pathRect));

            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGFloat locations[] = { 0.0, 1.0 };

            NSArray *colors = @[(__bridge id)_highlightColor.CGColor, (__bridge id) _highlightColor.CGColor];
            CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

            CGContextSaveGState(context);
            CGContextAddPath(context, mpath);
            CGContextClip(context);
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
            CGContextRestoreGState(context);

            CGGradientRelease(gradient);
            CGColorSpaceRelease(colorSpace);

        }else{

            CGContextAddPath(context, mpath);
            CGContextDrawPath(context, kCGPathFill);
        }
        CFRelease(mpath);
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
