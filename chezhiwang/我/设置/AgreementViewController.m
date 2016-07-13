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
    NSURL *url = [NSURL URLWithString:@"http://m.12365auto.com/user/agreeForIOS.shtml"];
    [ webView setScalesPageToFit:YES];
    webView.pageLength = 10;
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    [webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
