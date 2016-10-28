//
//  CommentListInitialCell.h
//  chezhiwang
//
//  Created by bangong on 16/10/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicTableViewCell.h"
@class CommentListModel;
/**
 有回复和评论
 */
@interface CommentListInitialCell : BasicTableViewCell

@property (nonatomic,strong) CommentListModel *model;

@property (nonatomic,strong) void(^getPid)(NSString *pid);

-(void)getPid:(void(^)(NSString *))getpid;
@end
