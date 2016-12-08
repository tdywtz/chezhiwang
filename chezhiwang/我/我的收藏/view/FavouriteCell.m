//
//  FavouriteCell.m
//  chezhiwang
//
//  Created by bangong on 16/12/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "FavouriteCell.h"

@implementation FavouriteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textColor = colorBlack;

        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textColor = colorLightGray;


        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = colorLineGray;

        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_dateLabel];
        [self.contentView addSubview:view];

        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(15);
            make.right.equalTo(-10);
        }];

        [_dateLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-15);
        }];

        [view makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }

    return self;
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
