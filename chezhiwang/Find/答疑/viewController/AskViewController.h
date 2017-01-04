//
//  AskViewController.h
//  auto
//
//  Created by bangong on 15/6/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface AskViewController : BasicViewController

@property (nonatomic,copy) void(^refresh)();

-(void)notifactionRefresh:(void(^)())block;

@end
