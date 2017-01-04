//
//  LHSegmentView.m
//  chezhiwang
//
//  Created by bangong on 16/12/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHSegmentView.h"

@interface LHSegmentView()
{
    UIScrollView *_bottomScrollView;
    UIScrollView *_topScrollView;
    NSInteger _current;
    NSInteger _toIndex;
    CGSize contentSize;
}

@property (nonatomic,strong) NSArray<__kindof NSString *> *titles;
@property (nonatomic,strong) NSMutableArray<__kindof UILabel *> *labelValues;

@end

@implementation LHSegmentView


+ (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<__kindof NSString *> *)titles textColor:(UIColor *)textColor highlightColor:(UIColor *)highlightColor{

    LHSegmentView *view = [[LHSegmentView alloc] initWithFrame:frame];
    view.textColor = textColor;
    view.highlightColor = highlightColor;
    view.titles = titles;
    [view configUI];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        self.textColor = [UIColor blueColor];
        self.highlightColor = [UIColor redColor];
    }
    return self;
}

- (CGSize)contentSize{
    return  contentSize;
}

- (void)configUI{


    self.labelValues = [NSMutableArray array];


    _bottomScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _topScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

    [self addSubview:_bottomScrollView];
    [self addSubview:_topScrollView];


    [self createLabels:_bottomScrollView titles:self.titles isHighlight:YES];
    [self createLabels:_topScrollView titles:self.titles isHighlight:NO];
}

- (void)createLabels:(UIScrollView *)scrollView titles:(NSArray<NSString *> *)titles isHighlight:(BOOL)isHighlight{
    scrollView.showsHorizontalScrollIndicator = NO;
    CGFloat firstX = 0;
    if (!isHighlight) {
        [self.labelValues removeAllObjects];
    }
    for (int i = 0; i < titles.count; i ++) {

        UILabel *label = [[UILabel alloc] init];
        label.font = [self.font copy];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        if (isHighlight) {
            label.textColor = self.highlightColor;

        }else{
            label.textColor = [self.textColor copy];
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)]];

            [self.labelValues addObject:label];

        }

        [scrollView addSubview:label];

        [label sizeToFit];
        label.lh_height = self.lh_height;
        label.lh_top = 0;
        label.lh_left = firstX;
        label.lh_width += 20;
        firstX = label.lh_right;

        contentSize = CGSizeMake(label.lh_right, 0);
        
        if (i == 0) {
            _current = 0;
            [self clipView:label.frame];
        }

    }
}

- (void)labelTap:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    NSInteger index = [self.labelValues indexOfObject:label];
    _toIndex = index;
    if (self.setScrollClosure) {
        self.setScrollClosure(index);
    }else{
        [self scrollTo:index animer:NO];
    }
}

- (void)scrollTo:(NSInteger)toIndex from:(NSInteger)fromIndex progress:(CGFloat)progress{

    if (toIndex < 0 || toIndex > self.labelValues.count - 1) {
        return;
    }
    if (fromIndex < 0 || fromIndex > self.labelValues.count - 1) {
        return;
    }

    CGRect toRect = self.labelValues[toIndex].frame;
    CGRect fromRect  = self.labelValues[fromIndex].frame;

    CGRect moveRect = fromRect;
    CGFloat width = toRect.size.width - fromRect.size.width;

    moveRect.size.width += width * fabs(progress);
    moveRect.origin.x += progress * fabs(toRect.origin.x - fromRect.origin.x);

    [self clipView:moveRect];
}


- (void)progress:(CGFloat)progress{

    [self scrollTo:_toIndex from:_current progress:progress];
}

- (void)resetToIndex:(CGFloat)progress{
    if (progress > 0) {
        _toIndex = _current + 1;
    }else if (progress < 0){
        _toIndex = _current - 1;
    }

}

- (void)scrollTo:(NSInteger)current animer:(BOOL)animer{
    if (current < 0 || current > self.labelValues.count - 1) {
        return;
    }
    if (!animer) {
        [self clipView:self.labelValues[current].frame];

    }else{
        ///
//        CGRect rect = self.labelValues[_current].frame;
//        CGRect toRect = self.labelValues[current].frame;

    }

    _current = current;

}



//切割高亮区域
- (void)clipView:(CGRect)frame{
    _topScrollView.backgroundColor = [UIColor whiteColor];
    CGFloat cornerRadius = frame.size.height/2;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.opacity = 1;
    _topScrollView.layer.mask = maskLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
