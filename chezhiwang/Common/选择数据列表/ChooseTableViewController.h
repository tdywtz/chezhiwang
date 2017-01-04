//
//  ChooseTableViewController.h
//  chezhiwang
//
//  Created by bangong on 16/12/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 模型
@class ChooseTableViewModel;

@interface ChooseTableViewSectionModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray <__kindof ChooseTableViewModel*> *rowModels;

@end

@interface ChooseTableViewModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ID;

@end

#pragma mark - 列表
@interface ChooseTableViewController : UIViewController

@property (nonatomic,strong) UITableView *tableView;
@property (assign)           UITableViewStyle style;

@property (nonatomic,strong) NSArray <__kindof ChooseTableViewSectionModel *> *sectionModels;
@property BOOL isShowSection;//显示sectionView
@property BOOL isIndex;//使用索引

@property (nonatomic,copy) void (^didSelectedRow)(ChooseTableViewModel *model);

- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
