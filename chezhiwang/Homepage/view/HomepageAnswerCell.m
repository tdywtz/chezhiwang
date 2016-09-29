//
//  HomepageAnswerCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageAnswerCell.h"

@implementation HomepageAnswerCell
{
    UILabel *titleLabel;
    UILabel *typeLabel;
    UILabel *dateLabel;
    UILabel *answerLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.textColor = RGB_color(17, 17, 17, 1);
    
    typeLabel = [[UILabel alloc] init];
    typeLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
    typeLabel.layer.cornerRadius = 3;
    typeLabel.layer.borderWidth = 1;
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = RGB_color(153, 153, 153, 1);
    
    answerLabel = [[UILabel alloc] init];
    answerLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    answerLabel.textColor = RGB_color(119, 119, 119, 1);
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:typeLabel];
    [self.contentView addSubview:answerLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel.right).offset(15);
        make.centerY.equalTo(typeLabel);
    }];
    
    [answerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(typeLabel.bottom).offset(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
    }];
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
