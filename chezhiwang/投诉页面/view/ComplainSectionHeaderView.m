//
//  ComplainSectionHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainSectionHeaderView.h"
#import "ComplainSectionModel.h"

#pragma mark - TwoheaderView

@implementation ComplainTwoSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = colorLightGray;
    _nameLabel.font = [UIFont systemFontOfSize:15];


    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    [self addSubview:_nameLabel];
    [self addSubview:_lineView];


    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(0);
        make.bottom.equalTo(0);
    }];


    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (void)setModel:(ComplainSectionModel *)model{
    _model = model;

    _nameLabel.text = model.name;
}

@end

#pragma mark - headerView
@implementation ComplainSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = colorBlack;
    _nameLabel.font = [UIFont systemFontOfSize:15];

    _describeLabel = [[UILabel alloc] init];
    _describeLabel.textColor = colorOrangeRed;
    _describeLabel.font = [UIFont systemFontOfSize:11];

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = RGB_color(240, 240, 240, 1);

    [self addSubview:_imageView];
    [self addSubview:_nameLabel];
    [self addSubview:_describeLabel];
    [self addSubview:_lineView];

    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.bottom.equalTo(-20);
        make.size.equalTo(CGSizeMake(20, 20));
    }];

    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.right).offset(5);
        make.centerY.equalTo(_imageView);
    }];

    [_describeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(_imageView);
        make.left.greaterThanOrEqualTo(_nameLabel.right);
    }];

    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(0);
        make.height.equalTo(10);
    }];
}

- (void)setModel:(ComplainSectionModel *)model{
    _model = model;

    _imageView.image = model.image;
    _nameLabel.text = model.name;
    _describeLabel.text = model.describe;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
