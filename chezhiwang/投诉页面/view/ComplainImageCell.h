//
//  ComplainImageCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComplainImageCellDelegate <NSObject>

- (void)updateCellheight;

@end

@class ComplainImageModel;

@interface ComplainImageCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentVC;
@property (nonatomic,weak) id<ComplainImageCellDelegate> delegate;
@property (nonatomic,strong) ComplainImageModel *imageModel;

@end
