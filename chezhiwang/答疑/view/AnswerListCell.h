//
//  AnswerListCell.h
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerListModel.h"

@interface AnswerListCell : UITableViewCell

@property (nonatomic,strong) AnswerListModel *model;
@property (nonatomic,strong) NSArray *readArray;
@end
