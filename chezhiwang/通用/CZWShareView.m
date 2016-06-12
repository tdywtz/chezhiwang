
//
//  CZWShareView.m
//  chezhiwang
//
//  Created by bangong on 16/1/13.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWShareView.h"
#import "UMSocial.h"

@implementation CZWShareView
{
    UIView *shareView;
    CGFloat textFont;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        textFont = [LHController setFont]-5;
    }
    return self;
}

-(void)createShareView{
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 260)];
    shareView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareView];
    
    //NSArray *imageAray = @[];
    NSArray *array = @[@"QQ好友",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间",@"复制链接"];
    for (int i = 0; i < array.count; i ++) {
        
        UIButton *btn = [LHController createButtnFram:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3), 80, 80) Target:self Action:@selector(shareClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fenxiang%d",i+1]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [shareView addSubview:btn];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3)+80, 80, 20) Font:textFont Bold:NO TextColor:nil Text:array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }
}


-(void)shareClick:(UIButton *)btn{
    //关闭
    [self close];
    
    NSString *urlString = [NSString stringWithFormat:@"%@\n%@",self.shareTitle,self.shareUrl];
    if (self.shareContent.length > 100) self.shareContent = [self.shareContent substringToIndex:99];
    switch (btn.tag) {
        case 100:
        {
            [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
            // [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
        }
            break;
            
        case 101:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;;
            //[UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"dasfas";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 102:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
            // [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
            
        case 103:
        {
            
            [[UMSocialControllerService defaultControllerService] setShareText:urlString shareImage:self.shareImage socialUIDelegate:self.controller];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self.controller,[UMSocialControllerService defaultControllerService],YES);
            //  isAhare = YES;
        }
            break;
            
        case 104:
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.shareContent image:self.shareImage location:nil urlResource:nil presentedController:self.controller completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    // NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 105:
        {
            UIPasteboard *past = [UIPasteboard generalPasteboard];
            past.string = self.shareUrl;
            
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"复制成功"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:nil, nil];
            [al show];
            [UIView animateWithDuration:0.3 animations:^{
                [al dismissWithClickedButtonIndex:0 animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)show{
    CGRect frame = shareView.frame;
    frame.origin.y = HEIGHT -frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        shareView.frame = frame;
    }];
}

-(void)close{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
