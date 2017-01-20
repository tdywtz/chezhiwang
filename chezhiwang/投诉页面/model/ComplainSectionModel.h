//
//  ComplainSectionModel.h
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ComplainCellStyle) {
    ComplainCellStyleNomal = 0,
    ComplainCellStyleAge,
    ComplainCellStyleSex,
    ComplainCellStylePhone,
    ComplainCellStyleEmail,
    ComplainCellStyleBeginDate,
    ComplainCellStyleEndDate
};
#pragma mark - 模型一
@interface ComplainModel : NSObject
/**上传数据key*/
@property (nonatomic,copy) NSString *key;
/**textfiled背景文字*/
@property (nonatomic,copy) NSString *placeholder;
/**上传数据value*/
@property (nonatomic,copy) NSString *value;
/**左侧文字*/
@property (nonatomic,copy) NSString *name;
/**描述？详情？*/
@property (nonatomic,assign) NSInteger desOrDetail;
@property (nonatomic,assign) ComplainCellStyle style;
@property (nonatomic,assign) CGFloat cellHeight;

- (instancetype)initWithKey:(NSString *)key placeholder:(NSString *)placeholder text:(NSString *)value name:(NSString *)name style:(ComplainCellStyle)style;
- (NSString *)assertString;
@end

#pragma mark - 图片
@interface ComplainImageModel : NSObject

/**上传数据key*/
@property (nonatomic,copy) NSString *key;
/**左侧文字*/
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSArray *imageUrlArray;
@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) NSString *imageUrl;

@end

#pragma mark - 经销商
@interface ComplainBusinessModel : NSObject

/**左侧文字*/
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *businessKey;
@property (nonatomic,copy) NSString *businessCustomKey;
@property (nonatomic,copy) NSString *businessIdKey;

@property (nonatomic,copy) NSString *proValue;
@property (nonatomic,copy) NSString *businessValue;

@property (nonatomic,copy) NSString *proPlaceholder;
@property (nonatomic,copy) NSString *businessPlaceholder;

//@property (nonatomic,copy) NSString *businessId;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *pid;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *lid;//经销商id
@property (nonatomic,copy) NSString *seriesId;

@property (nonatomic,assign) BOOL custom;//自定义
@property (nonatomic,assign) CGFloat cellHeight;


@end

#pragma mark -选择车型模型
@interface ComplainBrandModel : NSObject

@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSString *seriesName;
@property (nonatomic,copy) NSString *modelName;

@property (nonatomic,copy) NSString *BrandId;
@property (nonatomic,copy) NSString *SeriesId;
@property (nonatomic,copy) NSString *ModelId;

@property (nonatomic,copy) NSString *brandNameKey;
@property (nonatomic,copy) NSString *seriesNameKey;
@property (nonatomic,copy) NSString *modelNameKey;

@property (nonatomic,copy) NSString *brandIdKey;
@property (nonatomic,copy) NSString *seriesIdKey;
@property (nonatomic,copy) NSString *modelIdKey;

@property (nonatomic,assign) BOOL brandSelected;
@property (nonatomic,assign) BOOL seriesSelected;
@property (nonatomic,assign) BOOL modelSelected;
@property (nonatomic,assign) CGFloat cellHeight;

- (void)resetSelected;

@end

#pragma mark - 投诉类型
@interface ComplainTypeModel : NSObject

@property (nonatomic,copy) NSString *key;//投诉类型
@property (nonatomic,copy) NSString *type;//投诉类型
@property (nonatomic,copy) NSString *qualityKey;//质量
@property (nonatomic,copy) NSString *qualityValue;//质量
@property (nonatomic,copy) NSString *servekey;//服务
@property (nonatomic,copy) NSString *serveValue;//服务
@property (nonatomic,assign) CGFloat cellHeight;

- (instancetype)initWithKey:(NSString *)key type:(NSString *)type;

@end


#pragma mark - section
@interface ComplainSectionModel : NSObject
/**图片*/
@property (nonatomic,strong) UIImage *image;
/**描述*/
@property (nonatomic,copy) NSString *describe;
/**类型名*/
@property (nonatomic,copy) NSString *name;
/***/
@property (nonatomic,assign) CGFloat viewHeight;

@property (nonatomic,strong) NSArray *rowModels;

/**选择时间专用*/
@property (nonatomic,copy) NSString *beginDate;
/**选择时间专用*/
@property (nonatomic,copy) NSString *endDate;


+ (NSArray *)dataArray;
@end
