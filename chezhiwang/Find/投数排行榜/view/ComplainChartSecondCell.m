//
//  ComplainChartSecondCell.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartSecondCell.h"

@implementation ComplainChartSecondCell
{
    UIView *bgView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 3;
        bgView.layer.masksToBounds = YES;

        _chartLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chartLabel.textColor = colorDeepGray;
        _chartLabel.font = [UIFont systemFontOfSize:14];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        _chartLabel.text = @"--";
        
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.textColor = colorDeepGray;
        _brandLabel.font = [UIFont systemFontOfSize:14];
        _brandLabel.textAlignment = NSTextAlignmentCenter;
        _brandLabel.text = @"--";
        
        _percentageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentageLabel.textColor = colorYellow;
        _percentageLabel.font = [UIFont systemFontOfSize:14];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.text = @"--";

        [self.contentView addSubview:bgView];
        [self.contentView addSubview:_chartLabel];
        [self.contentView addSubview:_brandLabel];
        [self.contentView addSubview:_percentageLabel];

        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_chartLabel);
            make.size.equalTo(CGSizeMake(20, 20));
        }];

        [_chartLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(25);
            make.size.greaterThanOrEqualTo(CGSizeMake(20, 44));
        }];
        
        [_brandLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(CGPointZero);
            make.width.lessThanOrEqualTo(WIDTH-70-60);
        }];
        
        [_percentageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
            make.width.greaterThanOrEqualTo(40);
        }];
    }
    return self;
}

- (void)setModel:(ComplainChartSecondModel *)model;{
    if ([model isKindOfClass:[ComplainChartSecondModel class]]) {
        _chartLabel.text = model.number;
        _brandLabel.text = model.brandName;
        _percentageLabel.text = model.percentage;
        if ([model.number integerValue] == 1) {
            bgView.backgroundColor = RGB_color(229, 0, 18, 1);
            _chartLabel.textColor = [UIColor whiteColor];
        }else if ([model.number integerValue] == 2){
            bgView.backgroundColor = RGB_color(242, 172, 2, 1);
            _chartLabel.textColor = [UIColor whiteColor];
        }else if ([model.number integerValue] == 3){
            bgView.backgroundColor = RGB_color(190, 191, 192, 1);
            _chartLabel.textColor = [UIColor whiteColor];
        }else{
            bgView.backgroundColor = [UIColor clearColor];
            _chartLabel.textColor = colorDeepGray;
        }
    }else{
        _chartLabel.text = @"--";
        _brandLabel.text = @"--";
        _percentageLabel.text = @"--";
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, colorLineGray.CGColor);
            CGContextSetLineWidth(context, 1);
            CGContextMoveToPoint(context, 0, rect.size.height-1);
            CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-1);
            CGContextStrokePath(context);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
