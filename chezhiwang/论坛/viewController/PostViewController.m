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
#import "CZWShareViewController.h"

//web页面按钮类型
typedef enum {
    clickTypeNewtopic,//发表新帖
    clickTypeReply,//回复
    clickTypeReplyfloor//回复本楼
}clickType;

@interface PostViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView *_webOne;
    NSString *webHttp;
}

@end

@implementation PostViewController

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

    [self crateRigthItem];
    [self.view addSubview:[[UIView alloc] init]];
    [self createWebView];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadData];
}


-(void)createWebView{

    
    _webOne = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _webOne.scrollView.delegate = self;
    _webOne.delegate = self;
    
    _webOne.backgroundColor = [UIColor clearColor];
 
    [self.view addSubview:_webOne];
}


#pragma mark - rightItem
-(void)crateRigthItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 2, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setImage:[UIImage imageNamed:@"forum_reply"] forState:UIControlStateNormal];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [view addSubview:btn];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    UIButton *share = [LHController createButtnFram:CGRectMake(0, 0 , 20, 20) Target:self Action:@selector(rightItemClickShare) Text:nil];
    [share setBackgroundImage:[UIImage imageNamed:@"comment_转发"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:share];
    
    self.navigationItem.rightBarButtonItems = @[item2,item1];
}

-(void)rightItemClick{
    if (![CZWManager manager].isLogin) {
        LoginViewController *login = [LoginViewController  init];
        [self presentViewController:login animated:YES completion:nil];
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
    CZWShareViewController *share = [[CZWShareViewController alloc] initWithParentViewController:self];
    share.shareUrl = webHttp;
    share.shareImage = [UIImage imageNamed:@"Icon-60"];
    NSString *html = @"";
    if (html.length > 100) html = [html substringToIndex:99];
    share.shareContent = html;
    share.shareTitle = [_webOne stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self presentViewController:share animated:YES completion:nil];
}


#pragma mark - UIScrollViewDelegate
//动画结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

}

//松开手
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [MBProgressHUD hideHUDForView:self.view animated:YES];

    //这里是js，主要目的实现对url的获取
    NSString *  jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
   NSArray *array = [urlResurlt componentsSeparatedByString:@"+"];

    NSLog(@"%@",array);
    NSLog(@"%@", [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"]);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    if (![CZWManager manager].isLogin) {
        LoginViewController *my = [LoginViewController init];
        [self presentViewController:my animated:YES completion:nil];
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
