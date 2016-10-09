

//
//  MYComplainShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/6/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyCommentShowCell.h"
#import "ComplainDetailsViewController.h"
#import "AnswerDetailsViewController.h"
#import "MyCommentViewController.h"

@implementation MyCommentShowCell
{
    UILabel *contentLabel;
    UILabel *dateLabel;
    UIView *lineView;
    CGFloat B;
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
    
    B =  [LHController setFont];
    UILabel *myComment = [[UILabel alloc] init];
    myComment.font = [UIFont systemFontOfSize:B-2];
    myComment.textColor = colorLightGray;
    myComment.text = @"我的评论：";
    
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:B-2];
    contentLabel.textColor = colorBlack;
    
    
    dateLabel  = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:B-5];
    dateLabel.textColor = colorLightGray;
    
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;
    
    UIButton *button = [LHController createButtnFram:CGRectZero Target:self Action:@selector(buttonClick) Font:15 Text:@"进入文章"];
    
    [self.contentView addSubview:myComment];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:lineView];
    [self.contentView addSubview:button];
    
    [myComment makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.right.equalTo(-40);
    }];
    
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(myComment.bottom).offset(10);
        make.right.equalTo(-40);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(contentLabel.bottom).offset(10);
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(0);
        make.top.equalTo(dateLabel.bottom).offset(15);
        make.height.equalTo(1);
    }];
    
    [button makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.bottom.equalTo(-10);
        make.size.equalTo(CGSizeMake(80, 20));
    }];
}

- (void)buttonClick{
    if ([self.model.type isEqualToString:@"3"]) {
        AnswerDetailsViewController *an = [[AnswerDetailsViewController alloc] init];
        an.textTitle = self.model.title;
        an.cid = self.model.ID;
        an.type = self.model.type;
        [self.parentViewController.navigationController pushViewController:an animated:YES];
        
    }else{
        ComplainDetailsViewController *user = [[ComplainDetailsViewController alloc] init];
        user.textTitle = self.model.title;
        user.cid = self.model.ID;
        user.type = self.model.type;
        [self.parentViewController.navigationController pushViewController:user animated:YES];
    }
}

-(void)setModel:(MyCommentModel *)model{
    _model = model;
    
    contentLabel.text = _model.content;
    dateLabel.text = _model.date;
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
