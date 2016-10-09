


//
//  MyAskCell.m
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyAskCell.h"

@implementation MyAskCell
{
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *haveLabel;
    UIImageView *imageView;
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

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, WIDTH-40, 20)];
    titleLabel.textColor = colorBlack;
    titleLabel.font = [UIFont systemFontOfSize:B];

    haveLabel = [[UILabel alloc] init];
    haveLabel.textAlignment  = NSTextAlignmentCenter;
    haveLabel.font = [UIFont systemFontOfSize:B-5];
    haveLabel.layer.cornerRadius = 2;
    haveLabel.layer.masksToBounds = YES;
    haveLabel.layer.borderWidth = 1;
 
    timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:B-5];
    timeLabel.textColor = colorLightGray;
   
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-20, 30, 15, 15)];
    imageView.image = [UIImage imageNamed:@"arrowu"];
   
  
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, WIDTH, 1)];
    lineView.backgroundColor = colorLineGray;;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:haveLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:lineView];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.right.lessThanOrEqualTo(-40);
    }];
    
    [haveLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(60, 18));
    }];
    
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(haveLabel.right).offset(10);
        make.centerY.equalTo(haveLabel);
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(haveLabel.bottom).offset(10);
        make.left.bottom.and.right.equalTo(0);
        make.height.equalTo(1);
    }];

    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-20);
        make.centerY.equalTo(0);
    }];
}

-(void)setModel:(MyAskModel *)model{
 
    _model = model;
    
   
    if (_model.isOpen) {
        lineView.backgroundColor = [UIColor whiteColor];
        imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        lineView.backgroundColor = colorLineGray;
        imageView.transform = CGAffineTransformIdentity;
    }
   
    if (_model.answer.length > 0) {
        haveLabel.text = @"已回复";
        haveLabel.textColor = colorDeepBlue;
    
    }else{
        haveLabel.text = @"未回复";
        haveLabel.textColor = colorYellow;
    }
    haveLabel.layer.borderColor = haveLabel.textColor.CGColor;

    
    timeLabel.text = _model.date;
    titleLabel.text = _model.question;

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [df objectForKey:YorNO];
    if (![dic[_model.cid] isEqualToString:@"1"]) {
        UIView *viv = [self.contentView viewWithTag:100];
        if (viv == nil) {
            [timeLabel layoutIfNeeded];
            UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, titleLabel.frame.origin.y+8, 6, 6)];
            
            redView.backgroundColor = [UIColor redColor];
            redView.tag = 100;
            redView.layer.cornerRadius = 3;
            redView.layer.masksToBounds = YES;
            [self.contentView addSubview:redView];
        }
    }else{
        UIView *viv = [self.contentView viewWithTag:100];
        [viv removeFromSuperview];
    }
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
