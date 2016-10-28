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
@property (nonatomic,assign) BOOL invest;//是否新车调查
@property (nonatomic,copy) NSString *type;//当点击首页头部焦点新闻为“新车调查”时需传入
@property (nonatomic,copy) NSString *shareImageUrl;//分享使用的图片的链接地址，若新闻列表cell有图片，选择第一张的链接赋值
@end
