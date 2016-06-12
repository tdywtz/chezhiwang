//
//  ComplainChartFirstCell.m
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartFirstCell.h"

@implementation ComplainChartFirstCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *array = @[@"_chartLabel",@"_brandLabel",@"_seriesLabel",@"_modelLabel",@"_numberLabel"];
        for (int i = 0; i < array.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/array.count*i,0, WIDTH/array.count, CGRectGetHeight(self.frame))];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"--";
            [self.contentView addSubview:label];
            
            [self setValue:label forKey:array[i]];
        }
    }
    return self;
}

-(void)setDictionary:(NSDictionary *)dcitonary{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
