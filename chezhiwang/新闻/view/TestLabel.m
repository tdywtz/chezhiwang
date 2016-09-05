//
//  TestLabel.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TestLabel.h"

@implementation TestLabel

-(void)setDraw_x:(CGFloat)draw_x{
    if (_draw_x != draw_x) {
        _draw_x = draw_x;
        // [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
     rect.size.height -= 6;
     rect.size.width -= 4;
    //框
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//    CGContextTranslateCTM(context, -self.textInsets.left, rect.size.height+self.textInsets.top);
  //  CGContextScaleCTM(context, 1.0, -1.0);

   //CGContextSetRGBStrokeColor(context, 255/255.0,  147/255.0, 4/255.0, 1);//线条颜色
    CGContextSetStrokeColorWithColor(context, RGB_color(231, 212, 183, 1).CGColor);
    //CGContextSetRGBFillColor(context, 0.2, 0.3, 0.8, 0.5);
    //CGContextMoveToPoint(context, 1, 10);
    CGContextMoveToPoint(context, self.draw_x-5, 10);
    CGContextAddLineToPoint(context, self.draw_x, 5);
    CGContextAddLineToPoint(context, self.draw_x+5, 10);
    CGContextAddArcToPoint(context, rect.size.width-1, 10, rect.size.width-1, rect.size.height-1, self.cornerRadius);
    CGContextAddArcToPoint(context, rect.size.width-1, rect.size.height-1, 1, rect.size.height-1, self.cornerRadius);
    CGContextAddArcToPoint(context, 1, rect.size.height-1, 1, 10, self.cornerRadius);
    CGContextAddArcToPoint(context, 1, 10, self.draw_x-5, 10, self.cornerRadius);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathStroke);

    //三角
    CGContextRef jiantou = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(jiantou, 220/255.0,  220/255.0, 220/255.0, 1);//线条颜色
    CGFloat tox = rect.size.width-self.textInsets.right+10;
    CGFloat cy = rect.size.height/2+5;
    CGContextMoveToPoint(jiantou, tox, cy-8);
    CGContextAddLineToPoint(jiantou, tox+7, cy);
    CGContextAddLineToPoint(jiantou, tox, cy+8);
    CGContextStrokePath(jiantou);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
