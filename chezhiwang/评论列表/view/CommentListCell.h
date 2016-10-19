//
//  CommentListCell.h
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "CommentListModel.h"

typedef void(^getPid)(NSString *pid);

/**
 评论文章内容的
 */
@interface CommentListCell : BasicTableViewCell

@property (nonatomic,copy) getPid getpid;
@property (nonatomic,strong) CommentListModel *model;

-(void)getPid:(getPid)getpid;

@end
