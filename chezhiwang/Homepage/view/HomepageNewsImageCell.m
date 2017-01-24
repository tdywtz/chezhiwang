//
//  HomepageNewsImageCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageNewsImageCell.h"

@implementation HomepageNewsImageCell
{
    UILabel *titleLabel;
    TTTAttributedLabel *stylenamelabel;
    UILabel *dateLabel;
    UIImageView *imageView1;
    UIImageView *imageView2;
    UIImageView *imageView3;
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
    
    stylenamelabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    stylenamelabel.textInsets = UIEdgeInsetsMake(1, 3, 1, 3);
    stylenamelabel.font = [UIFont systemFontOfSize:PT_FROM_PX(16.5)];
    stylenamelabel.textColor = colorOrangeRed;
    stylenamelabel.layer.cornerRadius = 3;
    stylenamelabel.layer.borderWidth = 1;
    stylenamelabel.layer.borderColor = stylenamelabel.textColor.CGColor;

    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = colorLightGray;

    imageView1 = [[UIImageView alloc] init];
    imageView2 = [[UIImageView alloc] init];
    imageView3 = [[UIImageView alloc] init];

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:stylenamelabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:imageView1];
    [self.contentView addSubview:imageView2];
    [self.contentView addSubview:imageView3];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];

    CGFloat width = (WIDTH-40)/3;
    CGFloat height = width/1.4;
    [imageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(10);
        make.size.equalTo(CGSizeMake(width, height));
    }];

    [imageView2 makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(imageView1.right).offset(10);
        make.top.equalTo(imageView1);
        make.size.equalTo(CGSizeMake(width, height));
    }];

    [imageView3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.right).offset(10);
        make.top.equalTo(imageView2);
        make.size.equalTo(CGSizeMake(width, height));
    }];

    [stylenamelabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(imageView1.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];

    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stylenamelabel.right).offset(10);
        make.centerY.equalTo(stylenamelabel);
    }];
}

- (void)setNewsModel:(HomepageNewsModel *)newsModel{
    _newsModel = newsModel;
    [self setData];
}

- (void)setData{
    titleLabel.text = self.newsModel.title;
    stylenamelabel.text = self.newsModel.stylename;
    dateLabel.text = self.newsModel.date;

    imageView1.image = nil;
    imageView2.image = nil;
    imageView3.image = nil;
    
    NSArray *array = [self.newsModel.image componentsSeparatedByString:@","];
    for (int i = 0; i < array.count; i ++) {
        if (i == 0) {
            [imageView1 sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[CZWManager defaultIconImage]];
        }
        if (i == 1) {
             [imageView2 sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[CZWManager defaultIconImage]];
        }
        if (i == 2) {
            [imageView3 sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[CZWManager defaultIconImage]];
        }
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
