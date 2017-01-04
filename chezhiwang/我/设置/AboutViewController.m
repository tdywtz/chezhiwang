//
//  AboutViewController.m
//  auto
//
//  Created by bangong on 15/6/11.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = RGB_color(240, 240, 240, 1);

    [self createUI];
}

-(void)createUI{

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"auto_appIcon"];
    imageView.layer.cornerRadius = 20;
    imageView.layer.masksToBounds = YES;

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNow = [info objectForKey:@"CFBundleShortVersionString"];

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = versionNow;

    YYLabel *label1 = [[YYLabel alloc] initWithFrame:CGRectZero];
    label1.preferredMaxLayoutWidth = WIDTH;
    label1.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    label1.backgroundColor = [UIColor whiteColor];
    label1.numberOfLines = 0;


    UILabel *banquan = [[UILabel alloc] init];
    banquan.font = [UIFont systemFontOfSize:13];
    banquan.text = @"©  车质网 版权所有";
    banquan.textAlignment = NSTextAlignmentCenter;


    [self.view addSubview:imageView];
    [self.view addSubview:versionLabel];
    [self.view addSubview:label1];
    [self.view addSubview:banquan];

    CGFloat XS = HEIGHT/667.0;
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(90);
        make.size.equalTo(CGSizeMake(100*XS, 100*XS));
    }];

    [versionLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(imageView.bottom).offset(20*XS);
    }];


    [label1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLabel.bottom).offset(20*XS);
        make.left.equalTo(0);
        make.width.equalTo(WIDTH);
    }];

    [banquan makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(-10);
    }];
    
    NSString *text = @"车质网（www.12365auto.com）是国内领先的缺陷汽车产品信息和车主质量投诉信息收集平台，也是购买汽车的消费者了解相关车型品质状况的第三方优选媒介。\n“传递您的心声，解决您的难题”，车质网希望车主的抱怨在一个高效运转的通道里得到重视和解决，并致力于为改善车企的客户关系提供持续和全方位的服务。\n我们的目标是成为中国汽车质量第三方评价体系中更有力、更公正、更客观的声音和力量。";
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    attribute.lh_firstLineHeadIndent = 30;
    attribute.lh_paragraphSpacing = 20;
    attribute.lh_color = colorBlack;
    attribute.lh_font = [UIFont systemFontOfSize:15];

    label1.attributedText = attribute;
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
