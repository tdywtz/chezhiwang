
//  MyCarCell.m
//  auto
//
//  Created by bangong on 15/7/24.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCarCell.h"
#import "MyCarModel.h"

#pragma mark - MyCarIconCell
@implementation MyCarIconCell
{
    UILabel *nameLabel;
    UIImageView *iconImageView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = colorBlack;

        iconImageView = [[UIImageView alloc] init];
        iconImageView.contentMode = UIViewContentModeCenter;

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = colorLineGray;


        [self.contentView addSubview:nameLabel];
        [self.contentView addSubview:iconImageView];
        [self.contentView addSubview:lineView];

        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
        }];

        iconImageView.layer.cornerRadius = 35;
        iconImageView.layer.masksToBounds = YES;
        [iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-30);
            make.centerY.equalTo(0);
            make.size.equalTo(CGSizeMake(70, 70));
        }];

        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(0);
            make.height.equalTo(1);
        }];

    }
    return self;
}

- (void)setModel:(MyCarModel *)model{
    _model = model;

    nameLabel.text = _model.name;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.value] placeholderImage:[CZWManager defaultIconImage]];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, colorLightGray.CGColor);

    CGFloat length = 7;
    CGFloat y = rect.size.height/2;
    CGFloat x = rect.size.width - 12;
    CGContextMoveToPoint(context, x-length, y-length);
    CGContextAddLineToPoint(context, x, y);
    CGContextAddLineToPoint(context, x-length, y+length);

    CGContextStrokePath(context);
}

@end


#pragma mark - MyCarCell
@implementation MyCarCell
{
    UILabel *nameLabel;
    UILabel *valueLabel;

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //创建UI
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = colorBlack;
    nameLabel.font = [UIFont systemFontOfSize:15];

    valueLabel = [[UILabel alloc] init];
    valueLabel.font = [UIFont systemFontOfSize:15];
    valueLabel.textColor = colorDeepGray;

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:valueLabel];
    [self.contentView addSubview:lineView];

    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
    }];

    [valueLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-30);
        make.centerY.equalTo(0);
        make.left.greaterThanOrEqualTo(80);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}


-(void)setModel:(MyCarModel *)model{
 
    _model = model;

    nameLabel.text = _model.name;
    valueLabel.text = _model.value;
    if (_model.value.length == 0) {
        valueLabel.text = _model.placeholder;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    if (_model.isEnable) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, colorLightGray.CGColor);

        CGFloat length = 7;
        CGFloat y = rect.size.height/2;
        CGFloat x = rect.size.width - 12;
        CGContextMoveToPoint(context, x-length, y-length);
        CGContextAddLineToPoint(context, x, y);
        CGContextAddLineToPoint(context, x-length, y+length);
        
        CGContextStrokePath(context);
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
