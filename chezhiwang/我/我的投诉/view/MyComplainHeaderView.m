
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
        _textColor = [UIColor whiteColor];

         self.backgroundColor = [UIColor whiteColor];
        _backColor = [UIColor lightGrayColor];
        _lightBackColor = [UIColor blueColor];
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
    CGContextSetStrokeColorWithColor(context, _backColor.CGColor);
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextStrokePath(context);

    CGFloat textWidth = sqrtf(self.radius*self.radius/2);
    NSArray *points = [self getPointsWithSize:rect.size.width number:_titles.count radius:_radius];
    for (int i = 0; i < _titles.count; i ++) {

        NSString *text = _titles[i];
        CGFloat pointx = [points[i] floatValue];
        CGRect frame = CGRectMake(pointx-textWidth, 0, textWidth*2,rect.size.height);

        CGSize size = [self sizeWith:text size:CGSizeMake(textWidth*2, rect.size.height)];
        CGRect drawFrame  = [self centreFrame:frame size:size];
        if (i == _current) {
            CGContextSetFillColorWithColor(context, _lightBackColor.CGColor);
        }else{
            CGContextSetFillColorWithColor(context,_backColor.CGColor);
        }
        CGContextAddArc(context, pointx, rect.size.height/2, _radius, 0, 2*M_PI, 1);
        CGContextFillPath(context);

        [text drawInRect:drawFrame withAttributes:@{NSFontAttributeName:_font,NSForegroundColorAttributeName:_textColor}];
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
