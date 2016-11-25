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
NSString *const userName = @"userName";
NSString *const userID   = @"userId";
NSString *const iconUrl  = @"iconUrl";
NSString *const userPassword = @"userPassword";

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
    _password = [defaults objectForKey:userPassword];
}

- (void)loginWithDictionary:(NSDictionary *)dictionary{
    [defaults setObject:dictionary[@"name"] forKey:userName];
    [defaults setObject:dictionary[@"path"] forKey:iconUrl];
    [defaults setObject:dictionary[@"userid"] forKey:userID];
    [defaults synchronize];

    [self updateInfo];
}

- (void)storagePassword:(NSString *)password{
    [defaults setObject:[password copy] forKey:userPassword];
    [defaults synchronize];
    [self updateInfo];
}

- (void)updateIconUrl:(NSString *)url{
    _iconUrl = url;
    [defaults setObject:url forKey:iconUrl];
    [defaults synchronize];
}

- (void)logoutAccount{

    [defaults removeObjectForKey:userName];
    [defaults removeObjectForKey:userID];
    [defaults removeObjectForKey:iconUrl];
    [defaults removeObjectForKey:userPassword];
    [defaults synchronize];

    [self updateInfo];
}

#pragma mark - class method
+ (UIImage *)defaultIconImage{
    return [UIImage imageNamed:@"defaultImage_icon"];
}

+ (NSString *)get_userID{
    return [CZWManager manager].userID;
}

@end
