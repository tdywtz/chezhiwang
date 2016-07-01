//
//  ComplainSearchViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/18.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  投诉收索
 */
@interface ComplainSearchViewController : BasicViewController

@property (nonatomic,strong)   UISearchBar *searchBar;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,strong)  NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL header;
@property (nonatomic,assign) NSInteger numType;

@end
