//
//  ComplainChartView.h
//  chezhiwang
//
//  Created by bangong on 16/5/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  排行榜列表头部视图
 */
@interface ComplainChartView : UIView

@property (nonatomic,copy) void(^block)(NSInteger index);

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles block:(void(^)(NSInteger index))block;

-(void)setTitle:(NSString *)title index:(NSInteger)index;
@end
