//
//  ComplainSectionHeaderView.h
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComplainSectionModel;

#pragma mark - TwoheaderView

@interface ComplainTwoSectionHeaderView : UIView

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,weak)ComplainSectionModel *model;

@end

#pragma mark - headerView
@interface ComplainSectionHeaderView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *describeLabel;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,weak)ComplainSectionModel *model;

@end
