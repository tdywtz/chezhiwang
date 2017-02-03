//
//  LHToolScrollView.m
//  autoService
//
//  Created by bangong on 16/5/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHToolScrollView.h"



@implementation LHToolButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setScale:0];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setTitleColor:colorBlack forState:UIControlStateNormal];
        [self setTitleColor:colorYellow forState:UIControlStateSelected];
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    //
    //    //    NSLog(@"scale is %f", _scale);
    //    [self setTitleColor:[UIColor colorWithRed:(scale * (221.0 - 104.0) + 104.0)/255 green:(scale * (50.0 - 104.0) + 104.0)/255 blue:(scale * (55.0 - 104.0) + 104.0)/255 alpha:1] forState:UIControlStateNormal];
    //    //    NSLog(@"\ncolor is %@", self.titleLabel.textColor);
    //    //self.titleLabel.font = [UIFont systemFontOfSize:14 * (1 + 0.3 * scale)];
    //    self.transform = CGAffineTransformMakeScale(1+scale/5, 1+scale/5);
}

-(void)setScale:(CGFloat)scale anima:(BOOL)boll{
    _scale = scale;

    //    if (boll) {
    //        __weak __typeof(self)weakSelf = self;
    //        [UIView animateWithDuration:0.3 animations:^{
    //            [weakSelf setTitleColor:[UIColor colorWithRed:(scale * (221.0 - 104.0) + 104.0)/255 green:(scale * (50.0 - 104.0) + 104.0)/255 blue:(scale * (55.0 - 104.0) + 104.0)/255 alpha:1] forState:UIControlStateNormal];
    //            weakSelf.transform = CGAffineTransformMakeScale(1+scale/5, 1+scale/5);
    //
    //        }];
    //    }
}

@end

#pragma mark -

@interface LHToolChooseView : UIView

@end

@implementation LHToolChooseView


@end

#pragma mark - LHToolScrollView
@interface LHToolScrollView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *moveView;//滑动条
@property (nonatomic,strong) NSMutableArray<__kindof LHToolButton *> *buttons;
@property (nonatomic,strong) LHToolChooseView *chooseView;//选择

@end

@implementation LHToolScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;



        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = colorBackGround;

        [self addSubview:self.scrollView];
        [self addSubview:lineView];

        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 4, 0));
        }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(4);
        }];


        self.contentView = [[UIView alloc] init];
        [self.scrollView addSubview:self.contentView];

        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
            make.height.equalTo(frame.size.height-4);
        }];

        self.moveView = [[UIView alloc] init];
        self.moveView.backgroundColor = colorYellow;
        [self.contentView addSubview:self.moveView];

//
//        UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [chooseButton addTarget:self action:@selector(chooseClick:) forControlEvents:UIControlEventTouchUpInside];
//        chooseButton.backgroundColor = [UIColor redColor];
//
//        UIView *leftView = [[UIView alloc] init];
//        UIView *rightView = [[UIView alloc] init];

      //  [self addSubview:chooseButton];
//        [self addSubview:leftView];
//        [self addSubview:rightView];

//        [chooseButton makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(0);
//            make.top.equalTo(0);
//            make.size.equalTo(CGSizeMake(40, 40));
//        }];

//        [leftView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(0);
//            make.left.equalTo(0);
//            make.size.equalTo(CGSizeMake(10, frame.size.height-4));
//        }];
//
//        [rightView makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(0);
//            make.right.equalTo(0);
//            make.size.equalTo(CGSizeMake(10, frame.size.height-4));
//        }];
//
//        CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//        gradientLayer.colors = @[(__bridge id)RGB_color(255, 255, 255, 1).CGColor,(__bridge id)RGB_color(255, 255, 255, 0.6).CGColor];
//        gradientLayer.startPoint = CGPointMake(0, 0.5);
//        gradientLayer.endPoint = CGPointMake(1, 0.5);
//        gradientLayer.frame = CGRectMake(0, 0, 10, frame.size.height-4);
//        [leftView.layer addSublayer:gradientLayer];
//
//        CAGradientLayer *rightGradientLayer = [[CAGradientLayer alloc] init];
//        rightGradientLayer.colors = @[(__bridge id)RGB_color(255, 255, 255, 1).CGColor,(__bridge id)RGB_color(255, 255, 255, 0.6).CGColor];
//        rightGradientLayer.startPoint = CGPointMake(1, 0.5);
//        rightGradientLayer.endPoint = CGPointMake(0, 0.5);
//        rightGradientLayer.frame = CGRectMake(0, 0, 10, frame.size.height-4);
//        [rightView.layer addSublayer:rightGradientLayer];


    }
    return self;
}

//弹出选择页面
- (void)chooseClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.LHDelegate respondsToSelector:@selector(chooseButtonClick:)]) {
        [self.LHDelegate chooseButtonClick:btn.selected];
    }
}

-(void)createButtons{
    [self.buttons removeAllObjects];
    for (UIView *view in self.contentView.subviews) {
        if (view != self.moveView) {
               [view removeFromSuperview];
        }
    }
    LHToolButton *temp = nil;
    for (int i = 0; i < _titles.count; i ++) {
        LHToolButton *button = [[LHToolButton alloc] init];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(butonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        }
        [self.contentView addSubview:button];
        if (temp == nil) {
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.centerY.equalTo(0);
            }];
        }else{
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(temp.right).offset(25);
                make.centerY.equalTo(0);
            }];
        }
        //加入数组
        [self.buttons addObject:button];
        temp = button;
    }

    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(temp.right).offset(15);
    }];
}

-(void)butonClick:(LHToolButton *)btn{
    NSInteger index = [self.buttons indexOfObject:btn];
    if (index < self.current) {
        [self.LHDelegate clickLeft:index];
    }else if(index > self.current){
        [self.LHDelegate clickRight:index];
    }
    [self updateButtonTitleColor:index];
    self.current = index;
}


/** 更新字体颜色*/
- (void)updateButtonTitleColor:(NSInteger )index{
    LHToolButton *_button = [self.buttons objectAtIndex:self.current];
    _button.selected = NO;
 //   _button.titleLabel.font = [UIFont systemFontOfSize:17];

    LHToolButton *button = [self.buttons objectAtIndex:index];
    button.selected = YES;
}
//更新offset
-(void)updateContentOffset{
    LHToolButton *button = self.buttons[_current];
    //scrollview的宽度
    CGFloat width = self.scrollView.frame.size.width;
    //按钮右侧x
    CGFloat framex = button.frame.origin.x+button.frame.size.width;
    //按钮中心与scrollView中心距离
    CGFloat contentOffsetx = framex-width/2-button.frame.size.width/2;
    CGPoint point;

    __weak __typeof(self)weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.moveView.bounds = CGRectMake(0, 0, button.frame.size.width+10, 3);
        [UIView animateWithDuration:0.3 animations:^{
           weakself.moveView.center = CGPointMake(button.center.x, weakself.frame.size.height-2-4);
        }];
    });

    if (contentOffsetx < 0) {
        //按钮中心在scrollView中心左侧
        contentOffsetx = 0;

    }else if (contentOffsetx > self.scrollView.contentSize.width-width){
        //按钮中心大于（scrollView滚动witdh-按钮右侧x）,contentOffsetx重置，不让按钮向中心滚动（即不让scrollView滑动）
        contentOffsetx = self.scrollView.contentSize.width-width;
    }

    point = CGPointMake(contentOffsetx, 0);
    [self.scrollView setContentOffset:point animated:YES];
}

#pragma mark - sets
-(void)setTitles:(NSArray<__kindof NSString *> *)titles{
    _titles = titles;

    [self createButtons];
}

-(void)setCurrent:(NSInteger)current{
    if (_current != current) {
        LHToolButton *button = self.buttons[_current];
        LHToolButton *curBtn = self.buttons[current];

        [button setScale:0 anima:YES];
        [curBtn setScale:1 anima:YES];
        [self updateButtonTitleColor:current];
        _current = current;
    }else{
        LHToolButton *curBtn = self.buttons[current];
        [curBtn setScale:1 anima:YES];
    }

    [self updateContentOffset];
}

-(void)setProgressLeft:(CGFloat)progress{

    NSInteger left = self.current-1;
    if (left >= 0) {
        LHToolButton *mainBtn = self.buttons[self.current];
        LHToolButton *leftBtn = self.buttons[left];
        leftBtn.scale = progress;
        mainBtn.scale = 1-progress;

    }
}

-(void)setProgressRight:(CGFloat)progress{
    NSInteger right = self.current+1;
    if (right < self.buttons.count) {
        LHToolButton *mainBtn = self.buttons[self.current];
        LHToolButton *rightBtn = self.buttons[right];
        rightBtn.scale = progress;
        mainBtn.scale = 1-progress;
    }
}

#pragma mark - gets
-(NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
