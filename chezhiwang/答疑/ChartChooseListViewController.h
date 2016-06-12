//
//  ChartChooseListViewController.h
//  chezhiwang
//
//  Created by bangong on 16/5/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  列表显示位置
 */
typedef NS_ENUM(NSInteger,DirectionStyle) {
    /**
     *  左侧
     */
    DirectionLeft,
    /**
     *  右侧
     */
    DirectionRight
};

/**
 *  选择类型
 */
typedef NS_ENUM(NSInteger,ChartChooseType) {
    /**
     *  时间
     */
    ChartChooseTypeDate = 0,
    /**
     *  车型属性
     */
    ChartChooseTypeAttributeModel,
    /**
     *  品牌属性
     */
    ChartChooseTypeAttributeBrand,
    /**
     *  系别
     */
    ChartChooseTypeAttributeSeries,
    /**
     *  质量问题
     */
    ChartChooseTypeQuality,
#pragma mark - gcd
    /**品牌*/
    ChartChooseTypeBrand,
    /**车系*/
    ChartChooseTypeSeries,
    /**车型*/
    ChartChooseTypeModel,
};

/**
 *  数据选择列表页
 */
@interface ChartChooseListViewController : UIViewController

@property (nonatomic,assign,readonly) DirectionStyle direction;
@property (nonatomic,assign,readonly) ChartChooseType type;
@property (nonatomic,copy) void(^chooseEnd)(NSString *title);
@property (nonatomic,copy) void(^chooseDeate)(NSString *date);

-(instancetype)initWithType:(ChartChooseType)type direction:(DirectionStyle)direction;

@end
