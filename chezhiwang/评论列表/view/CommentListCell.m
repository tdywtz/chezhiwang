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
    UILabel *nameLabel;//用户名
    UILabel *floorLabel;//楼层
    UILabel *contentLabel;//评论内容
    UILabel *dateLabel;//日期
    UIButton *button;//回复按钮
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

    floorLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(18) Bold:NO TextColor:colorLightGray Text:nil];

    contentLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(19) Bold:NO TextColor:nil Text:nil];
    contentLabel.numberOfLines = 0;

    dateLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(18) Bold:NO TextColor:nil Text:nil];
    dateLabel.textColor = [UIColor grayColor];

    button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(btnClick) Text:@" 回复"];
  //  [button setImageEdgeInsets:UIEdgeInsetsMake(1, 0, -1, 0)];
    [button setImage:[UIImage imageNamed:@"auto_回复列表_回复"] forState:UIControlStateNormal];
    [button setTitleColor:RGB_color(64, 124, 207, 1) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];

    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:floorLabel];
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

    [floorLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(nameLabel.top);
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
        self.getpid(_model.p_id);
    }
}

-(void)setModel:(CommentListModel *)model{
    _model = model;

    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.p_logo] placeholderImage:[CZWManager defaultIconImage]];
    nameLabel.text = _model.p_uname;
    floorLabel.text = [NSString stringWithFormat:@"%@楼",_model.p_floor];;
    contentLabel.text = _model.p_content;
    dateLabel.text = model.p_time;
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
