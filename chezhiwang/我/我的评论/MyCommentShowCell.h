//
//  MYComplainShowCell.h
//  chezhiwang
//
//  Created by bangong on 16/6/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"
@class MyCommentViewController;

@interface MyCommentShowCell : UITableViewCell

@property (nonatomic,strong) MyCommentModel *model;
@property (nonatomic,weak) MyCommentViewController  *parentViewController;
@end
