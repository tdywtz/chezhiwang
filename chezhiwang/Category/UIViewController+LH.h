//
//  UIViewController+LH.h
//  chezhiwang
//
//  Created by bangong on 16/5/18.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnima.h"

@interface UIViewController (LH)

@property (nonatomic,assign) TransitionAnimaType transitionAnimaType;

-(void)viewApper;//出现
-(void)viewDisappear;//消失]

@end
