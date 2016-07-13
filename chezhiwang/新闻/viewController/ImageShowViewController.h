//
//  ImageShowViewController.h
//  chezhiwang
//
//  Created by bangong on 16/6/27.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicViewController.h"
/**
 *  展示图片
 */
@interface ImageShowViewController : BasicViewController

@property (nonatomic,strong) NSArray *imageUrlArray;
@property (nonatomic,assign) NSInteger pageIndex;

@end
