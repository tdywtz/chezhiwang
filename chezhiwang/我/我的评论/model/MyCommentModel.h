//
//  MyComplainModel.h
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *issuedate;//提问时间
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *date;//评论时间

@end
