//
//  HomepageSectionHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageSectionHeaderView.h"
#import "HomepageSectionModel.h"

@implementation HomepageSectionHeaderView
{
    UIImageView *imageView;
    UILabel *titleLabel;
    UIView *lineView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:PT_FROM_PX(27)];
        titleLabel.textColor = RGB_color(17, 17, 17, 1);

        lineView = [[UIView alloc] init];

        [self addSubview:imageView];
        [self addSubview:titleLabel];
        [self addSubview:lineView];

        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-10);
          //  make.size.equalTo(CGSizeMake(22, 22));
        }];

          [titleLabel makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(imageView.right).offset(10);
              make.centerY.equalTo(imageView);
          }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
    return self;
}

- (void)setSectionModel:(HomepageSectionModel *)sectionModel{
    _sectionModel = sectionModel;
    imageView.image = [UIImage imageNamed:sectionModel.headImageName];
    titleLabel.text = sectionModel.headTitle;
    lineView.backgroundColor = sectionModel.headLineColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
