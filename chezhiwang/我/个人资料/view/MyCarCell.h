//
//  MyCarCell.h
//  auto
//
//  Created by bangong on 15/7/24.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCarModel;

#pragma mark - MyCarIconCell
@interface MyCarIconCell : UITableViewCell

@property (nonatomic,strong) MyCarModel *model;

@end

#pragma mark - MyCarCell
@interface MyCarCell : UITableViewCell

@property (nonatomic,strong) MyCarModel *model;

@end
