//
//  CZWManager.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWManager.h"

@implementation CZWManager
{
 NSUserDefaults *defaults;
}
static NSString *userName = @"userName";
static NSString *userID = @"userId";
static NSString *iconUrl = @"iconUrl";

+ (instancetype)manager{
    static CZWManager *myManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myManager = [[CZWManager alloc] init];
        [myManager setUp];
    });

    return myManager;
}


- (void)setUp{
    defaults = [NSUserDefaults standardUserDefaults];
    [self updateInfo];
}

- (void)updateInfo{
    if ([defaults objectForKey:userName]) {
        _isLogin = YES;
    }else{
        _isLogin = NO;
    }
    _userName = [defaults objectForKey:userName];
    _userID = [defaults objectForKey:userID];
    _iconUrl = [defaults objectForKey:iconUrl];
}

- (void)loginWithDictionary:(NSDictionary *)dictionary{
    [defaults setObject:dictionary[@"name"] forKey:userName];
    [defaults setObject:dictionary[@"path"] forKey:iconUrl];
    [defaults setObject:dictionary[@"userid"] forKey:userID];
    [defaults synchronize];

    [self updateInfo];
}

- (void)logoutAccount{

    [defaults removeObjectForKey:userName];
    [defaults removeObjectForKey:userID];
    [defaults removeObjectForKey:iconUrl];
    [defaults synchronize];

    [self updateInfo];
}
@end
