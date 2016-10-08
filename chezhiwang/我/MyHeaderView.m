//
//  MyHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/9/30.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyHeaderView.h"
#import "LoginViewController.h"
#import "BasicNavigationController.h"

@interface MyHeaderView ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *nameButton;

@end

@implementation MyHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.layer.cornerRadius = 40;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.borderWidth = 2;
        self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;

        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameButton.layer.borderWidth = 1;
        self.nameButton.layer.cornerRadius = 3;
        [self.nameButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.imageView];
        [self addSubview:self.nameButton];

        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(60);
            make.size.equalTo(CGSizeMake(80, 80));
        }];
        [self.nameButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.bottom.equalTo(-30);
            make.height.equalTo(30);
        }];

        self.backgroundColor = colorLightBlue;
    }
    return self;
}

- (void)loginClick{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:user_name]) {
        return;
    }
    LoginViewController *login = [[LoginViewController alloc] init];
    BasicNavigationController *nvc = [[BasicNavigationController alloc] initWithRootViewController:login];
    [self.parentVC presentViewController:nvc animated:YES completion:nil];
}

- (void)setTitle:(NSString *)title imageUrl:(NSString *)imageUrl login:(BOOL)login{
    if (login) {
          [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        [self.nameButton setTitle:title forState:UIControlStateNormal];
        self.nameButton.layer.borderColor = [UIColor clearColor].CGColor;
    }else{
        self.imageView.image = [UIImage imageNamed:@"defaultImage_icon"];
        [self.nameButton setTitle:title forState:UIControlStateNormal];
         self.nameButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
