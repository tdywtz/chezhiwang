//
//  NewsDetailViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  新闻-评测
 */
@interface NewsDetailViewController : BasicViewController

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *titleLabelText;
@property (nonatomic,assign) BOOL invest;
@end
