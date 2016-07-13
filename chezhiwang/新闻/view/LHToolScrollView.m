//
//  LHToolScrollView.m
//  autoService
//
//  Created by bangong on 16/5/3.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHToolScrollView.h"


//@interface LHToolShadowView : UIView
//
//@end
//
//@implementation LHToolShadowView
//+ (Class)layerClass {
//    return [CAGradientLayer class];
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //self.backgroundColor = RGB_color(240, 240, 240, 1);
//        
//        self.backgroundColor = [UIColor clearColor];
//        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
//        
//        gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor,(id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor];
//        gradientLayer.transform = CATransform3DMakeRotation(M_PI_2, 0.0 , 0.0, 0.1);
//        //        CGRect newShadowFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        //        gradientLayer.frame = newShadowFrame;
//        
//    }
//    return self;
//}
//-(void)layoutSubviews{
//    [super layoutSubviews];
//}
//
//@end

@implementation LHToolButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setScale:0];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    return;
    //    NSLog(@"scale is %f", _scale);
    [self setTitleColor:[UIColor colorWithRed:(scale * (221.0 - 104.0) + 104.0)/255 green:(scale * (50.0 - 104.0) + 104.0)/255 blue:(scale * (55.0 - 104.0) + 104.0)/255 alpha:1] forState:UIControlStateNormal];
    //    NSLog(@"\ncolor is %@", self.titleLabel.textColor);
    //self.titleLabel.font = [UIFont systemFontOfSize:14 * (1 + 0.3 * scale)];
    self.transform = CGAffineTransformMakeScale(1+scale/5, 1+scale/5);
}

-(void)setScale:(CGFloat)scale anima:(BOOL)boll{
    _scale = scale;
    return;
    if (boll) {
        __weak __typeof(self)weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            [weakSelf setTitleColor:[UIColor colorWithRed:(scale * (221.0 - 104.0) + 104.0)/255 green:(scale * (50.0 - 104.0) + 104.0)/255 blue:(scale * (55.0 - 104.0) + 104.0)/255 alpha:1] forState:UIControlStateNormal];
            weakSelf.transform = CGAffineTransformMakeScale(1+scale/5, 1+scale/5);
            
        }];
    }
}

@end


#pragma mark - LHToolScrollView
@interface LHToolScrollView ()<UIScrollViewDelegate>
{
    UIImageView *leftView;
    UIImageView *rightView;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *moveView;//滑动条
@property (nonatomic,strong) NSMutableArray<__kindof LHToolButton *> *buttons;

@end

@implementation LHToolScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 10, 0, 25));
        }];
        
         self.contentView = [[UIView alloc] init];
        [self.scrollView addSubview:self.contentView];
        
        self.moveView = [[UIView alloc] init];
        self.moveView.backgroundColor = colorYellow;
        [self.contentView addSubview:self.moveView];
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
            make.height.equalTo(self.frame.size.height);
        }];
        
        leftView = [[UIImageView alloc] initWithFrame:CGRectZero];
        leftView.image = [UIImage imageNamed:@"bar_btn_icon_returntext"];
//        leftView.backgroundColor = colorLightBlue;;
//        leftView.layer.shadowColor = colorLightBlue.CGColor;
//        leftView.layer.shadowOpacity = 0.99;
//        leftView.layer.shadowOffset = CGSizeMake(10, 0);
//        leftView.layer.shadowRadius = 5;

    
        rightView = [[UIImageView alloc] initWithFrame:CGRectZero];
        rightView.image = [UIImage imageNamed:@"bar_btn_icon_returntext"];
        rightView.transform  = CGAffineTransformMakeRotation(M_PI);
//        rightView.backgroundColor = colorLightBlue;;
//        rightView.layer.shadowColor = colorLightBlue.CGColor;
//        rightView.layer.shadowOpacity = 0.99;
//        rightView.layer.shadowOffset = CGSizeMake(-10, 0);
//        rightView.layer.shadowRadius = 5;

        
        
        [self addSubview:leftView];
        [self addSubview:rightView];
        
        [leftView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.centerY.equalTo(0);
           // make.size.equalTo(CGSizeMake(15, 30));
        }];
        
        [rightView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_scrollView.right);
            make.centerY.equalTo(0);
            //make.size.equalTo(CGSizeMake(15, 30));
        }];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"navigation_fg"];
        [self addSubview:imageview];
        [imageview makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.centerY.equalTo(0);
        }];
    }
    return self;
}


-(void)createButtons{
    LHToolButton *temp = nil;
    for (int i = 0; i < _titles.count; i ++) {
        LHToolButton *button = [[LHToolButton alloc] init];
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(butonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    self.current = index;
}

-(void)updateContentOffset{
    LHToolButton *button = self.buttons[_current];
    
    CGFloat width = self.scrollView.frame .size.width;
    CGFloat framex = button.frame.origin.x+button.frame.size.width;
    CGFloat contentOffsetx = framex-width/2-button.frame.size.width/2;
    CGPoint point;
    
    __weak __typeof(self)weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.moveView.bounds = CGRectMake(0, 0, button.frame.size.width+10, 3);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1.4 options:UIViewAnimationOptionLayoutSubviews animations:^{
             weakself.moveView.center = CGPointMake(button.center.x, weakself.frame.size.height-2);
        } completion:nil];
    });
    
    if (contentOffsetx < 0) {
        contentOffsetx = 0;
        
    }else if (contentOffsetx > self.scrollView.contentSize.width-width){
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



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat _x = scrollView.contentOffset.x;
    if (_x < 10) {
        leftView.alpha = 0.5;
    }else{
        leftView.alpha = 1;
    }
    if (_x < scrollView.contentSize.width-scrollView.frame.size.width-15) {
        rightView.alpha = 1;
    }else{
        rightView.alpha = 0.5;
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
