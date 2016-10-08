//
//  CZWManager.h
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZWManager : NSObject

@property (nonatomic,assign,readonly) BOOL isLogin;
@property (nonatomic,copy,readonly) NSString *userName;
@property (nonatomic,copy,readonly) NSString *userID;
@property (nonatomic,copy,readonly) NSString *iconUrl;

/**登录账号*/
- (void)loginWithDictionary:(NSDictionary *)dictionary;
/**退出账号*/
- (void)logoutAccount;

+ (instancetype)manager;

@end
