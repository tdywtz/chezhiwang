//
//  MyCardChooseViewController.h
//  chezhiwang
//
//  Created by bangong on 16/12/20.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChooseTableViewController.h"

typedef NS_ENUM(NSInteger, MyCardChooseType) {
    MyCardChooseTypeBrand,
    MyCardChooseTypeSeries,
    MyCardChooseTypeModel,
    MyCardChooseTypeProvince,
    MyCardChooseTypeCity,
    MyCardChooseTypeArea
};

@interface MyCardChooseViewController : ChooseTableViewController

@property (nonatomic,assign) MyCardChooseType type;
@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,weak) ChooseTableViewModel *aModel;
@property (nonatomic,weak) ChooseTableViewModel *bModel;

@property (nonatomic,copy) void (^endChoose)(NSString *title);

@end
