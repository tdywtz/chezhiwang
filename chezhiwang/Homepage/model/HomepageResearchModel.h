//
//  HomepageResearchModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"

@interface HomepageResearchModel : BasicObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL hottype;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *models;
@property (nonatomic,copy) NSString *score;

@end
