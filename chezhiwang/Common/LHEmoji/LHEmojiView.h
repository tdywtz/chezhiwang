//
//  LHEmojiView.h
//  chezhiwang
//
//  Created by bangong on 15/11/9.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnEmojiNmae)(NSString *name);
@interface LHEmojiView : UIView

@property (nonatomic,copy) returnEmojiNmae block;

-(void)returnEmojiName:(returnEmojiNmae)block;
@end
