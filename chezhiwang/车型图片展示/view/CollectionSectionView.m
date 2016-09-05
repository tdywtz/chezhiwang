
//
//  CollectionSectionView.m
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CollectionSectionView.h"


@implementation CollectionSectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    _label = [[UILabel alloc] init];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setTitleColor:colorLightBlue forState:UIControlStateNormal];
    [_button setTitle:@"查看更多" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_label];
    [self addSubview:_button];

    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
    }];

    [_button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
    }];
}

- (void)buttonClick{
    self.model.open = !self.model.open;
    if (self.block) {
        self.block();

    }
}

- (void)setModel:(VehicleSeriesSctionModel *)model{
    _model = model;

    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:model.typeName];
    NSString *sring  = [NSString stringWithFormat:@"（%ld张）",model.num];
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:sring attributes:@{NSForegroundColorAttributeName:colorLightGray,NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [matt appendAttributedString:att];
    self.label.attributedText = matt;

    if (model.images.count < 6){
        _button.hidden= YES;
    }else{
        _button.hidden = NO;
    }
}

@end
