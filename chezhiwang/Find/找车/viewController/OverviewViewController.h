//
//  OverviewViewController.h
//  chezhiwang
//
//  Created by bangong on 16/12/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"

/**
 综述
 */
@interface OverviewViewController : BasicViewController

@property (nonatomic,assign) UIEdgeInsets contentInsets;
@property (nonatomic,copy) NSString * seriesID;//
@property (nonatomic,copy) void (^moreClick)(NSInteger idx);
@end
