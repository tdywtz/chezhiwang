//
//  NewsListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell
{
    UILabel *titleLabel;
    UILabel *styleLabel;
    UILabel *timeLabel;
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
   
    UIView *fgView;
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

    titleLabel  = [LHController createLabelWithFrame:CGRectMake(10, 10, WIDTH-40, 20) Font:B Bold:NO TextColor:colorBlack Text:nil];
    titleLabel.numberOfLines = 1;
    [self.contentView addSubview:titleLabel];
    

    
    styleLabel = [LHController createLabelWithFrame:CGRectMake(10, 30, 51, 20*(51/61.0)) Font:B-7  Bold:NO TextColor:[UIColor colorWithRed:225/255.0 green:147/255.0 blue:4/255.0 alpha:1] Text:nil];
    styleLabel.textAlignment = NSTextAlignmentCenter;
    styleLabel.backgroundColor = [UIColor whiteColor];
    styleLabel.layer.borderWidth = 1;
    styleLabel.layer.borderColor = styleLabel.textColor.CGColor;
    [self.contentView addSubview:styleLabel];
    
    timeLabel = [LHController createLabelWithFrame:CGRectMake(80, 30, WIDTH-20, 20) Font:B-5 Bold:NO TextColor:colorLightGray Text:nil];
    [self.contentView addSubview:timeLabel];
   
     NSArray *objs = @[@"imageViewOne",@"imageViewTwo",@"imageViewThree"];
    for (int i = 0; i < 3; i ++) {
        UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10+95*i, 60, 90, 60)];
        [self.contentView addSubview:imageView];
        [self setValue:imageView forKey:objs[i]];
    }

    fgView = [[UIView alloc] init];
    fgView.backgroundColor = colorLineGray;
    [self.contentView addSubview:fgView];
}

-(void)setDictionary:(NSDictionary *)dictionary{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
    }
    titleLabel.text = _dictionary[@"title"];
    styleLabel.text = _dictionary[@"stylename"];
    timeLabel.text  = _dictionary[@"date"];
    
    titleLabel.textColor = colorBlack;
    for (NSDictionary *dict in self.readArray) {
        if ([dict[@"id"] isEqualToString:_dictionary[@"id"]]) {
            titleLabel.textColor = colorDeepGray;
        }
    }
    
    CGFloat xx = [self getStr:styleLabel.text andFont:B-5];
  
    styleLabel.frame =CGRectMake(10, 38, xx+5, 14);
    timeLabel.frame = CGRectMake(30+xx, 35, 200, 20);
   
    imageViewOne.image = nil;
    imageViewTwo.image = nil;
    imageViewThree.image = nil;
    
   // NSLog(@"%@",_dictionary[@"image"]);
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_dictionary[@"image"] componentsSeparatedByString:@","]];
    [array removeObject:@""];
  
    for (int i = 0; i < array.count; i ++) {
        if (i == 0) {
            [imageViewOne sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"load80-60"]];

        }else if (i == 1){
            [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"load80-60"]];

        }else if (i == 2){
            [imageViewThree sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"load80-60"]];

        }
    }

   
    if ([_dictionary[@"image"] length] == 0) {
        fgView.frame = CGRectMake(0, 64, WIDTH, 1);
    }else{
        fgView.frame = CGRectMake(0, 129, WIDTH, 1);
    }
}

#pragma mark - 计算字符串长度
-(CGFloat)getStr:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
