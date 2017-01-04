//
//  HomepageResearchCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageResearchCell.h"

@implementation HomepageResearchCell
{
    UIImageView *iconImageView;
    UIImageView *hottypeImageView;
    UILabel *modelLabel;
    UILabel *scoreLabel;
    TTTAttributedLabel *contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;

    hottypeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"推荐购买"]];
    hottypeImageView.contentMode = UIViewContentModeScaleAspectFit;

    modelLabel = [[UILabel alloc] init];

    scoreLabel = [[UILabel alloc] init];

    contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    contentLabel.numberOfLines = 2;
    contentLabel.lineSpacing = 3;
    contentLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    contentLabel.backgroundColor = colorBackGround;

    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:hottypeImageView];
    [self.contentView addSubview:modelLabel];
    [self.contentView addSubview:scoreLabel];
    [self.contentView addSubview:contentLabel];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(20);
        make.size.equalTo(CGSizeMake(100, 100/1.4));
    }];

    [hottypeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];

    [modelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(15);
        make.top.equalTo(20);
    }];

    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(15);
        make.top.equalTo(modelLabel.bottom).offset(10);
    }];

    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.top.equalTo(iconImageView.bottom).offset(10);
    }];
}

-(void)setResearchModel:(HomepageResearchModel *)researchModel{
    _researchModel = researchModel;
    [self setData];
}

- (void)setData{
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.researchModel.image] placeholderImage:[CZWManager defaultIconImage]];

    hottypeImageView.hidden = !self.researchModel.hottype;

    modelLabel.attributedText = [self attributed:@"调查车型：" font1:[UIFont systemFontOfSize:PT_FROM_PX(18)] color1:colorLightGray stirng2:self.researchModel.models font2:[UIFont systemFontOfSize:PT_FROM_PX(23)] color2:RGB_color(17, 27, 36, 1)];
     scoreLabel.attributedText = [self attributed:@"综合评分：" font1:[UIFont systemFontOfSize:PT_FROM_PX(18)] color1:colorLightGray stirng2:self.researchModel.score font2:[UIFont systemFontOfSize:PT_FROM_PX(23)] color2:RGB_color(237, 17, 17, 1)];

    NSMutableAttributedString *result = [self attributed:@"调查结论：" font1:[UIFont systemFontOfSize:PT_FROM_PX(19)] color1:colorLightGray stirng2:self.researchModel.content font2:[UIFont systemFontOfSize:PT_FROM_PX(19)] color2:colorBlack];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    [result addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, result.length)];
    contentLabel.attributedText = result;
}

- (NSMutableAttributedString *)attributed:(NSString *)string1 font1:(UIFont *)font1 color1:(UIColor *)color1 stirng2:(NSString *)string2 font2:(UIFont *)font2 color2:(UIColor *)color2{
    if (string2 == nil) {
        string2 = @"";
    }
    NSMutableAttributedString *matt = [[NSMutableAttributedString alloc] initWithString:string1 attributes:@{NSFontAttributeName:font1,NSForegroundColorAttributeName:color1}];
    NSAttributedString *appenAtt = [[NSAttributedString alloc] initWithString:string2 attributes:@{NSFontAttributeName:font2,NSForegroundColorAttributeName:color2}];

    [matt appendAttributedString:appenAtt];
    return matt;
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
