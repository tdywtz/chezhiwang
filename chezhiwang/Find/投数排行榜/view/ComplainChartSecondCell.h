//
//  ComplainChartSecondCell.h
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplainChartSecondModel.h"

/**
 *  回复率列表cell
 */
@interface ComplainChartSecondCell : UITableViewCell
/**
 *  排序
 */
@property (nonatomic,strong) UILabel *chartLabel;
/**
 *  品牌
 */
@property (nonatomic,strong) UILabel *brandLabel;
/**百分比*/
@property (nonatomic,strong) UILabel *percentageLabel;

- (void)setModel:(ComplainChartSecondModel *)model;
@end
