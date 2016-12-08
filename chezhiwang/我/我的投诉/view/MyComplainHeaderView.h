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
@property (nonatomic,strong) UIColor *lightTextColor;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,strong) UIColor *lightLineColor;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,assign) NSInteger current;

@end
