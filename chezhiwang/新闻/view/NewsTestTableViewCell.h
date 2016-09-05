//
//  NewsTestTableViewCell.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTestTableViewModel.h"

@interface NewsTestTableViewCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentController;
- (void)setModel:(NewsTestTableViewModel *)model;

@end
