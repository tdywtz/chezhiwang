//
//  CommentListCell.h
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getHeight)(CGFloat gao);
typedef void(^getPid)(NSString *pid);

@interface CommentListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dictionary;
@property (nonatomic,copy) getHeight block;
@property (nonatomic,copy) getPid getpid;
@property (nonatomic,assign) CGFloat yy;

-(void)getHeight:(getHeight)block;
-(void)getPid:(getPid)getpid;
+(instancetype)manager;
+(CGFloat)returnCellHeight:(NSDictionary *)dict;
@end
