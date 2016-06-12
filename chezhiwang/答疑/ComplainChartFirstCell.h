//
//  ComplainChartFirstCell.h
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainChartFirstCell : UITableViewCell

@property (nonatomic,strong) UILabel *chartLabel;
@property (nonatomic,strong) UILabel *brandLabel;
@property (nonatomic,strong) UILabel *seriesLabel;
@property (nonatomic,strong) UILabel *modelLabel;
@property (nonatomic,strong) UILabel *numberLabel;

-(void)setDictionary:(NSDictionary *)dcitonary;
@end
