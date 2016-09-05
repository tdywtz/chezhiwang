//
//  Html5ViewController.m
//  chezhiwang
//
//  Created by bangong on 16/8/23.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "Html5ViewController.h"


@interface Html5ViewController ()
{
    UIWebView *_webView;

}
@end

@implementation Html5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"HTML5"];
//    path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
//
//    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:_webView];
//
//    [_webView loadRequest:request];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *moveview = [[UIView alloc] init];
        moveview.backgroundColor = [UIColor redColor];
        [self.view addSubview:moveview];

        [moveview makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(100);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];

        [moveview setNeedsLayout];
        [moveview layoutIfNeeded];



        [UIView animateWithDuration:0.3 animations:^{

            
        }];
        [UIView animateWithDuration:1.9 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [moveview updateConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(300);
            }];
            [moveview setNeedsLayout];
            [moveview layoutIfNeeded];
        } completion:^(BOOL finished) {

        }];

    });

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
