//
//  ForumClassifyViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/28.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
typedef enum {
    onePushTypeRwite,
    onePushTypeList
}onePushType;

typedef void(^returnSid)(NSString *sid,NSString *titile);
/**
 *  品牌论坛
 */
@interface ForumClassifyViewController : BasicViewController

@property (nonatomic,assign) onePushType pushtype;
@property (nonatomic,assign) classifyNext nextType;
@property (nonatomic,copy) returnSid block;

-(void)returnSid:(returnSid)block;
@end
