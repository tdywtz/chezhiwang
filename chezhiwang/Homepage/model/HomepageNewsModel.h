//
//  HomepageNewsModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"

@interface HomepageNewsModel : BasicObject


/** 日期 */
@property (nonatomic,copy) NSString *date;
/***/
@property (nonatomic,copy) NSString *ID;
/** 图片链接 */
@property (nonatomic,copy) NSString *image;
/** 类型 */
@property (nonatomic,copy) NSString *stylename;
/** 标题*/
@property (nonatomic,copy) NSString *title;


@end
