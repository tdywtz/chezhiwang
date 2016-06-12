//
//  RegisterViewController.h
//  auto
//
//  Created by bangong on 15/6/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
@interface RegisterViewController : BasicViewController

@property (nonatomic,copy) void(^succeed)(NSString *name,NSString *passwoed);

-(void)login:(void(^)(NSString *name,NSString *passwoed))block;

@end
