//
//  ForumHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/11/14.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForumHeaderViewDelegate <NSObject>

-(void)didSelectOrderType:(NSInteger)orderType topicType:(NSInteger)topicType;

@end

@interface ForumHeaderView : UIView

@property (nonatomic,weak) UIView *showChooseView;
@property (nonatomic,assign) CGFloat navigationHeight;
@property (nonatomic,weak) id<ForumHeaderViewDelegate> delegate;

@end
