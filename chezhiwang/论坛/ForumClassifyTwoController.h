//
//  ForumClassifyTwoController.h
//  chezhiwang
//
//  Created by bangong on 15/10/14.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
typedef enum {
    twoPushTypeRwite,
    twoPushTypeList
}twoPushType;

typedef void(^returnCid)(NSString *cid,NSString *title);
/**
 *  栏目论坛
 */
@interface ForumClassifyTwoController : BasicViewController

@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) twoPushType pushtype;
@property (nonatomic,assign) classifyNext nextType;
@property (nonatomic,copy) returnCid block;

-(void)returnCid:(returnCid)block;

@end
