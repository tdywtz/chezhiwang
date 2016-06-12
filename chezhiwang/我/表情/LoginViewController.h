//
//  LoginViewController.h
//  chezhiwang
//
//  Created by bangong on 15/11/13.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
typedef enum {
    pushTypeDefault,
    pushTypePopView,
    pushTypeToComplainView,
    pushTypeToAsk
}pushType;

@interface LoginViewController : BasicViewController

//@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) BOOL isRoot;
@property (nonatomic,assign) pushType pushPop;

@end
