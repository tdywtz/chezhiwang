//
//  ComplainChartFirstShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartFirstShowCell.h"

@interface CustomBWQ : UIView
{
    CGPoint _point;
    CGFloat layoutHeight;
}
- (CGFloat)getheight;

@end

@implementation CustomBWQ

-(void)createImageCar:(NSArray *)array{

    if (array.count == 0) return;

    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    _point = CGPointMake(0,0);
    for (int i = 0; i < array.count; i ++) {

        NSDictionary *ceDic = array[i];

        NSString *str1 = [NSString stringWithFormat:@"%@%@",ceDic[@"bw"],@":"];
        CGFloat length1 = [self getStr:str1 andFont:12];
        [self upDataPint:length1];

        UIImageView *immageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, length1+20, 20)];
        UIImage *image1 = [UIImage imageNamed:@"kk(1)"];

        image1 = [image1 stretchableImageWithLeftCapWidth:15 topCapHeight:9];
        immageView1.image=image1;
        immageView1.userInteractionEnabled = YES;
        [self addSubview:immageView1];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, length1+20, 20)];
        label.text = str1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = colorDeepBlue;
        label.font = [UIFont systemFontOfSize:12];

        [immageView1 addSubview:label];
        _point = CGPointMake(immageView1.frame.size.width+immageView1.frame.origin.x, _point.y);

        //
        NSString *str2 = ceDic[@"ques"];
        CGFloat length2 = [self getStr:str2 andFont:12];
        [self upDataPint:length2];
        if (_point.x > 5) {
            _point.x -= 5;
        }
        UIImageView *immageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, length2+20, 20)];
        UIImage* img=[UIImage imageNamed:@"kk1(2)"];//原图

        img = [img stretchableImageWithLeftCapWidth:15 topCapHeight:9];
        immageView2.image=img;
        immageView2.userInteractionEnabled = YES;
        [self addSubview:immageView2];

        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, length2+20, 20)];
        label2.text = str2;
        label2.textColor = colorDeepBlue;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:12];

        [immageView2 addSubview:label2];

        _point = CGPointMake(immageView2.frame.size.width+immageView2.frame.origin.x+5,_point.y);
        if (i == array.count-1) {
            layoutHeight = immageView2.frame.origin.y+immageView2.frame.size.height;
        }
    }
}


#pragma mark - 计算字符串长度
-(CGFloat)getStr:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - 计算坐标
-(void)upDataPint:(CGFloat)length{
    if (length+20+_point.x > WIDTH-105) {
        _point = CGPointMake(0, _point.y+25);
    }
}

- (CGFloat)getheight{
    return layoutHeight;
}
@end

@implementation ComplainChartFirstShowCell
{
    CustomBWQ *BWView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGB_color(246, 247, 248, 1);
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    UILabel * exampleLabel = [LHController createLabelWithFrame:CGRectZero Font:14 Bold:NO TextColor:colorLightGray Text:@"典型故障："];
    BWView = [[CustomBWQ alloc] init];

    [self.contentView addSubview:exampleLabel];
    [self.contentView addSubview:BWView];

    [exampleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(12);
    }];

    [BWView makeConstraints:^(MASConstraintMaker *make) {
       // make.edges.equalTo(UIEdgeInsetsMake(10, 90, 10, 15));
        make.left.equalTo(90);
        make.top.equalTo(10);
        make.right.equalTo(-15);
    }];
}

- (void)setErrorInfo:(NSArray *)errorInfo{
    _errorInfo = errorInfo;


    [BWView createImageCar:errorInfo];
     CGFloat height = [BWView getheight];
   [BWView updateConstraints:^(MASConstraintMaker *make) {
       make.height.equalTo(@(height));
   }];
}


- (CGFloat)getCellHeight{
    return [BWView getheight] + 20;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
