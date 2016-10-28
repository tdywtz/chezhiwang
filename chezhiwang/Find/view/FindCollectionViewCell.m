//
//  FindCollectionViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "FindCollectionViewCell.h"

@implementation FindCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = RGB_color(240, 240, 240, 1).CGColor;

        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
        self.titleLabel.textColor = RGB_color(51, 51, 51, 1);

        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];

        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-20);
            make.width.equalTo(25);

        }];
         [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
             make.centerX.equalTo(0);
             make.centerY.equalTo(20);
         }];
    }
    return self;
}
@end
