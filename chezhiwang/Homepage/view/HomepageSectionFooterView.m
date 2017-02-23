//
//  HomepageSectionFooterView.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageSectionFooterView.h"
#import "HomepageSectionModel.h"

//#import "NewsViewController.h"
//#import "ComplainListViewController.h"
//#import "NewsInvestigateViewController.h"
//#import "AnswerListViewController.h"
//#import "ForumClassifyListViewController.h"

@implementation HomepageSectionFooterView
{
    UIButton *pushButton;
    UIImageView *imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
        pushButton.titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
        [pushButton setTitleColor:colorLightGray forState:UIControlStateNormal];
        pushButton.backgroundColor = colorBackGround;
        [pushButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [pushButton addTarget:self action:@selector(pushClick) forControlEvents:UIControlEventTouchUpInside];

        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"arrow"];

        [self addSubview:pushButton];
        [self addSubview:imageView];

        [pushButton makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(10, 0, 0, 0));
        }];

        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(25);
            make.centerY.equalTo(pushButton);
        }];
    }
    return self;
}

- (void)pushClick{
    if (self.click) {
        self.click();
    }
    UIViewController *VC = [[_sectionModel.pushClass alloc] init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.parentVC.navigationController pushViewController:VC animated:YES];

}

- (void)setSectionModel:(HomepageSectionModel *)sectionModel{
    _sectionModel = sectionModel;
    [pushButton setTitle:sectionModel.footTitle forState:UIControlStateNormal];
}

- (void)noSpace{
    [pushButton updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
