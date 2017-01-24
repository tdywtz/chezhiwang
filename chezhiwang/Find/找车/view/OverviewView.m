//
//  OverviewView.m
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "OverviewView.h"
#import "OverviewScoreView.h"



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

        _imageView.lh_size = CGSizeMake(WIDTH, 160);
        _imageView.lh_top = 10;
        _imageView.lh_left = 0;

        NSArray *labels = @[@"brandLabel",@"brandAttributeLabel",@"seriesLabel",@"seriesAttributeLabel",@"displacementLabel",@"transmissionCaseLabel"];
        UILabel *temp = nil;
        for (int i = 0; i < labels.count; i ++) {
            UILabel *label = [self labelTo];
            [self setValue:label forKey:labels[i]];

            [self addSubview:label];

            if (i < 4) {
                if (i == 0 || i == 2) {

                    UIView *lineView = [UIView new];
                    lineView.backgroundColor = colorLineGray;

                    UIView *verticalLine = [UIView new];
                    verticalLine.backgroundColor = colorLineGray;

                    [self addSubview:lineView];
                    [self addSubview:verticalLine];

                    lineView.lh_size = CGSizeMake(WIDTH, 1);
                    lineView.lh_left = 0;
                    if (temp) {
                         lineView.lh_top = temp.lh_bottom;
                    }else{
                         lineView.lh_top = _imageView.lh_bottom + 10;
                    }

                    label.lh_size = CGSizeMake(WIDTH/2-20, 42);
                    label.lh_left = 10;
                    label.lh_top = lineView.lh_bottom;

                    verticalLine.lh_size = CGSizeMake(1, 15);
                    verticalLine.lh_centerX = WIDTH/2;
                    verticalLine.lh_centerY = label.lh_centerY;

                    temp = label;
                }else{
                    label.lh_left = WIDTH/2 + 10;
                    label.lh_top = temp.lh_top;
                    label.lh_size = CGSizeMake(WIDTH/2-20, temp.lh_height);
                }
            }else{
                UIView *lineView = [UIView new];
                lineView.backgroundColor = colorLineGray;

                [self addSubview:lineView];

                lineView.lh_size = CGSizeMake(WIDTH, 1);
                lineView.lh_left = 0;
                lineView.lh_top = temp.lh_bottom;

                label.lh_size = CGSizeMake(WIDTH-20, temp.lh_height);
                label.lh_left = 10;
                label.lh_top = lineView.lh_bottom;

                temp = label;
            }
        }

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 5)];
        _lineView.backgroundColor = colorBackGround;

        _lineView.lh_size = CGSizeMake(WIDTH, 5);
        _lineView.lh_left = 0;
        _lineView.lh_top = transmissionCaseLabel.lh_bottom;

        [self addSubview:_imageView];
        [self addSubview:_lineView];

        self.lh_width = WIDTH;
        self.lh_height = _lineView.lh_bottom;
    }
    return self;
}

- (UILabel *)labelTo{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = colorDeepGray;
    label.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    return label;
}

- (void)setData:(NSDictionary *)data{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:data[@"logo"]] placeholderImage:[CZWManager defaultIconImage]];

    NSAttributedString *insetAtt = [[NSAttributedString alloc] initWithString:@"速" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:PT_FROM_PX(18)],NSForegroundColorAttributeName:[UIColor clearColor]}];

    NSMutableAttributedString *text = [self attbuteWithName:@"品牌：" value:data[@"brand"]];
    text.yy_color = colorYellow;
    text.yy_font = [UIFont systemFontOfSize:PT_FROM_PX(20)];
    [text yy_setColor:colorBlack range:NSMakeRange(0, 3)];
    [text yy_setFont:[UIFont systemFontOfSize:PT_FROM_PX(18)] range:NSMakeRange(0, 3)];
    [text insertAttributedString:insetAtt atIndex:1];
    brandLabel.attributedText = text;

    text = [self attbuteWithName:@"车系：" value:data[@"series"]];
    [text insertAttributedString:insetAtt atIndex:1];
    seriesLabel.attributedText = text;

    text = [self attbuteWithName:@"排量：" value:data[@"engine"]];
    [text insertAttributedString:insetAtt atIndex:1];
    displacementLabel.attributedText = text;
    
    brandAttributeLabel.attributedText = [self attbuteWithName:@"品牌属性：" value:data[@"brandAttribute"]];
    seriesAttributeLabel.attributedText = [self attbuteWithName:@"车系属性：" value:data[@"CarAttribute"]];
    transmissionCaseLabel.attributedText = [self attbuteWithName:@"变速箱：" value:data[@"transmission"]];
}

- (NSMutableAttributedString *)attbuteWithName:(NSString *)name value:(NSString *)value{
    NSString *text = [NSString stringWithFormat:@"%@%@",name,value];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
    att.yy_font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    [att yy_setColor:colorBlack range:NSMakeRange(0, att.length)];
    [att yy_setColor:colorBlack range:[text rangeOfString:name]];

    return att;
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
        __weak __typeof(self) _self =self;
        _statistcsView.block = ^(CGRect frame){

            [_self resetLayout];
        };

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

    if (self.block) {
        self.block(self.frame);
    }
}

- (void)setDataScore:(NSDictionary *)data{
    [_infoView setData:data[@"modelInfo"]];

    NSDictionary *operation = data[@"operation"];
    NSDictionary *score = data[@"score"];

    OverviewScoreViewModel *model = [OverviewScoreViewModel new];
    model.score = [NSString stringWithFormat:@"%@",score[@"avgScore"]];
    model.reportId = operation[@"reportId"];
    model.pcId = operation[@"pcId"];
    model.pc =  [operation[@"pc"] boolValue];
    model.report = [operation[@"report"] boolValue];
    model.minScore = score[@"minScore"];
    model.avgScore = score[@"avgScore"];
    model.maxScore = score[@"maxScore"];


    [_scoreView setModel:model];
    _scoreView.parentVC = self.parentVC;
}

- (void)setDataStatistics:(NSDictionary *)data{
    NSArray *dataArray = data[@"rel"];

    NSMutableArray *models = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i ++) {

        NSDictionary *subDict = dataArray[i];
        OverviewStatisticsModel *model = [OverviewStatisticsModel mj_objectWithKeyValues:subDict];

        model.exampleModels = [OverviewStatisticsExampleModel mj_objectArrayWithKeyValuesArray:subDict[@"data"]];
        [models addObject:model];
    }
    [_statistcsView setModels:models];
    [self resetLayout];

}


- (void)setUpdateBlock:(updateFrame)block{
    self.block = block;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
