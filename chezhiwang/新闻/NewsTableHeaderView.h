//
//  NewsTableHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/3/22.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableHeaderView : UIView

@property (nonatomic,copy) void(^block)(NSString *ID, NSString *title);

-(void)loadData;
@end
