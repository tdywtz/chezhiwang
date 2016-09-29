//
//  HomepageForumCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageForumCell.h"

@implementation HomepageForumCell
{
    UILabel *titleLabel;
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *contentLabel;
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
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    nameLabel.textColor = RGB_color(153, 153, 153, 1);
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = RGB_color(153, 153, 153, 1);
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    contentLabel.textColor = RGB_color(119, 119, 119, 1);
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:contentLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.right).offset(15);
        make.bottom.equalTo(nameLabel);
    }];
    
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(nameLabel);
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
