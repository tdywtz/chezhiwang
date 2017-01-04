//
//  ComplainChartSecondHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  排行榜列表第二分组头部视图
 */
@interface ComplainChartSecondHeaderView : UIView

/**
 *  0->厂家满意度   1->车主满意度  2->新车调查排行
 */
@property (nonatomic,assign) NSInteger current;

@property (nonatomic,copy) void (^click)(NSInteger index);

@end
