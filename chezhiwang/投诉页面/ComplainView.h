//
//  Complain2.h
//  auto
//
//  Created by bangong on 15/6/4.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"


@interface ComplainView : BasicViewController

@property (nonatomic,assign) BOOL siChange;
@property (nonatomic,strong) NSDictionary *dictionary;
@property (nonatomic,assign) BOOL again;//是否为再投诉
@property (nonatomic,copy) NSString *Cpid;

@property (nonatomic,copy) void(^updata)();

-(void)notifacation:(void(^)())block;

@end
