//
//  LHAssetPreviewController.h
//  auto
//
//  Created by bangong on 15/7/30.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHAssetPreviewController : UIViewController

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSArray *assetArray;
@property (nonatomic,strong) NSMutableArray *resultArray;
@property (nonatomic,copy) void(^getRsuelt)(NSArray *array);

-(void)getRsuelt:(void(^)(NSArray *array))block;
@end
