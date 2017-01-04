//
//  CollectionSectionView.h
//  chezhiwang
//
//  Created by bangong on 16/8/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleSeriesSctionModel.h"
/**
 * 
 */
@interface CollectionSectionView : UICollectionReusableView

@property (nonatomic,strong) UILabel  *label;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) VehicleSeriesSctionModel *model;
@property (nonatomic,copy)   void(^block)();


@end
