//
//  NewsTableHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableHeaderView : UIView

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,copy) void(^block)(NSString *ID, NSString *title);
@property (nonatomic,strong) NSArray *pointNews;
@property (nonatomic,strong) NSArray *pointImages;

-(void)loadData;
@end
