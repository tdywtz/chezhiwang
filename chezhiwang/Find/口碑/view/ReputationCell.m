//
//  ReputationCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ReputationCell.h"
#import "LHStarView.h"
#import "ReputationModel.h"

@implementation ReputationCellContentView
{
    UILabel *titleLabel;
    UILabel *outsideLabel;
    UILabel *defectLabel;//瑕疵
    UILabel *summaryLabel;//总结
    UILabel *praiseLabel;//👍
    UILabel *commentLabel;

    UIButton *praiseButton;
}
- (instancetype)initWithFrame:(CGRect)frame praise:(BOOL)praise
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

        NSInteger numberOfLines = praise?2:0;

        titleLabel = [self labelWithColor:colorBlack];
        titleLabel.numberOfLines =numberOfLines;

        outsideLabel = [self labelWithColor:colorBlack];
        outsideLabel.numberOfLines = numberOfLines;

        defectLabel = [self labelWithColor:colorBlack];
        defectLabel.numberOfLines = numberOfLines;

        summaryLabel = [self labelWithColor:colorBlack];
        summaryLabel.numberOfLines = numberOfLines;

        [self addSubview:one];
        [self addSubview:two];
        [self addSubview:three];
        [self addSubview:four];

        [self addSubview:titleLabel];
        [self addSubview:outsideLabel];
        [self addSubview:defectLabel];
        [self addSubview:summaryLabel];


        [one makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.top.equalTo(titleLabel);
        }];

        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.left.equalTo(50);
            make.right.lessThanOrEqualTo(-10);
            make.height.greaterThanOrEqualTo(20);
        }];

        [two makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(outsideLabel);
        }];

        [outsideLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
            make.height.greaterThanOrEqualTo(20);
        }];

        [three makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(defectLabel);
        }];

        [defectLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(outsideLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
            make.height.greaterThanOrEqualTo(20);
        }];

        [four makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(one);
            make.top.equalTo(summaryLabel);
        }];

        [summaryLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(defectLabel.bottom).offset(15);
            make.right.lessThanOrEqualTo(-10);
            make.height.greaterThanOrEqualTo(20);
        }];

        if (praise) {
            praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [praiseButton setImage:[UIImage imageNamed:@"auto_common_点赞高亮"] forState:UIControlStateSelected];
            [praiseButton setImage:[UIImage imageNamed:@"auto_common_点赞灰"] forState:UIControlStateNormal];
            [praiseButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [praiseButton addTarget:self action:@selector(praiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            UIImageView *commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_common_回复"]];
            commentImageView.contentMode = UIViewContentModeScaleAspectFit;

            praiseLabel = [self labelWithColor:colorDeepGray];
            commentLabel = [self labelWithColor:colorDeepGray];

            [self addSubview:praiseLabel];
            [self addSubview:commentLabel];
            [self addSubview:praiseButton];
            [self addSubview:commentImageView];

            [praiseButton makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(praiseLabel.left);
                make.height.equalTo(16);
                make.centerY.equalTo(praiseLabel);
                make.width.equalTo(22);
            }];

            [praiseLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(commentLabel);
                make.right.equalTo(commentImageView.left).offset(-10);
            }];

            [commentImageView makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(commentLabel.left);
                make.centerY.equalTo(commentLabel);
                make.height.equalTo(16);
                make.width.equalTo(22);
            }];

            [commentLabel makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(-10);
                make.top.equalTo(summaryLabel.bottom).offset(15);
                make.bottom.equalTo(-10);
            }];

        }else{
            [summaryLabel updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(0);
            }];
        }
    }
    return self;
}

- (void)praiseButtonClick:(UIButton *)btn{
    if (self.model.isAgree) {
        return;
    }

    [self postData];
    [self animateInView:btn];
}

- (UILabel *)labelWithColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = color;
    return label;
}


- (void)setdata:(ReputationModel *)model{
    _model = model;
    titleLabel.text = model.title;
    outsideLabel.attributedText = [self atttributeWithText:model.good];
    defectLabel.attributedText = [self atttributeWithText:model.bad];
    summaryLabel.attributedText = [self atttributeWithText:model.sum];
    praiseLabel.text = model.agree;
    commentLabel.text = model.pl;
    if (praiseButton) {
        praiseButton.selected = _model.isAgree;
    }
}

- (NSAttributedString *)atttributeWithText:(NSString *)text{
    if (text) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
        att.lh_lineSpacing = 3;
        return att;
    }
    return nil;
}

- (void)postData{
    praiseButton.enabled = NO;
    __weak __typeof(self)weakSelf = self;
   [HttpRequest GET:[URLFile url_reputationZanWithID:self.model.ID] success:^(id responseObject) {
    
       if (responseObject[@"success"]) {
           weakSelf.model.isAgree = YES;
           praiseButton.selected = YES;
           NSString *str = [NSString stringWithFormat:@"%ld",[weakSelf.model.agree integerValue] + 1];
           weakSelf.model.agree = str;
           praiseLabel.text = str;
       }
        praiseButton.enabled = YES;
   } failure:^(NSError *error) {
         praiseButton.enabled = YES;
   }];
}

- (void)animateInView:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_common_点赞高亮"]];
    imageView.frame = view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];

    view.hidden = YES;

    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    animation.duration = 0.2;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        if (finish) {
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
            animation.duration = 0.1;
            [animation setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
                if (finish) {
                    [imageView removeFromSuperview];
                    view.hidden = NO;
                }
            }];
            animation.toValue = [NSValue valueWithCGSize:view.lh_size];
            [imageView pop_addAnimation:animation forKey:@"size"];
        }
    }];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(40, 40)];
    [imageView pop_addAnimation:animation forKey:@"size"];
}


@end



@implementation ReputationCell
{
    UILabel *seriesnameLabel;
    UIImageView *iconImageView;
    UILabel *userNameLabel;
    UILabel *dateLabel;
    YYLabel *scoreLabel;
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
    seriesnameLabel = [[UILabel alloc] init];
    seriesnameLabel.textColor = colorBlack;

    iconImageView = [[UIImageView alloc] init];

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = colorLightBlue;
    userNameLabel.font = [UIFont systemFontOfSize:15];

    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = colorLightGray;
    dateLabel.font = [UIFont systemFontOfSize:13];

    scoreLabel = [[YYLabel alloc] init];
//    scoreLabel.font = [UIFont systemFontOfSize:12];
//    scoreLabel.textColor = colorLightGray;
//    scoreLabel.text = @"综合评价：";

    contentView = [[ReputationCellContentView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, 100) praise:YES];

    UIView *_lineView = [UIView new];
    _lineView.backgroundColor = colorBackGround;


    [self.contentView addSubview:seriesnameLabel];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:scoreLabel];
    [self.contentView addSubview:contentView];
    [self.contentView addSubview:_lineView];

    [seriesnameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(13);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(seriesnameLabel.bottom).offset(13);
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
        make.width.equalTo(115);
    }];

    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(dateLabel);
    }];

    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(iconImageView.bottom).offset(10);
    }];

    [_lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(contentView.bottom).offset(15);
        make.height.equalTo(8);
    }];
}

- (void)setModel:(ReputationModel *)model{
    _model = model;

    [contentView setdata:model];

    NSURL *imageUrl = [NSURL URLWithString:model.headurl];
    [iconImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"auto_reputation_avatar"]];


    seriesnameLabel.text = _model.seriesname;
    userNameLabel.text = _model.username;
    dateLabel.text = _model.date;

    LHStarView *starView = [[LHStarView alloc] initWithFrame:CGRectZero draw:NO];
    //[starView setStarWidth:15 space:3];
    [starView setStar:[model.stars floatValue]];


    NSMutableAttributedString *scoreAtt = [[NSMutableAttributedString alloc] initWithString:@"综合评分："];
    scoreAtt.yy_font = [UIFont systemFontOfSize:13];
    scoreAtt.yy_color = colorDeepGray;

    UIImage *image =  [starView getImage];

    CGSize size = CGSizeMake(starView.frame.size.width * (14.0/starView.frame.size.height), 14);
    NSMutableAttributedString *star = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFill attachmentSize:size alignToFont:scoreAtt.yy_font alignment:YYTextVerticalAlignmentCenter];
    [scoreAtt appendAttributedString:star];

    scoreLabel.attributedText = scoreAtt;
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
