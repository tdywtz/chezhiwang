//
//  OnTheLeftView.h
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnTheLeftViewDelegate <NSObject>

@optional
/**高亮异步参数*/
- (void)highlightButtonClick:(BOOL)highlight;
/**隐藏相同参数*/
- (void)hideButtonClick:(BOOL)hide;

@end

@interface OnTheLeftView : UIView

@property (nonatomic,weak) id <OnTheLeftViewDelegate> delegate;

- (BOOL)highlight;

- (void)resetButton;

@end
