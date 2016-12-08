//
//  CZWShareViewController.m
//  12365auto
//
//  Created by bangong on 16/5/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShareViewController.h"
#import <UMSocialCore/UMSocialCore.h>


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
            [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
            break;

        case 1:

            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;

        case 2:
            [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
            break;

        case 3:
            [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
            break;


        case 4:
            [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
            break;

        case 5:
        {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = self.shareUrl;
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"复制成功" message:nil preferredStyle:UIAlertControllerStyleAlert];

              __weak __typeof(self)weakSelf = self;
            [self dismissViewControllerAnimated:YES completion:^{
               __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf.parentController presentViewController:ac animated:YES completion:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ac dismissViewControllerAnimated:YES completion:nil];
                });
            }];
         }
            break;
          
        default:
            break;
    }
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    UIImage *shareIamge = self.shareImage?self.shareImage:[CZWManager defaultIconImage];

    NSString *shareContent = self.shareContent;
    if (shareContent.length > 90) {
        shareContent = [shareContent substringToIndex:90];
    }
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:shareContent thumImage:shareIamge];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
   // NSLog(@"%@",self.shareUrl)

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;


    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@",resp.originalResponse);

            }else{
                NSLog(@"response data is %@",data);
            }
        }
      //  [self alertWithError:error];
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
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
