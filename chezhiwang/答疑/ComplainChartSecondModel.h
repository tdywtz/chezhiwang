//
//  ComplainChartSecondModel.h
//  chezhiwang
//
//  Created by bangong on 16/6/28.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  回复率列表model
 */
@interface ComplainChartSecondModel : NSObject

/**次序*/
@property (nonatomic,copy) NSString *number;
/**品牌名*/
@property (nonatomic,copy) NSString *brandName;
/**百分率*/
@property (nonatomic,copy) NSString *percentage;


@end
