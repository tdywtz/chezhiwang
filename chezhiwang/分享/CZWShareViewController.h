//
//  CZWShareViewController.h
//  12365auto
//
//  Created by bangong on 16/5/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "LHMenuController.h"

@interface CZWShareViewController : LHMenuController

@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,strong) UIImage *shareImage;

-(instancetype)initWithParentViewController:(UIViewController *)controller;
@end
