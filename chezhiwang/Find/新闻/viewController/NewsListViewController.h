//
//  NewsListViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  新闻列表
 */
@interface NewsListViewController : BasicViewController

@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,strong) UITableView *tableView;

@property (assign) UIEdgeInsets contentInsets;

@end
