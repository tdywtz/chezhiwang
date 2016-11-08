//
//  AboutViewController.m
//  auto
//
//  Created by bangong on 15/6/11.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AboutViewController.h"
#define xs  HEIGHT/667.0

@interface AboutViewController ()
{
    CGFloat B;
    UIScrollView *_scrollView;
}
@end

@implementation AboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    B = [LHController setFont];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createUI];
}

-(void)createUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    
    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(0, 0, 150*xs, 150*xs) ImageName:@"auto_appIcon"];
    imageView.center = CGPointMake(WIDTH/2, 110*xs);
    [_scrollView addSubview:imageView];
    

    UILabel *label1 = [LHController createLabelWithFrame:CGRectZero Font:B-2 Bold:NO TextColor:colorBlack Text:nil];
    label1.numberOfLines = 0;
    [_scrollView addSubview:label1];
    
    [_scrollView addSubview:label1];
    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.bottom).offset(30);
        make.left.equalTo(10);
        make.width.equalTo(WIDTH-20);
    }];
    
    NSString *text = @"车质网（www.12365auto.com）是国内领先的缺陷汽车产品信息和车主质量投诉信息收集平台，也是购买汽车的消费者了解相关车型品质状况的第三方优选媒介。\n“传递您的心声，解决您的难题”，车质网希望车主的抱怨在一个高效运转的通道里得到重视和解决，并致力于为改善车企的客户关系提供持续和全方位的服务。\n我们的目标是成为中国汽车质量第三方评价体系中更有力、更公正、更客观的声音和力量。";

    AttributStage *stage = [[AttributStage alloc] init];
    label1.attributedText = [NSMutableAttributedString attributedStringWithStage:stage string:text];
    

    
    UILabel *banquan = [LHController createLabelWithFrame:CGRectMake(LEFT, HEIGHT-64-40, WIDTH-LEFT*2, 20) Font:B-4 Bold:NO TextColor:nil Text:@"©  车质网 版权所有"];
    banquan.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:banquan];
    
    _scrollView.contentSize = CGSizeMake(0, banquan.frame.origin.y+banquan.frame.size.height+30);
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
