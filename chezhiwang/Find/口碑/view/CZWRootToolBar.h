//
//  CZWRootToolBar.h
//  autoService
//
//  Created by bangong on 15/11/27.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseClick)(UIButton *button, NSInteger index,BOOL select);

@interface CZWRootToolBar : UIView

@property (nonatomic,copy) chooseClick block;

/**
 *  点击按钮时回调
 *
 *  @param block <#block description#>
 */
-(void)chooseClickButton:(chooseClick)block;
/**
 *  设置UIButton选中状态
 *
 *  @param button UIButton
 */
-(void)setButtonState:(UIButton *)button select:(BOOL)select;
/**
 *  设置UIButton标题和背景图片
 *
 *  @param text   标题
 *  @param button UIButton
 */
-(void)setTitle:(NSString *)text andButton:(UIButton *)button;
@end
