//
//  BasicTableViewCell.h
//  chezhiwang
//
//  Created by luhai on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;//标题
@property (nonatomic,strong) UILabel *dateLabel;//日期
@property (nonatomic,strong) UILabel *content;//内容
@property (nonatomic,strong) UIView *lineView;

@end
