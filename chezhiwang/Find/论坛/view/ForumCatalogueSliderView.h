//
//  ForumCatalogueSliderView.h
//  chezhiwang
//
//  Created by bangong on 16/11/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumCatalogueSectionModel;

@interface ForumCatalogueSliderView : UIView

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) NSArray <ForumCatalogueSectionModel *> *dataArray;
@property (nonatomic,copy) NSString *brandId;//品牌id
@end
