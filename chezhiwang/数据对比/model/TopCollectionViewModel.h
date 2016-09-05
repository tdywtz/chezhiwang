//
//  TopCollectionViewModel.h
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopCollectionViewModel : NSObject

@property (nonatomic,copy) NSString *brandName;
@property (nonatomic,copy) NSString *brandId;
@property (nonatomic,copy) NSString *seriesName;
@property (nonatomic,copy) NSString *seriesId;
@property (nonatomic,copy) NSString *modelName;
@property (nonatomic,copy) NSString *modelId;

@property (nonatomic,assign) NSInteger index;

@end
