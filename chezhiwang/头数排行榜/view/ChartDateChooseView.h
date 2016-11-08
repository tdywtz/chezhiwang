//
//  ChartDateChooseView.h
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

///时间选择
@interface ChartDateChooseView : UIView

@property (nonatomic,weak) UIViewController *parentViewController;

@property (nonatomic,copy) void(^chooseDeate)(NSString *beginDate , NSString *endDate);

- (instancetype)initWithFrame:(CGRect)frame chooseDeate:(void(^)(NSString *beginDate , NSString *endDate))chooseDeate;
- (void)show;
- (void)dismiss;

@end
