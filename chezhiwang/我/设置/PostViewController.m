//
//  AgreementViewController.m
//  auto
//
//  Created by bangong on 15/7/15.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "PostViewController.h"
#import "LoginViewController.h"
#import "ReplyViewController.h"
#import "WritePostViewController.h"
#import "UMSocial.h"

typedef enum {
    pageNumberFirst,
    pageNumberLast,
    pageNumberMiddle
}pageNumber;

//
//typedef enum {
//    pageTypeOne = 1,
//    pageTypeTwo = -pageTypeOne
//}pageType;

//web页面按钮类型
typedef enum {
    clickTypeNewtopic,//发表新帖
    clickTypeReply,//回复
    clickTypeReplyfloor//回复本楼
}clickType;

@interface PostViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *_webView;
    UIWebView *_hideWebView;
    
    UIWebView *_webOne;
    UIWebView *_webTwo;
    NSInteger _count;
    CustomActivity *activity;
    
    UIView *sview;//分享背景
    UIView *shareView;
    NSString *webHttp;
}
@property (nonatomic,strong)NSMutableArray *webDataArray;
//@property (nonatomic,assign) pageType pagetype;
@property (nonatomic,assign) pageNumber pagenumber;

@end

@implementation PostViewController
- (void)dealloc
{
    [sview removeFromSuperview];
}
-(void)loadData{
   
    if (self.http) {
        webHttp = self.http;
    }else{
        webHttp = [NSString stringWithFormat:@"http://m.12365auto.com/postcontentapp.aspx?tId=%@",self.tid];
    }
    NSURL *url = [NSURL URLWithString:webHttp];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webOne loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.webDataArray = [[NSMutableArray alloc] init];
    
    [self createLeftItem];
    [self crateRigthItem];
    [self.view addSubview:[[UIView alloc] init]];
    [self createWebView];
    [self createActivity];
    [self loadData];
}

-(void)createActivity{
    activity = [[CustomActivity alloc] initWithCenter:CGPointMake(WIDTH/2, HEIGHT/2-64)];
    [self.view addSubview:activity];
    [activity animationStarting];
}

-(void)createWebView{

    
    _webOne = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _webOne.scrollView.delegate = self;
    _webOne.delegate = self;
    
    _webOne.backgroundColor = [UIColor clearColor];
 
    [self.view addSubview:_webOne];
    
    self.pagenumber = pageNumberFirst;
    _count = 1;
    _webView = _webOne;
}


#pragma mark - 返回
-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(itemClick)];
}

-(void)itemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - rightItem
-(void)crateRigthItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 2, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"forum_reply"] forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [view addSubview:btn];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    UIButton *share = [LHController createButtnFram:CGRectMake(0, 0 , 20, 20) Target:self Action:@selector(rightItemClickShare) Text:nil];
    [share setBackgroundImage:[UIImage imageNamed:@"share3"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:share];
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

-(void)rightItemClick{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.pushPop = pushTypePopView;
        [self.navigationController pushViewController:login animated:YES];
        return;
       
    }
    
    ReplyViewController *reply = [[ReplyViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:reply];
    reply.Id = self.tid;
    [reply sucess:^{
        [self loadData];
    }];
    reply.replaytype = replyTypePost;
    [self presentViewController:nvc animated:YES completion:nil];
}

-(void)rightItemClickShare{
    [self createShare];
}

#pragma mark - 分享
-(void)createShare{
    if (shareView) {
        sview.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame = CGRectMake(0, HEIGHT-260, WIDTH, 260);
        }];
    }else{
        
        [self createShareView];
        sview.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            shareView.frame = CGRectMake(0, HEIGHT-260, WIDTH, 260);
        }];
    }
}

-(void)createShareView{
    sview = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    sview.backgroundColor = RGB_color(0, 0, 0, 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:sview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [sview addGestureRecognizer:tap];
    
    shareView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 260)];
    shareView.backgroundColor = [UIColor whiteColor];
    [sview addSubview:shareView];
    
    //NSArray *imageAray = @[];
    NSArray *array = @[@"QQ好友",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间",@"复制链接"];
    for (int i = 0; i < array.count; i ++) {
        
        UIButton *btn = [LHController createButtnFram:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3), 80, 80) Target:self Action:@selector(shareClick:) Text:nil];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"fenxiang%d",i+1]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [shareView addSubview:btn];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(15+WIDTH/3*(i%3), 15+110*(i/3)+80, 80, 20) Font:[LHController setFont]-4 Bold:NO TextColor:nil Text:array[i]];
        label.textAlignment = NSTextAlignmentCenter;
        [shareView addSubview:label];
    }
}

#pragma mark - 背景view手势
-(void)tap:(UITapGestureRecognizer *)tap{
    sview.hidden = YES;
    shareView.frame = CGRectMake(0, HEIGHT, WIDTH, 200);
}

#pragma mark - 分享响应方法
-(void)shareClick:(UIButton *)btn{
    sview.hidden = YES;
    shareView.frame = CGRectMake(0, HEIGHT, WIDTH, 200);
    
    NSString *urlString = webHttp;
    
    UIImage *shareImage = [UIImage imageNamed:@"Icon-60"];
    NSString *content = @"";//self.dict[@"content"] == nil?self.dict[@"Content"]:self.dict[@"content"];
    if (content.length > 100) content = [content substringToIndex:99];
    NSString *shareContent = content;
    NSString *shareTitle = self.titleText;//self.textTitle;
    NSString *shareUrl = webHttp;
    switch (btn.tag) {
        case 100:
        {
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title =shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
        }
            break;
            
        case 101:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            //[UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"dasfas";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    //NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 102:
        {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            // [UMSocialData defaultData].extConfig.wechatSessionData.shareText = shareContent;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                }
            }];
        }
            break;
            
        case 103:
        {
            
            [[UMSocialControllerService defaultControllerService] setShareText:urlString shareImage:nil socialUIDelegate:self];        //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            //  isAhare = YES;
        }
            break;
            
        case 104:
        {
            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareContent image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    // NSLog(@"分享成功！");
                }
            }];
            
        }
            break;
            
        case 105:
        {
            //  http = self.dict[@"url"];
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"复制成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
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

#pragma mark - UIScrollViewDelegate
//动画结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

//松开手
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
 [activity animationStoping];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    

    [activity animationStoping];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSInteger integer = @"http://m.12365auto.com/postcontentapp.aspx?".length;
        NSString *string = request.URL.absoluteString;
        if (string.length > integer) {
             NSString *str = [string substringFromIndex:integer];
            if ([str hasPrefix:@"type=newtopic"]) {
                NSString *sub = [str substringFromIndex:@"type=newtopic&".length];
                [self clickWithTtpe:clickTypeNewtopic and:sub];
               
            }else if ([str hasPrefix:@"type=reply"]){
                if ([str hasPrefix:@"type=replyfloor"]) {
                    NSString *pid = [str substringFromIndex:@"type=replyfloor&pid=".length];
                    [self clickWithTtpe:clickTypeReplyfloor and:pid];
                }else{
                    NSString *tid = [str substringFromIndex:@"type=reply&tid=".length];
                    [self clickWithTtpe:clickTypeReply and:tid];
                }
            }
        }
        return NO;
    }
    return YES;
}

-(void)clickWithTtpe:(clickType)type and:(NSString *)string{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        LoginViewController *my = [[LoginViewController alloc] init];
        my.pushPop = pushTypePopView;
        [self.navigationController pushViewController:my animated:YES];
        return;
    }
    
    if (type == clickTypeNewtopic) {
        WritePostViewController *write = [[WritePostViewController alloc] init];
        NSArray *array = [string componentsSeparatedByString:@"&"];
        if (array.count > 0) write.sid = [array[0] substringFromIndex:@"sid=".length];
        if (array.count > 1) write.cid = [array[1] substringFromIndex:@"cid=".length];
        
        [self.navigationController pushViewController:write animated:YES];
    }else {
        ReplyViewController *reply = [[ReplyViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:reply];
        reply.Id = string;
        [reply sucess:^{
            [self loadData];
        }];
        
        if (type == clickTypeReply) {
            reply.replaytype = replyTypePost;
        }else{
            reply.replaytype = replyTypeFloor;
        }
        [self presentViewController:nvc animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//
//-(void)viewWillAppear:(BOOL)animated{
//    [MobClick beginLogPageView:@"PageOne"];
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [MobClick endLogPageView:@"PageOne"];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
