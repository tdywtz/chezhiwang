//
//  HomepageResearchModel.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageResearchModel.h"

@implementation HomepageResearchModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super initWithDictionary:dictionary]) {
        self.ID = dictionary[@"id"];
    }
    return self;
}

@end
