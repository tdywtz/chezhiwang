//
//  AnswerListViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//
#import "BasicViewController.h"

@interface AnswerListViewController : BasicViewController

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *sid;//车系

@property (nonatomic,assign) UIEdgeInsets contentInsets;

@end
