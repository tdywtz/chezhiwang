//
//  ComplainChartFirstCell.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartFirstCell.h"

@implementation ComplainChartFirstCell
{
    UIView *bgView;
    UIView *lineView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *array = @[@"_chartLabel",@"_brandLabel",@"_seriesLabel",@"_modelLabel",@"_numberLabel"];
        for (int i = 0; i < array.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/array.count*i,0, WIDTH/array.count, CGRectGetHeight(self.frame))];
            label.textColor = colorDeepGray;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"--";
            [self.contentView addSubview:label];

            [self setValue:label forKey:array[i]];
        }

        CGRect rect =  _chartLabel.frame;
        rect.size.width -= 16;
        _chartLabel.frame = rect;

        rect = _numberLabel.frame;
        rect.size.width -= 15;
        _numberLabel.frame = rect;
        _numberLabel.textAlignment = NSTextAlignmentRight;

        [self setUp];
    }
    return self;
}

- (void)setUp{
    _numberLabel.textColor = colorYellow;


    bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 3;
    bgView.layer.masksToBounds = YES;
    [self.contentView insertSubview:bgView atIndex:0];

    [bgView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_chartLabel);
        make.size.equalTo(CGSizeMake(20, 20));
    }];


    lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;
    [self.contentView addSubview:lineView];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

-(void)setDictionary:(NSDictionary *)dcitonary{
    if ([dcitonary isKindOfClass:[NSDictionary class]]) {
        _chartLabel.text  = dcitonary[@"num"];
        _brandLabel.text  = dcitonary[@"brandName"];
        _seriesLabel.text = dcitonary[@"seriesName"];
        _modelLabel.text  = dcitonary[@"carAttr"];
        _numberLabel.text = dcitonary[@"count"];
    }else{
        _chartLabel.text  = @"--";
        _brandLabel.text  = @"--";
        _seriesLabel.text = @"--";
        _modelLabel.text  = @"--";
        _numberLabel.text = @"--";
    }
    NSInteger rank = _chartLabel.text.integerValue;
    if (rank == 1) {
        bgView.backgroundColor = RGB_color(229, 0, 18, 1);
    }else if (rank == 2){
        bgView.backgroundColor = RGB_color(242, 172, 2, 1);
    }else if (rank == 3){
        bgView.backgroundColor = RGB_color(190, 191, 192, 1);
    }else{
        bgView.backgroundColor = [UIColor clearColor];
    }

    if (self.draw) {
        lineView.hidden = NO;
    }else{
        lineView.hidden = YES;
    }
}



- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
//    if (self.draw) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetStrokeColorWithColor(context, colorLineGray.CGColor);
//        CGContextSetLineWidth(context, 1);
//        CGContextMoveToPoint(context, 0, rect.size.height-1);
//        CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect)-1);
//        CGContextStrokePath(context);
//    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
