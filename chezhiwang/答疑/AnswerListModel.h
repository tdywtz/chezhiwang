//
//  AnswerListModel.h
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerListModel : NSObject

@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *type;

@end
