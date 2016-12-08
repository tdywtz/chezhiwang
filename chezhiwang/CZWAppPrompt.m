//
//  CZWAppPrompt.m
//  autoService
//
//  Created by bangong on 16/4/7.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWAppPrompt.h"
#import <StoreKit/StoreKit.h>

NSString *CZWTemplateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *CZWTemplateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";
NSString *CZWTemplateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
NSString *LINE_VERSION_URL = @"https://itunes.apple.com/cn/lookup?id=APP_ID";


#define  auto_system_version  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define  auto_appstoreScore [NSString stringWithFormat:@"appstoreScore%@",auto_system_version]
#define  auto_numberOpenAPP [NSString stringWithFormat:@"auto_numberOpenAPP%@",auto_system_version]

@interface CZWAppPrompt ()<UIAlertViewDelegate,NSXMLParserDelegate>

@property (nonatomic,strong) NSMutableArray *saxArray;
@property (nonatomic,strong) NSMutableDictionary *saxDic;
@property (nonatomic,strong) NSMutableString *valueString;
@end

@implementation CZWAppPrompt

+ (CZWAppPrompt *)sharedInstance {
    static CZWAppPrompt *appirater = nil;
    if (appirater == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appirater = [[CZWAppPrompt alloc] init];
            
        });
    }
    return appirater;
}

-(void)shouAlert:(AppPromptStyle)style{
//    if (DEBUG) {
//        return;
//    }
    NSString *numberOpen = [[NSUserDefaults standardUserDefaults] valueForKey:auto_numberOpenAPP];
    NSInteger num = [numberOpen integerValue]+1;
    [[NSUserDefaults standardUserDefaults] setObject:@(num) forKey:auto_numberOpenAPP];
    if (style == AppPromptStyleScore) {
       
       
        if (![[NSUserDefaults standardUserDefaults] boolForKey:auto_appstoreScore]
            && (num%5) == 3){
            UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"亲，给个好评吧"
                                                                 message:nil//@"我轻轻的来，不想轻轻的走了，让我带走你一个好评吧"
                                                                delegate:self
                                                       cancelButtonTitle:@"无情拒绝"
                                                       otherButtonTitles:@"现在就去", @"以后再说", nil];
            alertView.tag = 101;
            [alertView show];
        }
       
    }else{

        [self updataApp];

    }
}

#pragma mark - 应用更新*****应用更新******应用更新**********应用更新********应用更新*****应用更新********应用更新*****应用更新
/**应用更新*/
-(void)updataApp{

    __weak __typeof(self)weakSelf = self;
    NSString *url = [LINE_VERSION_URL stringByReplacingOccurrencesOfString:@"APP_ID" withString:self.appId];

    [HttpRequest GET:url success:^(id responseObject) {
        NSArray *array = responseObject[@"results"];
        if(array.count == 0)return ;
        NSDictionary *dict = array[0];
        NSString *versionAppStore = dict[@"version"];

        if ([versionAppStore compare:auto_system_version] == NSOrderedDescending) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@版本更新",dict[@"version"]]
                                                                message:dict[@"releaseNotes"]
                                                               delegate:weakSelf
                                                      cancelButtonTitle:@"下次再说"
                                                      otherButtonTitles:@"现在就去", nil];
            alertView.tag = 100;
            [alertView show];
        }
        
    } failure:^(NSError *error) {
        
    }];


//
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//
//        //创建sax解析的工具类对象
 //       NSXMLParser *saxParser = [[NSXMLParser alloc] initWithData:data];
        //指定代理
//        saxParser.delegate = self;
        //开始解析  sax解析是一个同步的过程
//        BOOL isParse = [saxParser parse];
//        if (isParse) {
//
//            NSLog(@"解析完成");
//        }else{
//            NSLog(@"解析失败");
//        }
//        NSLog(@"我是在解析结束下面");
//
//
//           }];
}


//#pragma mark - xml
////开始解析的代理方法
//-(void)parserDidStartDocument:(NSXMLParser *)parser {
//    NSLog(@"开始解析");
//    self.saxArray = [NSMutableArray array];
//}
//
////开始解析某个节点
////elementName:标签名称
////namespaceURI:命名空间指向的链接
////qName:命名空间的名称
////attributeDict:节点的所有属性
//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//    NSLog(@"开始解析%@节点",elementName);
//    //当开始解析student标签的时候,就应该初始化字典,因为一个字典就对应的是一个学生的信息
//    if ([elementName isEqualToString:@"student"]) {
//        self.saxDic = [NSMutableDictionary dictionary];
//    }
//}
////获取节点之间的值
//-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    NSLog(@"取值--------%@",string);
//    if (self.valueString) {//说明有值
//        [self.valueString appendString:string];
//    } else {
//        self.valueString = [NSMutableString stringWithString:string];
//    }
//}
////某个节点结束取值
//
//
//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    if ([elementName isEqualToString:@"versionNumber"]) {//说明name节点已经取值结束
//        [self.saxDic setObject:self.valueString forKey:elementName];
//    }
//    if ([elementName isEqualToString:@"appName"]) {
//        [self.saxDic setObject:self.valueString forKey:elementName];
//    }
//    if ([elementName isEqualToString:@"url"]) {
//        [self.saxDic setObject:self.valueString forKey:elementName];
//    }
//    if ([elementName isEqualToString:@"reason01"]) {
//        [self.saxArray addObject:self.valueString];
//    }
//    if ([elementName isEqualToString:@"reason02"]) {
//          [self.saxArray addObject:self.valueString];
//    }
//    self.valueString = nil;//置空
//    NSLog(@"结束%@节点的解析",elementName);
//}
//
//
////结束解析
//
//
//-(void)parserDidEndDocument:(NSXMLParser *)parser {
//    //可以使用解析完成的数据
//    NSLog(@"===%@",self.saxArray);
//    NSLog(@"%@",self.saxDic);
//    NSLog(@"整个解析结束");
//}
//
//
////解析出错
//
//
//-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
//    NSLog(@"解析出现错误-------%@",parseError.description);
//}


/**打开应用*/
-(void)openStore{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 && NSStringFromClass([SKStoreProductViewController class]) != nil) {
        
        SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        NSNumber *appId = [NSNumber numberWithInteger:self.appId.integerValue];
        [storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:nil];
//        storeViewController.delegate = self.sharedInstance;
//        
//        id <AppiraterDelegate> delegate = self.sharedInstance.delegate;
//        if ([delegate respondsToSelector:@selector(appiraterWillPresentModalView:animated:)]) {
//            [delegate appiraterWillPresentModalView:self.sharedInstance animated:_usesAnimation];
//        }
       
        [[CZWAppPrompt getRootViewController] presentViewController:storeViewController animated:NO completion:^{
          //  [self setModalOpen:YES];
            //Temporarily use a black status bar to match the StoreKit view.
            //[CZWAppPrompt setStatusBarStyle:[UIApplication sharedApplication].statusBarStyle];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
            [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
#endif
        }];
        
        //Use the standard openUrl method if StoreKit is unavailable.
    } else {
        
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
        NSString *reviewURL = [CZWTemplateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        
        // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
        // Fixes condition @see https://github.com/arashpayan/appirater/issues/205
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            reviewURL = [CZWTemplateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        }
        // iOS 8 needs a different templateReviewURL also @see https://github.com/arashpayan/appirater/issues/182
        else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            reviewURL = [CZWTemplateReviewURLiOS8 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
    }

}

+ (id)getRootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    return [self iterateSubViewsForViewController:window]; // iOS 8+ deep traverse
}

+ (id)iterateSubViewsForViewController:(UIView *) parentView {
    for (UIView *subView in [parentView subviews]) {
        UIResponder *responder = [subView nextResponder];
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewController: (UIViewController *) responder];
        }
        id found = [self iterateSubViewsForViewController:subView];
        if( nil != found) {
            return found;
        }
    }
    return nil;
}

+ (UIViewController *) topMostViewController: (UIViewController *) controller {
    BOOL isPresenting = NO;
    do {
        // this path is called only on iOS 6+, so -presentedViewController is fine here.
        UIViewController *presented = [controller presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            controller = presented;
        }
        
    } while (isPresenting);
    
    return controller;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if (buttonIndex == 1) {
       
        if (alertView.tag == 100) {
            
        }else if(alertView.tag == 101){

            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:auto_appstoreScore];
        }
         [self openStore];
    }
}

@end
