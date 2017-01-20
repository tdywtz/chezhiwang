//
//  OverviewView.h
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewStatisticsView.h"



@interface OverviewInfoView : UIView

@end

@interface OverviewView : UIView

@property (nonatomic,copy) updateFrame block;
@property (nonatomic,weak) UIViewController *parentVC;

- (void)setUpdateBlock:(updateFrame)block;

- (void)setDataScore:(NSDictionary *)data;
- (void)setDataStatistics:(NSDictionary *)data;



@end
