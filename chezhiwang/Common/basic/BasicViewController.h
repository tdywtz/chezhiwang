//
//  BasicViewController.h
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicBackgroundView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *contentLabel;

@end

#pragma mark - BasicViewController

@interface BasicViewController : UIViewController

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) BasicBackgroundView *backgroundView;

-(void)createLeftItemBack;

/**
 注册键盘通知
 */
-(void)keyboardNotificaion;
-(void)keyboardShow:(NSNotification *)notification;
-(void)keyboardHide:(NSNotification *)notification;

@end
