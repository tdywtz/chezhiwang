//
//  ChartDateChooseViewController.h
//  chezhiwang
//
//  Created by bangong on 16/11/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface ChartDateChooseViewController : BasicViewController

@property (nonatomic,copy) void(^chooseDeate)(NSString *beginDate , NSString *endDate);

- (instancetype)initWithChooseDeate:(void(^)(NSString *beginDate , NSString *endDate))chooseDeate;

@end
