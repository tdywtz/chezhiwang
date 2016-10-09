//
//  ForumListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ForumListCell.h"

@implementation ForumListCell
{
    UIImageView *essenceImageView;
    UIImageView *typeImageView;
    UILabel *titleLabel;
    UILabel *userNameLabel;
    UILabel *timeLabel;
    UILabel *answerLabel;
 //   UILabel *inspectLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return  self;
}

-(void)makeUI{
    essenceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    essenceImageView .image = [UIImage imageNamed:@"forum_jing"];
    [self.contentView addSubview:essenceImageView];
    
    typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:typeImageView];
    
    titleLabel = [LHController createLabelWithFrame:CGRectMake(40, 10, WIDTH-60, 20) Font:[LHController setFont] Bold:NO TextColor:colorBlack Text:nil];
    titleLabel.numberOfLines = 1;
    [self.contentView addSubview:titleLabel];
    
    CGFloat sx = WIDTH/375;
    userNameLabel = [LHController createLabelWithFrame:CGRectMake(10, 40, 90*sx, 20) Font:[LHController setFont]-5 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:userNameLabel];
    
    timeLabel = [LHController createLabelWithFrame:CGRectMake(userNameLabel.frame.origin.x+userNameLabel.frame.size.width, 40, 140*sx, 20) Font:[LHController setFont]-5 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:timeLabel];
    

    answerLabel = [LHController createLabelWithFrame:CGRectMake(WIDTH-140*sx, 40, 110*sx, 20) Font:[LHController setFont]-5 Bold:NO TextColor:colorDeepGray Text:nil];
    answerLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:answerLabel];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 69, WIDTH, 1)];
    view.backgroundColor = colorLineGray;
    [self.contentView addSubview:view];
}

-(void)setDictionary:(NSDictionary *)dictionary{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
    }
  
    if ([_dictionary[@"essence"] isEqualToString:@"False"]) {
        essenceImageView.hidden = YES;
        typeImageView.frame = CGRectMake(10, 10, 20, 20);
        titleLabel.frame = CGRectMake(40, 10, WIDTH-60, 20) ;
    }else{
        essenceImageView.hidden = NO;
        typeImageView.frame = CGRectMake(35, 10, 20, 20);
        titleLabel.frame = CGRectMake(65, 10, WIDTH-85, 20) ;
    }
    
    if ([_dictionary[@"type"] integerValue] == 2) {
        typeImageView.image = [UIImage imageNamed:@"forum_ script"];
    }else if ([_dictionary[@"type"] integerValue] == 3){
        typeImageView.image = [UIImage imageNamed:@"forum_image"];
    }else{
       // typeImageView.image = [UIImage imageNamed:@"forum_image"];
    }
    titleLabel.text    = _dictionary[@"title"];
    userNameLabel.text = _dictionary[@"username"];
    timeLabel.text     = _dictionary[@"date"];
    answerLabel.attributedText   = [self attString:[NSString stringWithFormat:@"回复 %@ | 查看 %@",  _dictionary[@"replycount"],  _dictionary[@"viewcount"]] Font:[LHController setFont]-5];
    for (NSDictionary *dict in self.readArray) {
        if ([dict[@"id"] isEqualToString:_dictionary[@"tid"]]) {
            titleLabel.textColor = colorDeepGray;
        }
    }

}

#pragma mark - 属性化字符串
-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size{
    if (!str) {
        return nil ;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:NSMakeRange(0, att.length)];
    for (int i = 0; i < str.length; i ++) {
        unichar C = [str characterAtIndex:i];
        if (isdigit(C)) {
            [att addAttribute:NSForegroundColorAttributeName value:colorDeepGray range:NSMakeRange(i, 1)];
        }
    }
    
    return att;
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
