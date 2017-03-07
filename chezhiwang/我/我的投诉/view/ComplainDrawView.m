
//
//  ComplainDrawView.m
//  chezhiwang
//
//  Created by bangong on 16/12/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainDrawView.h"


@implementation ButtonView

- (void)setTitles:(NSArray *)titles{

    _titles = titles;

    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *button = [LHController createButtnFram:CGRectMake(120*i, 0, 80, 30) Target:self Action:@selector(buttonClick:) Font:15 Text:_titles[i]];
        [self addSubview:button];
        if (i == _titles.count-1) {
            self.bounds = CGRectMake(0, 0, button.frame.origin.x+button.frame.size.width, button.frame.size.height);
        }
    }
    if (titles == nil || titles.count == 0) {
        self.bounds = CGRectZero;
    }
}

- (void)buttonClick:(UIButton *)btn{

    if (self.click) {
        self.click(btn.titleLabel.text);
    }
}

@end

#pragma mark - ListModel
@implementation ListModel

- (instancetype)initWithTextFrame:(CGRect)textFrame attribute:(NSAttributedString *)attribute{
    if (self = [super init]) {
        _textFrame = textFrame;
        _attribute = attribute;
    }
    return self;
}

@end

#pragma mark - ComplainDrawView
@implementation ComplainDrawView
{
    CGFloat drawLeft;//竖线中心左距离
    CGFloat _radius;//圆圈半径
    CGFloat _py;//圆圈y轴偏移

    UIColor *_lineColor;//线条颜色
    UIColor *_lightLineColor;//线条高亮颜色
    UIColor *_textColor;//文字颜色
    UIColor *_lightTextColor;//文字高亮颜色
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _leftSpace = 40;
        _rightSpace = 10;
        _lineSpace = 10;
        _isDrawCircle = YES;

        drawLeft = 15;
        _radius = 4;
        _py = 2;

        _lineColor = RGB_color(210, 210, 210, 1);
        _lightLineColor = RGB_color(27, 188, 157, 1);

        _textColor = RGB_color(153, 153, 153, 1);
        _lightTextColor = RGB_color(68, 68, 68, 1);

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setListModels:(NSArray *)listModels{
    _listModels = listModels;

     CGRect tempRect;
    for (int i = 0; i < listModels.count; i ++) {

        ListModel *model = listModels[i];

        CGFloat width = self.lh_width - _leftSpace - _rightSpace;
        CGSize size = [model.attribute sizeWithSize:CGSizeMake(width, CGFLOAT_MAX)];
        CGRect rect = CGRectMake(_leftSpace, 0, size.width, size.height);
        if (i == 0) {
            rect.origin.y = _lineSpace;
        }else{
            rect.origin.y = tempRect.origin.y+tempRect.size.height+_lineSpace*2;
        }
        model.textFrame = rect;

        tempRect = rect;
    }

    _listModels = listModels;

    self.lh_height = tempRect.origin.y+tempRect.size.height+_lineSpace;
    [self setNeedsDisplay];
}


- (void)setSteps:(NSArray *)steps{
    CGRect tempRect;

    NSMutableArray  *listModels = [NSMutableArray array];
    
    for (int i = 0; i < steps.count; i ++) {
        NSDictionary *dict = steps[i];
        NSString *text = [NSString stringWithFormat:@"%@\n%@",dict[@"step"],dict[@"time"]];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
        attribute.lh_font = [UIFont systemFontOfSize:13];
        if (i == steps.count - 1) {
            attribute.lh_color = _lightTextColor;
        }else{
            attribute.lh_color = _textColor;
        }
        attribute.lh_paragraphSpacing = 5;

        CGFloat width = self.lh_width - _leftSpace - _rightSpace;
        CGSize size = [attribute boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGRect rect = CGRectMake(_leftSpace, 0, size.width, size.height);
        if (i == 0) {
            rect.origin.y = _lineSpace;
        }else{
            rect.origin.y = tempRect.origin.y+tempRect.size.height+_lineSpace*2;
        }

        ListModel *model = [[ListModel alloc] init];
        model.attribute = attribute;
        model.textFrame = rect;
        [listModels addObject:model];
        tempRect = rect;
    }
    _listModels = listModels;
    
    self.lh_height = tempRect.origin.y+tempRect.size.height+_lineSpace;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, 0.6);

    if (_listModels.count > 1 && _isDrawCircle) {
        ListModel *model = _listModels[0];

        CGContextMoveToPoint(context, drawLeft, model.textFrame.origin.y+_radius);

        model = [_listModels lastObject];

        CGContextAddLineToPoint(context, drawLeft, model.textFrame.origin.y+_radius);

        CGContextStrokePath(context);
    }

    for (int i = 0; i < _listModels.count; i ++) {

        if (i == 0) {
            //顶部线条
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, rect.size.width, 0);
            CGContextStrokePath(context);
        }
        
        ListModel *model = _listModels[i];
        [model.attribute drawInRect:model.textFrame];

        if (i < _listModels.count-1) {
            CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
            CGContextSetFillColorWithColor(context, _lineColor.CGColor);
            //划线

            CGFloat pty = model.textFrame.origin.y+model.textFrame.size.height+_lineSpace;
            CGContextMoveToPoint(context, model.textFrame.origin.x, pty);
            CGContextAddLineToPoint(context, rect.size.width-_rightSpace, pty);
            CGContextStrokePath(context);

            //画圆圈
            if (_isDrawCircle) {
                CGContextAddArc(context, drawLeft, model.textFrame.origin.y + _radius + _py, _radius, 0, 2*M_PI, 1);
                CGContextFillPath(context);
            }

        }else{
            //底部线条
            CGContextSetStrokeColorWithColor(context, RGB_color(0, 55, 44, 1).CGColor);
            CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
            CGContextMoveToPoint(context, 0, rect.size.height);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextStrokePath(context);

            //高亮圆圈
            if (_isDrawCircle) {
                CGContextSetFillColorWithColor(context, _lightLineColor.CGColor);
                CGContextSetStrokeColorWithColor(context, _lightLineColor.CGColor);

                CGContextAddArc(context, drawLeft, model.textFrame.origin.y + _radius  + _py +2, _radius+2, 0, 2*M_PI, 1);
                CGContextStrokePath(context);

                CGContextAddArc(context, drawLeft, model.textFrame.origin.y + _radius + _py + 2, _radius, 0, 2*M_PI, 1);
                CGContextFillPath(context);
            }

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
