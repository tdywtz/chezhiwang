//
//  CZWShareViewController.m
//  12365auto
//
//  Created by bangong on 16/5/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShareViewController.h"
#import "UMSocial.h"


@interface CZWShareViewController ()

@property (nonatomic,weak) UIViewController *parentController;

@end

@implementation CZWShareViewController
-(instancetype)initWithParentViewController:(UIViewController *)controller{
    if (self = [super init]) {
        self.parentController = controller;
    }
    return self;
}

- (void)viewDidLoad {
      
    [super viewDidLoad];
}


-(void)buttonClick:(LHMenuItem *)item{
    
    __weak __typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf caseNumber:[strongSelf.items indexOfObject:item]];
    }];
}

-(void)caseNumber:(NSInteger)num{
    switch (num) {
        case 0:
        {
            [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
            // [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.parentController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
        }
            break;
            
        case 1:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
            //[UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"dasfas";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.parentController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 2:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
            // [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.parentController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
            
        case 3:
        {

            [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.shareUrl;
            [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType = UMSocialUrlResourceTypeWeb;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.parentController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
            break;
//
//            NSString *urlSring = [NSString stringWithFormat:@"%@\n%@",self.shareTitle,self.shareUrl];
//            [[UMSocialControllerService defaultControllerService] setShareText:urlSring shareImage:self.shareImage socialUIDelegate:self.parentController];        //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self.parentController,[UMSocialControllerService defaultControllerService],YES);
            //  isAhare = YES;
        }
            break;
            
        case 4:
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.parentController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    // NSLog(@"分享成功！");
                }
            }];
        }
            break;
            
        case 5:
        {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.shareUrl;
        }
            break;
            
        default:
            break;
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
