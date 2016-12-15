//
//  MyComplainCell.m
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentCell.h"
#import "ComplainDetailsViewController.h"
#import "AnswerDetailsViewController.h"

@implementation MyCommentCell
{
    UIImageView *iconImageView;
    UILabel *userNameLabel;
    UILabel *dateLabel;
    UILabel *contentLabel;
    CZWLabel *titleLabel;
    UIView *lineView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //创建UI
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];

    userNameLabel = [[UILabel alloc] init];
    userNameLabel.font = [UIFont systemFontOfSize:17];
    userNameLabel.textColor = colorLightBlue;

    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textColor = colorLightGray;

    contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:17];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = colorBlack;

    titleLabel = [[CZWLabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = colorDeepGray;
    titleLabel.textInsets = UIEdgeInsetsMake(0, 10, 2, 10);
    titleLabel.layer.borderColor = colorLineGray.CGColor;
    titleLabel.layer.borderWidth = 1;
    titleLabel.userInteractionEnabled = YES;
    [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTap)]];

    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;
    
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:lineView];

    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.size.equalTo(CGSizeMake(40, 40));
    }];

    [userNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(15);
        make.right.lessThanOrEqualTo(-10);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.top.equalTo(userNameLabel.bottom).offset(5);
    }];

    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.top.equalTo(dateLabel.bottom).offset(10);
        make.right.equalTo(-10);
    }];


    titleLabel.layer.cornerRadius = 15;
    titleLabel.layer.masksToBounds = YES;
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.height.equalTo(30);
        make.right.lessThanOrEqualTo(-10);
        make.top.equalTo(contentLabel.bottom).offset(10);
    }];


    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(0);
        make.top.equalTo(titleLabel.bottom).offset(15);
        make.height.equalTo(1);
    }];
}

- (void)titleLabelTap{
    if ([self.model.type isEqualToString:@"3"]) {
        AnswerDetailsViewController *an = [[AnswerDetailsViewController alloc] init];

        an.cid = self.model.ID;

        [self.parentViewController.navigationController pushViewController:an animated:YES];

    }else{
        ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
        user.cid = self.model.ID;
        [self.parentViewController.navigationController pushViewController:user animated:YES];
    }
}

-(void)setModel:(MyCommentModel *)model{
   
    _model = model;

    [iconImageView sd_setImageWithURL:[NSURL URLWithString:[CZWManager manager].iconUrl] placeholderImage:[CZWManager defaultIconImage]];
    userNameLabel.text = [CZWManager manager].userName;
    dateLabel.text = model.date;

    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:model.content];
    contentText.lh_lineSpacing = 4;

    contentLabel.attributedText = contentText;


    NSString *title = [NSString stringWithFormat:@"标题：%@ ", model.title];
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    [titleText setLh_colorWithColor:colorLightGray range:NSMakeRange(0, 3)];
    [titleText appendWithImage:[UIImage imageNamed:@"arrow"] frame:CGRectMake(0, -3, 17, 17)];

    titleLabel.attributedText = titleText;
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
