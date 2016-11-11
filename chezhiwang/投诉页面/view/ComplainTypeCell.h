//
//  ComplainTypeCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComplainTypeModel;


@protocol ComplainTypeCellDelegate <NSObject>

- (void)updateLayout;

@end

@interface ComplainTypeCell : UITableViewCell

@property (nonatomic,weak) id <ComplainTypeCellDelegate> delegate;
@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) ComplainTypeModel *typeModel;

@end
