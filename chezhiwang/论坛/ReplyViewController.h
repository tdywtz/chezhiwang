//
//  ReplyViewController.h
//  chezhiwang
//
//  Created by bangong on 15/10/16.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "WritePostViewController.h"

typedef enum {
    replyTypePost,//回复帖子
    replyTypeFloor//回复其中一条评论
}replyType;

typedef void(^sucess)();
/**
 *  回复输入内容
 */
@interface ReplyViewController : WritePostViewController

@property (nonatomic,assign) replyType replaytype;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) sucess block;

-(void)sucess:(sucess)block;

@end
