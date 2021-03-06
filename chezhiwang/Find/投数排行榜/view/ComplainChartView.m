//
//  ComplainChartView.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartView.h"

@interface ToolBar : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,copy) NSString *tid;//记录id
@property (nonatomic,assign) BOOL initialSetUp;//是否被被赋值

@end

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tid = @"";
        _initialSetUp = YES;//
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = colorDeepGray;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(0);
            make.right.equalTo(_imageView.left);
        }];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-10);
            make.width.equalTo(5);
        }];
    }
    return self;
}

@end


@interface ComplainChartView ()

@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSMutableArray *toolBars;

@end


@implementation ComplainChartView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(void(^)(NSInteger index, BOOL initialSetUp))block{
    self = [super initWithFrame:frame];
    if (self) {
        _beginDate = @"";
        _endDate = @"";
        self.block = block;
        _titles = titles;
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    CGFloat space = 10.0;
    CGFloat width = (CGRectGetWidth(self.frame)-space*4)/3;
    for (int i = 0; i < _titles.count; i ++) {
        ToolBar *btn = [[ToolBar alloc] initWithFrame:CGRectMake(space+(width+space)*(i%3), 35*(i/3), width, 35)];
        btn.titleLabel.text = _titles[i];
        //若是时间，换行
        if (i == 0) {
            btn.titleLabel.numberOfLines = 0;
        }
        btn.imageView.image = [UIImage imageNamed:@"auto_toolbarRightTriangle"];
        [self addSubview:btn];
        [self.toolBars addObject:btn];
        
        [btn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];

        if (i == _titles.count-1) {
            CGRect rect = self.bounds;
            rect.size.height = btn.frame.size.height+btn.frame.origin.y+5;
            self.bounds = rect;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
            line.backgroundColor = colorLineGray;
            [self addSubview:line];
        }
    }
}

-(void)tap:(UIGestureRecognizer *)tap{

    ToolBar *btn = (ToolBar *)tap.view;
     NSInteger index = [self.toolBars indexOfObject:tap.view];
    if (btn.initialSetUp) {
        if (self.block) {
            self.block(index, YES);
        }
    }else{
        btn.titleLabel.text = _titles[index];
        btn.tid = @"";
        btn.initialSetUp = YES;
        if (index == 0) {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            _beginDate = @"";
            _endDate = @"";
        }
        if (self.block) {
            self.block(index, NO);
        }
    }
}

-(void)setTitle:(NSString *)title tid:(NSString *)tid index:(NSInteger)index{
    ToolBar *btn = self.toolBars[index];
    btn.titleLabel.text = title;
    btn.tid = tid;
    btn.initialSetUp = NO;
    if (index == 0) {
        if ([title integerValue] > 100) {
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
}
//设置按钮是否可点击
- (void)setEnable:(BOOL)enble index:(NSInteger)index{
    ToolBar *bar = self.toolBars[index];
    bar.userInteractionEnabled = enble;
    bar.initialSetUp = YES;
    if (enble) {
        bar.alpha = 1;
    }else{
        bar.alpha = 0.5;
    }
}

- (NSString *)gettidWithIndex:(NSInteger)index{
     ToolBar *btn = self.toolBars[index];
    return btn.tid;
}

- (void)hideBarWithIndex:(NSInteger)index{
    ToolBar *bar = self.toolBars[index];
    bar.hidden = YES;
}

-(NSMutableArray *)toolBars{
    if (_toolBars == nil) {
        _toolBars = [[NSMutableArray alloc] init];
    }
    return _toolBars;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
