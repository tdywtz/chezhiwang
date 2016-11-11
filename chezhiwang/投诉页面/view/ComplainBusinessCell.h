//
//  ComplainBusinessCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComplainBusinessModel;

@protocol ComplainBusinessCellDelegate <NSObject>

- (void)updateCellHeight;

@end

@interface ComplainBusinessCell : UITableViewCell

@property (nonatomic,weak) id<ComplainBusinessCellDelegate> delegate;
@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) ComplainBusinessModel *businessModel;

@end
