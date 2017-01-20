//
//  NewsDetailViewController.h
//  chezhiwang
//
//  Created by bangong on 15/9/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  新闻详情
 */
@interface NewsDetailViewController : BasicViewController

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *sid;//车型综述进入时传入车系id
@property (nonatomic,assign) BOOL invest;//是否新车调查
@property (assign) UIEdgeInsets contentInsets;
@property (nonatomic,copy) NSString *shareImageUrl;//分享使用的图片的链接地址，若新闻列表cell有图片，选择第一张的链接赋值

- (void)shareWeb;
@end
