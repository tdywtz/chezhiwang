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
    TTTAttributedLabel *typeLabel;
    UILabel *dateLabel;
    TTTAttributedLabel *answerLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.textColor = RGB_color(17, 17, 17, 1);
    titleLabel.numberOfLines = 2;
    
    typeLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    typeLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
    typeLabel.layer.cornerRadius = 3;
    typeLabel.layer.borderWidth = 1;
    typeLabel.textInsets = UIEdgeInsetsMake(1, 3, 1, 3);
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = RGB_color(153, 153, 153, 1);
    
    answerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    answerLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    answerLabel.textColor = RGB_color(119, 119, 119, 1);
    answerLabel.lineSpacing = 3;
    answerLabel.numberOfLines = 2;
    
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

- (void)setAnswerModel:(HomepageAnswerModel *)answerModel{
    _answerModel = answerModel;
    [self setData];
}

- (void)setData{
    titleLabel.text = _answerModel.question;

    dateLabel.text = _answerModel.date;
    answerLabel.text = _answerModel.answer;

    NSInteger type = [_answerModel.type integerValue];
    if (type == 0) {
        typeLabel.textColor = RGB_color(78, 191, 243, 1);
        typeLabel.text = @"维修保养";

    }else if (type == 1){
        typeLabel.textColor = RGB_color(255, 147, 4, 1);
        typeLabel.text = @"买车咨询";

    }else{
        typeLabel.textColor = RGB_color(27, 188, 157, 1);
        typeLabel.text = @"政策法规";
    }

    typeLabel.layer.borderColor = typeLabel.textColor.CGColor;
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
