//
//  BrandTableViewCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComplainBrandModel;

@protocol BrandTableViewCellDelegate <NSObject>

- (void)updateBrandModel:(ComplainBrandModel *)brandModel;

@end

@interface BrandTableViewCell : UITableViewCell

@property (nonatomic,weak) id<BrandTableViewCellDelegate> delegate;
@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) ComplainBrandModel *brandModel;

@end
