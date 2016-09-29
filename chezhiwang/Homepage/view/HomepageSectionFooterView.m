//
//  HomepageSectionFooterView.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageSectionFooterView.h"
#import "HomepageSectionModel.h"

@implementation HomepageSectionFooterView
{
    UIButton *pushButton;
    UIImageView *imageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
        [pushButton setTitleColor:RGB_color(154, 154, 154, 1) forState:UIControlStateNormal];
        pushButton.backgroundColor = RGB_color(240, 240, 240, 1);

        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"arrow"];

        [self addSubview:pushButton];
        [self addSubview:imageView];

        [pushButton makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
        }];

        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(50);
            make.centerY.equalTo(pushButton);
        }];
    }
    return self;
}

- (void)setSectionModel:(HomepageSectionModel *)sectionModel{
    _sectionModel = sectionModel;
    [pushButton setTitle:sectionModel.footTitle forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
