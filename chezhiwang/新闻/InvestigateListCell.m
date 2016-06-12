//
//  investigateListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "investigateListCell.h"

@implementation InvestigateListCell
{
    UIImageView *imageView;
    UIImageView *subImageView;
    UILabel *modelLabel;
    UILabel *markLabel;
    UILabel *verdictLabel;
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
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 60)];
    [self.contentView addSubview:imageView];
   
    subImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, -5, 44, 38.5)];
    subImageView.image = [UIImage imageNamed:@"hot"];
    [imageView addSubview:subImageView];
    
    modelLabel = [LHController createLabelWithFrame:CGRectMake(100, 10, WIDTH-130, 18) Font:B-5 Bold:NO TextColor:colorDeepGray Text:nil];
    [self.contentView addSubview:modelLabel];
    
    markLabel = [LHController createLabelWithFrame:CGRectMake(100, 28, WIDTH-130, 18) Font:B-5 Bold:NO TextColor:colorDeepGray Text:nil];
    [self.contentView addSubview:markLabel];
   
    verdictLabel = [LHController createLabelWithFrame:CGRectMake(100, 44, WIDTH-130, 40) Font:B-5 Bold:NO TextColor:colorDeepGray Text:nil];
    verdictLabel.numberOfLines = 0;
    [self.contentView addSubview:verdictLabel];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 89, WIDTH, 1)];
    view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [self.contentView addSubview:view];
}

-(void)setDictionary:(NSDictionary *)dictionary{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
    }
    if ([_dictionary[@"hottype"] isEqualToString:@"False"]){
        subImageView.hidden = YES;
    }else{
        subImageView.hidden = NO;
    }

    [imageView sd_setImageWithURL:[NSURL URLWithString:_dictionary[@"image"]] placeholderImage:[UIImage imageNamed:@"load80-60"]];
    
    modelLabel.attributedText   = [self attributeSize:[NSString stringWithFormat:@"调查车型：%@",_dictionary[@"models"]] Font:B-5 Color:[UIColor colorWithRed:0/255.0 green:125/255.0 blue:184/255.0 alpha:1]];
    
    markLabel.attributedText    = [self attributeSize:[NSString stringWithFormat:@"综合评分：%@",_dictionary[@"score"]] Font:B-5 Color:[UIColor colorWithRed:204/255.0 green:5/255.0 blue:10/255.0 alpha:1]];
    
    UIColor *color  = colorBlack;
    for (NSDictionary *dict in self.readArray) {
        if ([dict[@"id"] isEqualToString:_dictionary[@"id"]]) {
            color = colorDeepGray;
        }
    }
    verdictLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"调查结论：%@",_dictionary[@"content"]] Font:B-5 Color:color];
    }

#pragma mark 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str Font:(CGFloat)size Color:(UIColor *)color{
  
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
   //[UIFont fontWithName:@"STHeitiK-Medium" size:size]
    [att addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorDeepGray range:NSMakeRange(0, 5)];
    [att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,att.length)];
    // [att addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:1] range:NSMakeRange(0, att.length)];
    //    NSShadow *shadow = [[NSShadow alloc] init];
    //    shadow.shadowOffset = CGSizeMake(1, 5);
    //    shadow.shadowColor = [UIColor blackColor];
    //    shadow.shadowBlurRadius = 10;
    //
    //    [att addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
//    style.firstLineHeadIndent = 30;
//    style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];

    
    return att;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
