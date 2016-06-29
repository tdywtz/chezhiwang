//
//  ComplainChartSecondCell.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartSecondCell.h"

@implementation ComplainChartSecondCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        _chartLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _chartLabel.textColor = [UIColor grayColor];
        _chartLabel.font = [UIFont systemFontOfSize:14];
        _chartLabel.textAlignment = NSTextAlignmentCenter;
        _chartLabel.text = @"--";
        
        _brandLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _brandLabel.textColor = [UIColor grayColor];
        _brandLabel.font = [UIFont systemFontOfSize:14];
        _brandLabel.textAlignment = NSTextAlignmentCenter;
        _brandLabel.text = @"--";
        
        _percentageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentageLabel.textColor = [UIColor grayColor];
        _percentageLabel.font = [UIFont systemFontOfSize:14];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.text = @"--";
        
        [self.contentView addSubview:_chartLabel];
        [self.contentView addSubview:_brandLabel];
        [self.contentView addSubview:_percentageLabel];
     
        [_chartLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(25);
            make.size.greaterThanOrEqualTo(CGSizeMake(20, 44));
        }];
        
        [_brandLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(CGPointZero);
            make.width.lessThanOrEqualTo(160);
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

        _chartLabel.text = model.number;
        _brandLabel.text = model.brandName;
        _percentageLabel.text = model.percentage;

  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
