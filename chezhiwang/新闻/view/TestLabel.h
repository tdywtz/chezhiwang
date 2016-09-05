//
//  TestLabel.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <TTTAttributedLabel.h>
/**
 *  精品试驾cell右侧展示视图文字展示框
 */
@interface TestLabel : TTTAttributedLabel

@property (nonatomic,assign) CGFloat draw_x;//突角点x坐标
@property (nonatomic,assign) CGFloat cornerRadius;//弧度半径

@end
