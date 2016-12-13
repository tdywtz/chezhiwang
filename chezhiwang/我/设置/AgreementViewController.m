//
//  AgreementViewController.m
//  auto
//
//  Created by bangong on 15/7/15.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()<UIWebViewDelegate>

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:[URLFile urlStringRegistrationAgreement]];
    [ webView setScalesPageToFit:YES];
    webView.pageLength = 10;
    [self.view addSubview:webView];
    
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
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
