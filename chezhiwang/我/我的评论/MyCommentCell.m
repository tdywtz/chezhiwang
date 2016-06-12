//
//  MyComplainCell.m
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCommentCell.h"

@implementation MyCommentCell
{
    UILabel *titleLabel;
    UILabel *timeLabel;

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
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, WIDTH-30, 20)];
    titleLabel.font = [UIFont systemFontOfSize:B];
    titleLabel.textColor = colorBlack;
   
    
    timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, WIDTH-30, 20)];
    timeLabel.font = [UIFont systemFontOfSize:B-5];
    timeLabel.textColor = colorLightGray;
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-25, 40, 15, 15)];
    imageView.image = [UIImage imageNamed:@"top"];
    
    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:lineView];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.right.equalTo(-40);
    }];
    
    [timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(15);
    }];
    
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.centerY.equalTo(0);
    }];
    
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(0);
        make.top.equalTo(timeLabel.bottom).offset(15);
        make.height.equalTo(1);
    }];
}

-(void)setModel:(MyCommentModel *)model{
   
    _model = model;
    
    timeLabel.text = _model.issuedate;
    titleLabel.text = _model.title;
    if (_model.isOpen) {
        lineView.backgroundColor = [UIColor whiteColor];
         imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        lineView.backgroundColor = colorLineGray;
         imageView.transform = CGAffineTransformIdentity;
    }
}

//按钮
-(void)btnClick{
//    [self.delegate toViewControllerWith:_model.ID andTitle:_model.title andType:_model.type];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
