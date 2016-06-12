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

@end

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor grayColor];
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

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(void(^)(NSInteger index))block{
    self = [super initWithFrame:frame];
    if (self) {
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
        ToolBar *btn = [[ToolBar alloc] initWithFrame:CGRectMake(space+(width+space)*(i%3), 30*(i/3), width, 30)];
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
            rect.size.height = btn.frame.size.height+btn.frame.origin.y;
            self.bounds = rect;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
            line.backgroundColor = colorLineGray;
            [self addSubview:line];
        }
    }
}

-(void)tap:(UIGestureRecognizer *)tap{
    NSInteger index = [self.toolBars indexOfObject:tap.view];
    if (self.block) {
        self.block(index);
    }
}
-(void)setTitle:(NSString *)title index:(NSInteger)index{
    ToolBar *btn = self.toolBars[index];
    btn.titleLabel.text = title;
    if (index == 0) {
         btn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
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
