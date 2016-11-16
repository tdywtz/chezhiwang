//
//  HomepageForumModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepageForumModel : NSObject

@property (nonatomic,copy) NSString *date;
@property (nonatomic,assign) BOOL essence;//是否精华
@property (nonatomic,copy) NSString *replycount;
@property (nonatomic,copy) NSString *tid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *viewcount;

@end
