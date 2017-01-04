//
//  VehicleImageCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "VehicleImageCell.h"

@implementation VehicleImageCell
{
    UIImageView *imageView;
    UILabel *nameLabel;

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_color(250, 251, 252, 1);

        
        imageView = [[UIImageView alloc] init];

        nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = colorBlack;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.layer.borderColor = colorLineGray.CGColor;
        nameLabel.layer.borderWidth = 1;

        [self.contentView addSubview:imageView];
        [self.contentView addSubview:nameLabel];

        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(0);
            make.bottom.equalTo(nameLabel.top);
        }];
        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(30);
        }];
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary{
    [imageView sd_setImageWithURL:[NSURL URLWithString:dictionary[@"url"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:dictionary[@"seriesname"]];
    NSAttributedString *att= [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"（共%@张）",dictionary[@"num"]] attributes:@{NSForegroundColorAttributeName:colorLightGray}];
    [matt appendAttributedString:att];
    nameLabel.attributedText = matt;
}
@end
