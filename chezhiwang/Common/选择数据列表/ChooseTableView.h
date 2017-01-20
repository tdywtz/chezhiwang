//
//  ChooseTableView.h
//  chezhiwang
//
//  Created by bangong on 17/1/12.
//  Copyright © 2017年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTableViewController.h"

@interface ChooseTableView : UIView

@property (nonatomic,strong) UITableView *tableView;
@property (assign,readonly)           UITableViewStyle style;

@property (nonatomic,strong) NSArray <__kindof ChooseTableViewSectionModel *> *sectionModels;
@property BOOL isShowSection;//显示sectionView
@property BOOL isIndex;//使用索引
@property (nonatomic,assign) BOOL isShowImage;//cell显示图片

@property (nonatomic,copy) void (^didSelectedRow)(ChooseTableViewModel *model);

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
