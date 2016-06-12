//
//  AnswerListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AnswerListCell.h"

@implementation AnswerListCell
{
    UILabel *questionLabel;
    UIImageView *imageView;
    UILabel *answerLabel;
    UILabel *dateLabel;
    UILabel *typeLabel;
    
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
    
    B = [LHController setFont];
    
   questionLabel = [LHController createLabelWithFrame:CGRectMake(15, 15, WIDTH-30, 20) Font:B Bold:NO TextColor:[UIColor blackColor] Text:nil];
    questionLabel.textColor = colorBlack;
    [self.contentView addSubview:questionLabel];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, 70, 20)];
    [self.contentView addSubview:imageView];
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 68, 18)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.font = [UIFont systemFontOfSize:B-3];
    typeLabel.backgroundColor = [UIColor whiteColor];
    [imageView addSubview:typeLabel];
    
    dateLabel = [LHController createLabelWithFrame:CGRectMake(100, 45, 200, 20) Font:B-5 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:dateLabel];
    
    answerLabel = [LHController createLabelWithFrame:CGRectMake(15, 70, WIDTH-45, 40) Font:B-3 Bold:NO TextColor:colorDeepGray Text:nil];
    answerLabel.numberOfLines = 0;
    [self.contentView addSubview:answerLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 124, WIDTH, 1)];
    view.backgroundColor = colorLineGray;
    [self.contentView addSubview:view];
}


-(void)setModel:(AnswerListModel *)model{
    if (_model != model) {
        _model = model;
    }
    questionLabel.text = _model.question;
    answerLabel.text   = _model.answer;
    dateLabel.text     = _model.date;
    
    questionLabel.textColor = colorBlack;
    
    for (NSDictionary *dict in self.readArray) {
        if ([dict[@"id"] isEqualToString:_model.uid]) {
            questionLabel.textColor = colorDeepGray;
        }
    }
    
    if ([_model.type isEqualToString:@"1"] || [_model.type isEqualToString:@"0"]) {
        typeLabel.text = @"维修保养";
        imageView.image = [UIImage imageNamed:@"zj"];
        typeLabel.textColor = [UIColor colorWithRed:78/255.0 green:191/255.0 blue:243/255.0 alpha:1];
       
    }else if ([_model.type isEqualToString:@"2"]){
        typeLabel.text = @"买车咨询";
        imageView.image = [UIImage imageNamed:@"yellow"];
         typeLabel.textColor = colorYellow;
    }else if([_model.type isEqualToString:@"3"]){
        typeLabel.text = @"政策法规";
        imageView.image = [UIImage imageNamed:@"green"];
        typeLabel.textColor = [UIColor colorWithRed:27/255.0 green:188/255.0 blue:157/255.0 alpha:1];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
