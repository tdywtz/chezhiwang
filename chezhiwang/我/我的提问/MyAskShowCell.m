
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
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    
    return self;
}

-(void)makeUI{

    UIImageView *questionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_answerDetail_answer"]];
    questionImageView.contentMode = UIViewContentModeScaleAspectFit;

    UIImageView *answerIamgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_answerDetail_question"]];
    answerIamgeView.contentMode = UIViewContentModeScaleAspectFit;

    
    UILabel * contentTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    contentTitle.text = @"提问内容:";
    contentTitle.textColor = colorDeepGray;
    contentTitle.font = [UIFont systemFontOfSize:15];
    
    contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = colorBlack;
   
    
    UILabel *expert = [[UILabel alloc] initWithFrame:CGRectZero];
    expert.text = @"专家回答:";
    expert.textColor = colorDeepGray;
    expert.font = [UIFont systemFontOfSize:15];
   
    
    expertlabel = [[UILabel alloc] initWithFrame:CGRectZero];
    expertlabel.font = [UIFont systemFontOfSize:14];
    expertlabel.numberOfLines = 0;
    expertlabel.textColor = colorBlack;
   
    
    answerDate = [[UILabel alloc] initWithFrame:CGRectZero];
    answerDate.font = [UIFont systemFontOfSize:12];
    answerDate.textColor = colorLightGray;
    answerDate.textAlignment = NSTextAlignmentRight;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor  = colorLineGray;

    [self.contentView addSubview:answerIamgeView];
    [self.contentView addSubview:questionImageView];
    [self.contentView addSubview:contentTitle];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:expert];
    [self.contentView addSubview:expertlabel];
    [self.contentView addSubview:answerDate];
    [self.contentView addSubview:line];

    [answerIamgeView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(contentTitle.centerY);
        make.size.equalTo(CGSizeMake(18, 18));
    }];

    [contentTitle makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(answerIamgeView.right).offset(10);
        make.top.equalTo(10);
    }];

    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentTitle);
        make.top.equalTo(contentTitle.bottom).offset(5);
        make.right.equalTo(-10);
    }];


    [questionImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(expert);
        make.size.equalTo(CGSizeMake(18, 18));
    }];


    [expert makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionImageView.right).offset(10);
        make.top.equalTo(contentLabel.bottom).offset(10);
    }];
    
    [expertlabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expert);
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
