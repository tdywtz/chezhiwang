
//
//  MyComplainHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/8/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyComplainHeaderView.h"

@implementation MyComplainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 20;
        _font = [UIFont systemFontOfSize:12];
        _textColor = [UIColor lightGrayColor];
        _lightTextColor =  RGB_color(0, 192, 155, 1);
        _lineColor = RGB_color(220, 220, 220, 1);
        _lightLineColor = RGB_color(0, 192, 155, 1);
        

         self.backgroundColor = [UIColor whiteColor];

        _titles =  @[@"信息审核",@"厂家受理",@"处理反馈",@"用户评分",@"完成"];
    }
    return self;
}


- (void)setCurrent:(NSInteger)current{
    _current = current;
    [self setNeedsDisplay];
}



- (NSArray *)getPointsWithSize:(CGFloat)width number:(NSInteger)number radius:(CGFloat)radius{
    if (radius*2*number > width) {
        return nil;
    }

    CGFloat space = (width-radius*2)/(number-1);
    NSMutableArray *marr = [[NSMutableArray alloc] init];
    for (int i = 0; i < number; i ++) {
        [marr addObject:[NSNumber numberWithFloat:radius+space*i]];
    }
    return [marr copy];
}

- (CGSize)sizeWith:(NSString *)text size:(CGSize)size{
   return  [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_font} context:nil].size;
}

- (CGRect)centreFrame:(CGRect)frame size:(CGSize)size{
    CGRect rect = frame;
    rect.origin.x += (frame.size.width - size.width)/2;
    rect.origin.y += (frame.size.height - size.height)/2;
    return rect;
}

- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    //取平方根
    CGFloat textWidth = sqrtf(self.radius*self.radius/2);
    NSArray *points = [self getPointsWithSize:rect.size.width-2 number:_titles.count radius:_radius];
    for (int i = 0; i < _titles.count; i ++) {

        NSString *text = _titles[i];
        CGFloat pointx = [points[i] floatValue]+1;
        CGRect frame = CGRectMake(pointx-textWidth, 0, textWidth*2,rect.size.height);

        CGSize size = [self sizeWith:text size:CGSizeMake(textWidth*2, rect.size.height)];
        CGRect drawFrame  = [self centreFrame:frame size:size];
        UIColor *textColor = _textColor;

        if (i < _current) {
            textColor =_lightTextColor;
            CGContextSetStrokeColorWithColor(context, _lightLineColor.CGColor);
        }else{
            CGContextSetStrokeColorWithColor(context,_lineColor.CGColor);
        }
        CGContextAddArc(context, pointx, rect.size.height/2, _radius, 0, 2*M_PI, 1);
        CGContextStrokePath(context);

        [text drawInRect:drawFrame withAttributes:@{NSFontAttributeName:_font,NSForegroundColorAttributeName:textColor}];

        if (i < _titles.count-1 ) {
            if (i < _current) {
                 CGContextSetStrokeColorWithColor(context, _lightLineColor.CGColor);
            }else{
                CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
            }

            CGPoint benginPoint = CGPointMake(pointx+3+_radius,rect.size.height/2);
            CGPoint endPoint = CGPointMake( [points[i+1] floatValue]-2-_radius, rect.size.height/2);

            CGFloat tempLeight = (endPoint.x - benginPoint.x - 25);
            if (tempLeight > 0) {
                benginPoint.x += tempLeight/2.0;
                endPoint.x -= tempLeight/2.0;
            }
            CGFloat radius = 3;
            CGFloat leight = 12;

            CGContextMoveToPoint(context, benginPoint.x, benginPoint.y+radius);
            CGContextAddLineToPoint(context, endPoint.x-leight, benginPoint.y+radius);
            CGContextAddLineToPoint(context, endPoint.x-leight, benginPoint.y+radius*2);
            CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            CGContextAddLineToPoint(context, endPoint.x-leight, benginPoint.y-radius*2);
            CGContextAddLineToPoint(context, endPoint.x-leight, benginPoint.y-radius);
            CGContextAddLineToPoint(context, benginPoint.x, benginPoint.y-radius);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathStroke);

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
