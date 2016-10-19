//
//  FootCommentView.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FootCommentViewDelegate <NSObject>

- (void)clickButton:(NSInteger)slected;

@end
/**底部评论*/
@interface FootCommentView : UIView

@property (nonatomic,weak) id<FootCommentViewDelegate> delegate;

- (void)oneButton;

- (void)setReplyConut:(NSString *)replyCount;
- (void)addReplyCont;

@end
