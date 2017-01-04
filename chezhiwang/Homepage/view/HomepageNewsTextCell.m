//
//  HomepageNewsTextCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageNewsTextCell.h"

@implementation HomepageNewsTextCell
{
    UILabel *titleLabel;
    TTTAttributedLabel *stylenamelabel;
    UILabel *dateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.textColor = colorBlack;
    titleLabel.numberOfLines = 1;

    stylenamelabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    stylenamelabel.textInsets = UIEdgeInsetsMake(1, 3, 1, 3);
    stylenamelabel.font = [UIFont systemFontOfSize:PT_FROM_PX(16.5)];
    stylenamelabel.textColor = colorOrangeRed;
    stylenamelabel.layer.cornerRadius = 3;
    stylenamelabel.layer.borderWidth = 1;
    stylenamelabel.layer.borderColor = stylenamelabel.textColor.CGColor;

    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = colorLightGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:stylenamelabel];
    [self.contentView addSubview:dateLabel];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];

    [stylenamelabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stylenamelabel.right).offset(10);
        make.centerY.equalTo(stylenamelabel);
    }];
}

- (void)setNewsModel:(HomepageNewsModel *)newsModel{
    _newsModel = newsModel;
    [self setData];
}

- (void)setData{
    titleLabel.text = self.newsModel.title;
    stylenamelabel.text = self.newsModel.stylename;
    dateLabel.text = self.newsModel.date;
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
