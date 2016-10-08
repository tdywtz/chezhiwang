//
//  AppDelegate.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomTabBarController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "CZWAppPrompt.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    CZWAppPrompt *prompt = [CZWAppPrompt sharedInstance];
    prompt.appId = THE_APPID;
    [prompt shouAlert:AppPromptStyleScore];
    [prompt shouAlert:AppPromptStyleUpdate];

    CustomTabBarController *cus = [[CustomTabBarController alloc] init];
    _window.rootViewController = cus;
    //电池条颜色
   // [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];

    [UMSocialData setAppKey:@"55f8e766e0f55a5cb5001444"];

    [MobClick startWithAppkey:@"55f8e766e0f55a5cb5001444" reportPolicy:BATCH channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

    [UMSocialQQHandler setQQWithAppId:@"1104889760" appKey:@"UKjSmfNFesY8GrPx" url:@"http://www.12365auto.com"];
    [UMSocialWechatHandler setWXAppId:@"wxfdc8e48568025b98" appSecret:@"2a61fc9735d8fbd1dbd946e8fb6b14ce" url:@"http://www.12365auto.com"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2288638211"
                                           secret:@"b79a37a46aae4533c30204781a11ae24"
                                      RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

     [HttpRequest GET:@"http://m.12365auto.com/server/forAppWebService.ashx?act=zlcti" success:^(id responseObject) {
         [[FmdbManager shareManager] createQuestion:responseObject];

     } failure:^(NSError *error) {
         
     }];
    [HttpRequest downloadProvince];
  
    _window.backgroundColor = [UIColor whiteColor];
    [NSThread sleepForTimeInterval:2.0];
    [_window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
