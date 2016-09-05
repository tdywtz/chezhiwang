//
//  AdvertisementViewController.m
//  chezhiwang
//
//  Created by bangong on 16/8/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "AdvertisementViewController.h"

@interface AdvertisementViewController ()<UIWebViewDelegate>

@end

@implementation AdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLeftItemBack];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    [self.view addSubview:webView];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
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
