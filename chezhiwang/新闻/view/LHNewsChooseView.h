//
//  LHNewsChooseView.h
//  chezhiwang
//
//  Created by bangong on 16/10/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHNewsChooseViewDelegate <NSObject>

@optional
- (void)clickItem:(NSInteger)index;

@end

@interface LHNewsChooseView : UIView

@property (nonatomic,weak) id<LHNewsChooseViewDelegate> delegate;
- (void)show;
- (void)dismiss;

@end
