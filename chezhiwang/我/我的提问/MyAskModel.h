//
//  MyAskModel.h
//  auto
//
//  Created by bangong on 15/6/12.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAskModel : NSObject

@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *answerdate;

@property (nonatomic,assign) BOOL isOpen;
@end
