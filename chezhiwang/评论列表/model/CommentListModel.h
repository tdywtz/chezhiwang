//
//  CommentListModel.h
//  chezhiwang
//
//  Created by bangong on 16/10/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentListInitialModel : NSObject

@property (nonatomic,copy) NSString *h_content;
@property (nonatomic,copy) NSString *h_id;
@property (nonatomic,copy) NSString *h_logo;
@property (nonatomic,copy) NSString *h_time;
@property (nonatomic,copy) NSString *h_uid;
@property (nonatomic,copy) NSString *h_uname;

@end

@interface CommentListModel : NSObject

@property (nonatomic,copy) NSString *p_content;
@property (nonatomic,copy) NSString *p_floor;
@property (nonatomic,copy) NSString *p_id;
@property (nonatomic,copy) NSString *p_logo;
@property (nonatomic,copy) NSString *p_time;
@property (nonatomic,copy) NSString *p_uid;
@property (nonatomic,copy) NSString *p_uname;

@property (nonatomic,strong) CommentListInitialModel *initialModel;//原始评论

@end
