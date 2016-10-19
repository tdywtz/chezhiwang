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
static NSString *password = @"password";

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
    _password = [defaults objectForKey:password];
}

- (void)loginWithDictionary:(NSDictionary *)dictionary{
    [defaults setObject:dictionary[@"name"] forKey:userName];
    [defaults setObject:dictionary[@"path"] forKey:iconUrl];
    [defaults setObject:dictionary[@"userid"] forKey:userID];
    [defaults setObject:dictionary[@"password"] forKey:password];
    [defaults synchronize];

    [self updateInfo];
}

- (void)logoutAccount{

    [defaults removeObjectForKey:userName];
    [defaults removeObjectForKey:userID];
    [defaults removeObjectForKey:iconUrl];
    [defaults removeObjectForKey:password];
    [defaults synchronize];

    [self updateInfo];
}

#pragma mark - class method
+ (UIImage *)defaultIconImage{
    return [UIImage imageNamed:@"defaultImage_icon"];
}
@end
