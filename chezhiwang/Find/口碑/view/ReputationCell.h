//
//  ReputationCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReputationModel.h"

@interface ReputationCellContentView : UIView

@property (nonatomic,weak) ReputationModel *model;

- (instancetype)initWithFrame:(CGRect)frame praise:(BOOL)praise;
- (void)setdata:(ReputationModel *)model;

@end

@interface ReputationCell : UITableViewCell

@property (nonatomic,strong) ReputationModel *model;

@end
