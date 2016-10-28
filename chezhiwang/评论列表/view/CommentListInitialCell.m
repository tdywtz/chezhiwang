//
//  CommentListInitialCell.m
//  chezhiwang
//
//  Created by bangong on 16/10/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CommentListInitialCell.h"
#import "CommentListModel.h"

@implementation CommentListInitialCell
{
    UIImageView *iconImageView;
    UILabel *nameLabel;//用户名
    UILabel *floorLabel;//楼层
    CZWLabel *contentLabel;//内容
    UILabel *dateLabel; //日期
    UIButton *button;//回复按钮

    CZWLabel *initialLabel;//原评论
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


    contentLabel = [[CZWLabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    contentLabel.linesSpacing = 4;
    contentLabel.numberOfLines = 0;

    initialLabel = [[CZWLabel alloc] initWithFrame:CGRectZero];
    initialLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    initialLabel.backgroundColor = RGB_color(240, 240, 240, 1);
    initialLabel.numberOfLines = 0;
    initialLabel.linesSpacing = 4;
    initialLabel.textColor = colorDeepGray;
    initialLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];

    
    dateLabel = [LHController createLabelWithFrame:CGRectZero Font:PT_FROM_PX(18) Bold:NO TextColor:nil Text:nil];
    dateLabel.textColor = [UIColor grayColor];

    button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(btnClick) Text:@" 回复"];
     [button setImage:[UIImage imageNamed:@"auto_回复列表_回复"] forState:UIControlStateNormal];
    //[button setImageEdgeInsets:UIEdgeInsetsMake(2, 0, -2, 0)];
    [button setTitleColor:colorLightBlue forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];

    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:floorLabel];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:initialLabel];
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

    [initialLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentLabel);
        make.right.equalTo(-10);
        make.top.equalTo(contentLabel.bottom).offset(10);
    }];


    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(initialLabel.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];

    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.height.equalTo(dateLabel);
        make.bottom.equalTo(dateLabel);
    }];
}
//回复按钮
-(void)btnClick{
    if (self.getPid != nil) {
        self.getPid(_model.p_id);
    }
}

-(void)setModel:(CommentListModel *)model{
    _model = model;

    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.p_logo] placeholderImage:[CZWManager defaultIconImage]];
    nameLabel.text =  _model.p_uname;
    floorLabel.text = [NSString stringWithFormat:@"%@楼",_model.p_floor];
    contentLabel.text = _model.p_content;
    dateLabel.text =  _model.p_time;


    initialLabel.text = [NSString stringWithFormat:@"%@\n%@",_model.initialModel.h_uname,_model.initialModel.h_content];
    [initialLabel addAttributes:@{NSForegroundColorAttributeName:colorLightBlue} range:NSMakeRange(0, _model.initialModel.h_uname.length)];

}




-(void)getPid:(void(^)(NSString *))getpid{
    self.getPid = getpid;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
