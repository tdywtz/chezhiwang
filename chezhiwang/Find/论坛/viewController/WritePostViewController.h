//
//  WritePostViewController.h
//  demo
//
//  Created by bangong on 15/11/6.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  发表新帖
 */
@interface WritePostViewController : BasicViewController

@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,assign) forumClassify classify;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *contentArray;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextView *contentTextView;

@end
