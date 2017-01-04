//
//  OverviewView.m
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewView.h"
#import "OverviewScoreView.h"
#import "OverviewStatisticsView.h"


#pragma mark - 车型信息
@implementation OverviewInfoView
{
    UIImageView *_imageView;
    UIView *_lineView;

    UILabel *brandLabel;//品牌
    UILabel *seriesLabel;//车系
    UILabel *displacementLabel;//排量
    UILabel *brandAttributeLabel;//品牌属性
    UILabel *seriesAttributeLabel;//车系属性
    UILabel *transmissionCaseLabel;//变速箱
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {


        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [CZWManager defaultIconImage];

        brandLabel = [self labelTo];
        seriesLabel = [self labelTo];
        displacementLabel = [self labelTo];
        brandAttributeLabel = [self labelTo];
        seriesAttributeLabel = [self labelTo];
        transmissionCaseLabel = [self labelTo];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
        _lineView.backgroundColor = colorBackGround;

        [self addSubview:_imageView];
        [self addSubview:brandLabel];
        [self addSubview:seriesLabel];
        [self addSubview:displacementLabel];
        [self addSubview:brandAttributeLabel];
        [self addSubview:seriesAttributeLabel];
        [self addSubview:transmissionCaseLabel];
        [self addSubview:_lineView];

        [self resetLayout];
        [self setData];
    }
    return self;
}

- (UILabel *)labelTo{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = colorDeepGray;
    label.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    return label;
}

- (void)setData{
   brandLabel.text = @"品牌：1";
    seriesLabel.text = @"品牌：2";
    displacementLabel.text = @"品牌：3";
    brandAttributeLabel.text = @"品牌：4";
    seriesAttributeLabel.text = @"品牌：5";
    transmissionCaseLabel.text = @"品牌：6";

}

- (void)resetLayout{
    _imageView.lh_size = CGSizeMake(WIDTH, 100);
    _imageView.lh_top = 20;
    _imageView.lh_left = 0;

    brandLabel.lh_left = 10;
    brandLabel.lh_top = _imageView.lh_bottom + 20;
    brandLabel.lh_size = CGSizeMake(WIDTH/2-25, 18);

    seriesLabel.lh_left = brandLabel.lh_left;
    seriesLabel.lh_top = brandLabel.lh_bottom + 5;
    seriesLabel.lh_size = brandLabel.lh_size;

    displacementLabel.lh_left = brandLabel.lh_left;
    displacementLabel.lh_top = seriesLabel.lh_bottom + 5;
    displacementLabel.lh_size = brandLabel.lh_size;

    brandAttributeLabel.lh_left = WIDTH/2+5;
    brandAttributeLabel.lh_top = brandLabel.lh_top;
    brandAttributeLabel.lh_size = brandLabel.lh_size;

    seriesAttributeLabel.lh_left = brandAttributeLabel.lh_left;
    seriesAttributeLabel.lh_top = brandAttributeLabel.lh_bottom + 5;
    seriesAttributeLabel.lh_size = brandLabel.lh_size;

    transmissionCaseLabel.lh_left = seriesAttributeLabel.lh_left;
    transmissionCaseLabel.lh_top = seriesAttributeLabel.lh_bottom + 5;
    transmissionCaseLabel.lh_size = brandLabel.lh_size;

    _lineView.lh_size = CGSizeMake(WIDTH, 5);
    _lineView.lh_left = 0;
    _lineView.lh_top = displacementLabel.lh_bottom + 10;

    self.lh_width = WIDTH;
    self.lh_height = _lineView.lh_bottom;
}
@end



#pragma mark - header
@implementation OverviewView
{
    OverviewInfoView *_infoView;
    OverviewScoreView *_scoreView;
    OverviewStatisticsView *_statistcsView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _infoView = [[OverviewInfoView alloc] initWithFrame:CGRectZero];
        _scoreView = [[OverviewScoreView alloc] initWithFrame:CGRectZero];
        _statistcsView = [[OverviewStatisticsView alloc] initWithFrame:CGRectZero];

        [self addSubview:_infoView];
        [self addSubview:_scoreView];
        [self addSubview:_statistcsView];

        [self resetLayout];
    }
    return self;
}

- (void)resetLayout{
    _infoView.lh_top = 0;
    _infoView.lh_left = 0;

    _scoreView.lh_left = 0;
    _scoreView.lh_top = _infoView.lh_bottom;

    _statistcsView.lh_left = 0;
    _statistcsView.lh_top = _scoreView.lh_bottom;

    self.lh_width = WIDTH;
    self.lh_height = _statistcsView.lh_bottom;
}

//坐标系
- (void)drawCoordinateSystem{

}

//柱子
-(void)drawColumn{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
