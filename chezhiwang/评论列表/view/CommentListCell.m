//
//  CommentListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CommentListCell.h"

@implementation CommentListCell
{
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *contentLabel;
    UILabel *dateLabel;
    UIButton *button;
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

    iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = 20;
    iconImageView.layer.masksToBounds = YES;

    nameLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(23) Bold:NO TextColor:colorLightBlue Text:nil];

    contentLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(19) Bold:NO TextColor:nil Text:nil];
    contentLabel.numberOfLines = 0;

    dateLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(18) Bold:NO TextColor:nil Text:nil];
    dateLabel.textColor = [UIColor grayColor];

    button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(btnClick) Text:@"回复"];
    [button setTitleColor:colorLightBlue forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];

    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:button];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.size.equalTo(CGSizeMake(40, 40));
    }];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.centerY.equalTo(iconImageView);
    }];

    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(iconImageView.bottom).offset(10);
        make.right.equalTo(-10);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(contentLabel.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];

    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(dateLabel);
    }];
}
//回复按钮
-(void)btnClick{
    if (self.getpid != nil) {
        self.getpid(_model.h_id);
    }
}

-(void)setModel:(CommentListModel *)model{
    _model = model;

    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.h_logo] placeholderImage:[CZWManager defaultIconImage]];
    nameLabel.text = _model.h_uname;
    contentLabel.text = _model.h_content;
    dateLabel.text = model.h_time;

    nameLabel.text = @"kasjfgkldgjdfklgjfdlkgjfl";
    contentLabel.text = @"垃圾分类及规范吉林省的感觉扩散到了刚好是联合范吉林省的感觉扩散到了刚好是联合范吉林省的感觉扩散到了刚好是联合国看电视法规或打开了刚好是工行了";
    dateLabel.text = @"456456";
}




-(void)getPid:(getPid)getpid{
    self.getpid = getpid;
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
