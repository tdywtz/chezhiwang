//
//  CZWShareView.h
//  chezhiwang
//
//  Created by bangong on 16/1/13.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZWShareView : UIView

@property (nonatomic,strong) UIImage *shareImage;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,weak) UIViewController *controller;

-(void)show;
@end
