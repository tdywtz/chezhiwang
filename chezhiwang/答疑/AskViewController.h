//
//  AskViewController.h
//  auto
//
//  Created by bangong on 15/6/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"

@interface AskViewController : BasicViewController

@property (nonatomic,assign) BOOL isLogoIn;//是否从主界面过来
@property (nonatomic,assign) NSInteger viewIndex;
@property (nonatomic,assign) BOOL isMyAsk;
@property (nonatomic,copy) void(^refresh)();

-(void)notifactionRefresh:(void(^)())block;

@end
