//
//  HomepageComplainModel.h
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicObject.h"

@interface HomepageComplainModel : BasicObject

@property (nonatomic,copy) NSString *brandname;
@property (nonatomic,copy) NSString *bw;
@property (nonatomic,copy) NSString *cpid;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *fwtd;
@property (nonatomic,copy) NSString *modelsname;
@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString *seriesname;
@property (nonatomic,strong) NSArray *tsbw;
@property (nonatomic,copy) NSString *tslx;

@end
