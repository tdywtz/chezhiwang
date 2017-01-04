//
//  ReputationCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ReputationCell.h"

@interface ReputationCellContentView : UIView
{
    UILabel *titleLabel;
    UILabel *outsideLabel;
    UILabel *defectLabel;
    UILabel *summaryLabel;
    UILabel *praiseLabel;//👍
    UILabel *commentLabel;
}
@end

@implementation ReputationCellContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = colorBackGround;

        UILabel *one = [self labelWithColor:colorDeepGray];
        one.text = @"标题";

        UILabel *two = [self labelWithColor:colorGreen];
        two.text = @"优点";

        UILabel *three = [self labelWithColor:colorOrangeRed];
        three.text = @"缺点";

        UILabel *four = [self labelWithColor:colorDeepGray];
        four.text = @"总结";

        titleLabel = [self labelWithColor:colorBlack];
        titleLabel.numberOfLines = 2;

        outsideLabel = [self labelWithColor:colorBlack];
        outsideLabel.numberOfLines = 2;

        defectLabel = [self labelWithColor:colorBlack];
        defectLabel.numberOfLines = 2;

        summaryLabel = [self labelWithColor:colorBlack];
        summaryLabel.numberOfLines = 2;

        praiseLabel = [self labelWithColor:colorDeepGray];
        commentLabel = [self labelWithColor:colorDeepGray];

        [self addSubview:one];
        [self addSubview:two];
        [self addSubview:three];
        [self addSubview:four];

        [self addSubview:titleLabel];
        [self addSubview:outsideLabel];
        [self addSubview:defectLabel];
        [self addSubview:summaryLabel];
        [self addSubview:praiseLabel];
        [self addSubview:commentLabel];

        [one makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(10);
        }];

        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(50);
            make.right.lessThanOrEqualTo(-10);
        }];

        [two makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(outsideLabel);
        }];

        [outsideLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
        }];

        [three makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(defectLabel);
        }];

        [defectLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(outsideLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
        }];

        [four makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(summaryLabel);
        }];

        [summaryLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(defectLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
        }];

        [praiseLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentLabel);
            make.right.equalTo(commentLabel.left).offset(-10);
        }];

        [commentLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-10);
            make.top.equalTo(summaryLabel.bottom).offset(15);
            make.bottom.equalTo(-10);
        }];

        titleLabel.text = @"傲娇了公开了地方价格";
        outsideLabel.text = @"傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格";
        defectLabel.text = @"傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格";
        summaryLabel.text = @"傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格傲娇了公开了地方价格";
    }
    return self;
}

- (UILabel *)labelWithColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = color;
    return label;
}

@end



@implementation ReputationCell
{
    UILabel *titleLabel;
    UIImageView *iconImageView;
    UILabel *userNameLabel;
    UILabel *dateLabel;
    UILabel *scoreLabel;
    ReputationCellContentView *contentView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = colorBlack;

    iconImageView = [[UIImageView alloc] init];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = colorLightBlue;
    userNameLabel.font = [UIFont systemFontOfSize:15];

    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = colorLightGray;
    dateLabel.font = [UIFont systemFontOfSize:12];

    scoreLabel = [[UILabel alloc] init];

    contentView = [[ReputationCellContentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, 100)];

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:scoreLabel];
    [self.contentView addSubview:contentView];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(10);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(titleLabel.bottom).offset(10);
        make.height.equalTo(1);
    }];

    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(lineView.bottom).offset(10);
        make.size.equalTo(40);
    }];

    [userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView.top);
        make.right.lessThanOrEqualTo(0);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.bottom.equalTo(iconImageView.bottom);
        make.width.equalTo(110);
    }];

    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLabel.right).offset(10);
        make.bottom.equalTo(dateLabel);
        make.right.equalTo(-10);
    }];

    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(iconImageView.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];
}

- (void)setModel:(ReputationModel *)model{
    _model = model;

    titleLabel.text = @"asdfghjk";
    userNameLabel.text = @"okokok";
    dateLabel.text = @"2015-02-55 14:50";
    scoreLabel.text = @"fjdsalgjdfkkkkkkkkkkkkkkkkkkkkkkkkkkg";
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
