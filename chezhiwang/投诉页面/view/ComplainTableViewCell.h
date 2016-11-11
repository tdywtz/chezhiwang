//
//  ComplainTableViewCell.h
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ComplainModel;
@class ComplainSectionModel;

#pragma mark - 车牌号
@interface ComplainLicenseplateCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) ComplainModel *model;

@end

#pragma mark - cell
@interface ComplainTableViewCell : UITableViewCell

@property (nonatomic,weak) UIViewController *parentViewController;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) ComplainModel *model;
@property (nonatomic,strong) ComplainSectionModel *sectionModel;

@end
