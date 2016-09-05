//
//  UIViewController+LH.m
//  chezhiwang
//
//  Created by bangong on 16/5/18.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "UIViewController+LH.h"
#import <objc/runtime.h>

@implementation UIViewController (LH)

-(void)viewApper{
    
}

-(void)viewDisappear{
    
}


- (void)setTransitionAnimaType:(TransitionAnimaType)transitionAnimaType{
    objc_setAssociatedObject(self, @"transitionAnimaType", @(transitionAnimaType), OBJC_ASSOCIATION_COPY);
}

- (TransitionAnimaType)transitionAnimaType{
  return   [objc_getAssociatedObject(self, @"transitionAnimaType") integerValue];
}
@end
