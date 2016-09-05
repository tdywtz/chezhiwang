//
//  TestCellIntroduceView.h
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestCustonBtn.h"
#import "TestLabel.h"
#import "NewsTestTableViewModel.h"

/**
 *  精品试驾cell右侧展示视图
 */
@interface TestCellIntroduceView : UIView

@property (nonatomic,strong) NSMutableArray <__kindof TestCustonBtn *> *buttons;
@property (nonatomic,strong) TestLabel *contentLabel;//文字展示
@property (nonatomic,strong) NSArray *descArray;//描述数组
@property (nonatomic,weak) NewsTestTableViewModel *model;

@end
