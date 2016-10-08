//
//  MyHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeaderView : UIView

@property (nonatomic ,weak) UIViewController *parentVC;

- (void)setTitle:(NSString *)title imageUrl:(NSString *)imageUrl login:(BOOL)login;

@end
