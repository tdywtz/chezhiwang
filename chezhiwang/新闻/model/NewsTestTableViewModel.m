//
//  NewsTestTableViewModel.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestTableViewModel.h"

@implementation NewsTestTableViewModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super initWithDictionary:dictionary]) {
        self.ID = dictionary[@"id"];
    }
    return self;
}

@end
