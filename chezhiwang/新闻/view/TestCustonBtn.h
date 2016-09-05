//
//  TestCustonBtn.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  精品试驾cell右侧展示视图上自定义button
 */
@interface TestCustonBtn : UIButton

@property (nonatomic,strong) UIImageView *customImageView;
@property (nonatomic,strong) UILabel *customTitleLabel;
@property (nonatomic,assign) BOOL gray;//是否为灰色不可点击


- (void)setCustomBarTitleColor:(UIColor *)color;

@end
