//
//  MyComplainCell.h
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentModel.h"

@interface MyCommentCell : UITableViewCell

@property (nonatomic,strong) MyCommentModel *model;
@property (nonatomic,weak) UIViewController  *parentViewController;

@end
