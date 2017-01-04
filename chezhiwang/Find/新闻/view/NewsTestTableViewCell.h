//
//  NewsTestTableViewCell.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTestTableViewModel.h"

/**
 *  精品试驾cell右侧展示视图文字展示框
 */
@interface TestLabel : TTTAttributedLabel

@property (nonatomic,assign) CGFloat draw_x;//突角点x坐标
@property (nonatomic,assign) CGFloat cornerRadius;//弧度半径

@end


/**
 *  精品试驾cell右侧展示视图上自定义button
 */
@interface TestCustonBtn : UIButton

@property (nonatomic,strong) UIImageView *customImageView;
@property (nonatomic,strong) UILabel *customTitleLabel;
@property (nonatomic,assign) BOOL gray;//是否为灰色不可点击


- (void)setCustomBarTitleColor:(UIColor *)color;

@end

/**
 *  精品试驾cell右侧展示视图
 */
@interface TestCellIntroduceView : UIView

@property (nonatomic,strong) NSMutableArray <__kindof TestCustonBtn *> *buttons;
@property (nonatomic,strong) TestLabel *contentLabel;//文字展示
@property (nonatomic,strong) NSArray *descArray;//描述数组
@property (nonatomic,weak) NewsTestTableViewModel *model;

@end


@interface NewsTestTableViewCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentController;
- (void)setModel:(NewsTestTableViewModel *)model;

@end
