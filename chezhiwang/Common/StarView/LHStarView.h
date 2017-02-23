//
//  LHStarView.h
//  chezhiwang
//
//  Created by bangong on 17/2/6.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHStarView : UIView

@property (nonatomic,strong) UIColor *highlightColor;
@property (nonatomic,strong) UIColor *color;
- (void)setStarWidth:(CGFloat)width space:(CGFloat)space;

- (instancetype)initWithFrame:(CGRect)frame draw:(BOOL)draw;
//设置星级
-(void)setStar:(CGFloat)star;

@end
