
//
//  MyAskShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/5/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyAskShowCell.h"
#import "MyAskModel.h"

@implementation MyAskShowCell
{
    UILabel *contentLabel;
    UILabel *expertlabel;
    UILabel *answerDate;
    CGFloat B;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    
    return self;
}

-(void)makeUI{
    B = [LHController setFont];
    
    UILabel * contentTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    contentTitle.text = @"提问内容:";
    contentTitle.textColor = colorLightGray;
    contentTitle.font = [UIFont systemFontOfSize:B-2];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.font = [UIFont systemFontOfSize:B-3];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = colorBlack;
   
    
    UILabel *expert = [[UILabel alloc] initWithFrame:CGRectZero];
    expert.text = @"专家回答:";
    expert.textColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1];
    expert.font = [UIFont systemFontOfSize:B-2];
   
    
    expertlabel = [[UILabel alloc] initWithFrame:CGRectZero];
    expertlabel.font = [UIFont systemFontOfSize:B-3];
    expertlabel.numberOfLines = 0;
    expertlabel.textColor = colorBlack;
   
    
    answerDate = [[UILabel alloc] initWithFrame:CGRectZero];
    answerDate.font = [UIFont systemFontOfSize:B-5];
    answerDate.textColor = colorLightGray;
    answerDate.textAlignment = NSTextAlignmentRight;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor  = colorLineGray;
    
    [self.contentView addSubview:contentTitle];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:expert];
    [self.contentView addSubview:expertlabel];
    [self.contentView addSubview:answerDate];
    [self.contentView addSubview:line];
    
    [contentTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
    }];
    
    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(contentTitle.bottom).offset(5);
        make.right.equalTo(-10);
    }];
    
    [expert makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(contentLabel.bottom).offset(10);
    }];
    
    [expertlabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.top.equalTo(expert.bottom).offset(5);
    }];
    
    [answerDate makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(expertlabel.bottom).offset(5);
        make.bottom.equalTo(-10);
    }];
    
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

-(void)setModel:(MyAskModel *)model{
    contentLabel.text = model.question;
    expertlabel.text = model.answer;
    answerDate.text = model.answerdate;
}
@end
