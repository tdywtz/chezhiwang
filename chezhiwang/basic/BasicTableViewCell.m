//
//  BasicTableViewCell.m
//  chezhiwang
//
//  Created by luhai on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicTableViewCell.h"

@implementation BasicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGB_color(221, 221, 221, 1);
        [self.contentView addSubview:self.lineView];

        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(0.5);
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
