//
//  CZWPickerView.h
//  chezhiwang
//
//  Created by bangong on 16/12/20.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - CZWPickerViewModel
@interface CZWPickerViewModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ID;

+ (instancetype)initWithID:(NSString *)ID title:(NSString *)title;

@end

#pragma mark - CZWPickerViewSectionModel
@interface CZWPickerViewSectionModel : NSObject

@property (nonatomic,strong) NSArray<CZWPickerViewModel *> *rowModels;

+ (NSArray *)sex;

@end

#pragma mark - CZWPickerView
@interface CZWPickerView : UIPickerView

@property (nonatomic,strong) NSArray<CZWPickerViewSectionModel *> *sections;
@property (nonatomic,copy) void (^didSelectRow)(CZWPickerViewModel *model);


@end
