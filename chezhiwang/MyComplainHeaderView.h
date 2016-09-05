//
//  MyComplainHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/8/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyComplainHeaderView : UIView

@property (nonatomic,assign) CGFloat radius;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *lightBackColor;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) NSInteger current;

@end
