//
//  MyComplainShowCell.h
//  chezhiwang
//
//  Created by bangong on 16/6/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyComplainModel.h"
@class MyComplainViewController;

@interface MyComplainShowCell : UITableViewCell

@property (nonatomic,weak) MyComplainViewController *parentController;
@property (nonatomic,strong) MyComplainModel *model;

@end
