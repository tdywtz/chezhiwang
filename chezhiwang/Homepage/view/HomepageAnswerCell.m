//
//  HomepageAnswerCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageAnswerCell.h"

@implementation HomepageAnswerCell
{
    UILabel *titleLabel;
    YYLabel *typeLabel;
    UILabel *dateLabel;
    YYLabel *questionLabel;
    YYLabel *answerLabel;
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
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.textColor = colorBlack;
    titleLabel.numberOfLines = 1;
    
    typeLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    typeLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(16)];
    typeLabel.layer.cornerRadius = 3;
    typeLabel.layer.borderWidth = 1;
    typeLabel.textContainerInset = UIEdgeInsetsMake(3, 3, 3, 3);
    typeLabel.preferredMaxLayoutWidth = 200;
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = colorLightGray;

    questionLabel = [YYLabel new];

    answerLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    answerLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    answerLabel.textColor = colorDeepGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:typeLabel];
    [self.contentView addSubview:questionLabel];
    [self.contentView addSubview:answerLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    [typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(10);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(typeLabel);
    }];

    questionLabel.preferredMaxLayoutWidth = WIDTH - 20;
    [questionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(typeLabel.bottom).offset(10);
    }];

    answerLabel.preferredMaxLayoutWidth = WIDTH - 20;
    [answerLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(questionLabel.bottom).offset(5);
        make.right.equalTo(-10);
        make.bottom.equalTo(-10);
    }];
}

- (void)setAnswerModel:(HomepageAnswerModel *)answerModel{
    _answerModel = answerModel;
    [self setData];
}

- (void)setData{
    titleLabel.text = _answerModel.question;
    dateLabel.text = _answerModel.date;

    NSInteger type = [_answerModel.type integerValue];
    if (type == 1) {
        typeLabel.textColor = colorLightBlue;
        typeLabel.text = @"维修保养";

    }else if (type == 2){
        typeLabel.textColor = colorOrangeRed;
        typeLabel.text = @"买车咨询";

    }else if(type == 3){
        typeLabel.textColor = colorGreen;
        typeLabel.text = @"政策法规";
    }

    typeLabel.layer.borderColor = typeLabel.textColor.CGColor;

    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:PT_FROM_PX(19)],NSForegroundColorAttributeName:colorDeepGray};
    NSString *quesionText = [NSString stringWithFormat:@"  提问：%@",_answerModel.content];
    NSMutableAttributedString *quesionAtt = [[NSMutableAttributedString alloc] initWithString:quesionText attributes:dict];
    [quesionAtt yy_setColor:colorLightGray range:[quesionText rangeOfString:@"提问："]];

    NSMutableAttributedString *attachmentAtt = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage imageNamed:@"auto_answerDetail_question"] contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:PT_FROM_PX(19)] alignment:YYTextVerticalAlignmentCenter];
    [quesionAtt insertAttributedString:attachmentAtt atIndex:0];
   
    questionLabel.attributedText = quesionAtt;

    NSString *answerText = [NSString stringWithFormat:@"  回答：%@",_answerModel.answer];
    NSMutableAttributedString *answerAtt = [[NSMutableAttributedString alloc] initWithString:answerText attributes:dict];
    [answerAtt yy_setColor:colorLightGray range:[answerText rangeOfString:@"回答："]];

     attachmentAtt = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage imageNamed:@"auto_answerDetail_answer"] contentMode:UIViewContentModeScaleAspectFill attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:PT_FROM_PX(19)] alignment:YYTextVerticalAlignmentCenter];
    [answerAtt insertAttributedString:attachmentAtt atIndex:0];

    answerLabel.attributedText = answerAtt;
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
