//
//  CZWAdvertisementViewController.m
//  autoService
//
//  Created by bangong on 16/6/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "CZWAdvertisementViewController.h"

@interface CZWAdvertisementViewController ()<UIWebViewDelegate>

@end

@implementation CZWAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createLeftItemBack];
    
    UIWebView *_webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.delegate = self;
    [self.view addSubview:_webView];
  
    NSURL *url = [NSURL URLWithString:self.urlString];
   //  NSLog(@"%@",url.absoluteString);
    
    NSURLRequest *request;
    if ([HttpRequest connectedToNetwork]) {
        request = [NSURLRequest requestWithURL:url];
    }else{
        //没有网络，从缓存获取数据
        [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20.0];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_webView loadRequest:request];




}

#pragma mark - UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
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
