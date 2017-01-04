
//
//  ForumCatalogueHeaderView.m
//  chezhiwang
//
//  Created by bangong on 16/11/15.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumCatalogueHeaderView.h"
#import "ForumClassifyListViewController.h"


#pragma mark - itme
@interface HeaderViewUIButton : UIButton

@property (nonatomic,copy) NSString *ID;

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image;

@end

@implementation HeaderViewUIButton

+ (instancetype)buttonWithTitle:(NSString *)title image:(UIImage *)image{
    CGFloat width = 87;
    HeaderViewUIButton *item = [HeaderViewUIButton buttonWithType:UIButtonTypeCustom];


    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 45)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [item addSubview:imageView];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [item addSubview:titleLabel];

    [titleLabel sizeToFit];

    titleLabel.lh_left = 0;
    titleLabel.lh_width = width;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lh_top = imageView.lh_bottom+10;

    item.lh_size = CGSizeMake(width, titleLabel.lh_bottom);

    return item;
}

@end



#pragma mark - headerView

@implementation ForumCatalogueHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        YYLabel *lanmuLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        lanmuLabel.textContainerInset = UIEdgeInsetsMake(0, 15, 0, 0);
        lanmuLabel.backgroundColor = RGB_color(240, 240, 240, 1);
        lanmuLabel.text = @"栏目论坛";

        YYLabel *brandLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, lanmuLabel.lh_height)];
        brandLabel.textContainerInset = UIEdgeInsetsMake(0, 15, 0, 0);
        brandLabel.backgroundColor = RGB_color(240, 240, 240, 1);
        brandLabel.text = @"品牌论坛";

        [self addSubview:lanmuLabel];
        [self addSubview:brandLabel];

        NSArray *array = @[
                           @{@"title":@"故障交流",@"imageName":@"forum_故障交流",@"ID":@"2"},
                           @{@"title":@"用车心得",@"imageName":@"forum_用车心得",@"ID":@"3"},
                           @{@"title":@"人车生活",@"imageName":@"forum_人车生活",@"ID":@"1"},
                           @{@"title":@"汽车文化",@"imageName":@"forum_汽车文化",@"ID":@"5"},
                           @{@"title":@"七嘴八舌",@"imageName":@"forum_七嘴八舌",@"ID":@"4"},
                           @{@"title":@"召回与三包",@"imageName":@"forum_汽车召回与三包",@"ID":@"6"}
                           ];

        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dict = array[i];
            HeaderViewUIButton *itme = [HeaderViewUIButton buttonWithTitle:dict[@"title"] image:[UIImage imageNamed:dict[@"imageName"]]];
            itme.ID = dict[@"ID"];
            [itme addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
             [self addSubview:itme];

                CGFloat space = (WIDTH-itme.lh_width*3)/4;

            itme.lh_left = (i%3)*(itme.lh_width+space)+space;
            itme.lh_top = (i/3)*(itme.lh_height+20)+lanmuLabel.lh_bottom+20;

            self.lh_height = itme.lh_bottom+20+brandLabel.lh_height;
        }

        brandLabel.lh_bottom = self.lh_bottom;
    }
    return self;
}

- (void)itemClick:(HeaderViewUIButton *)item{
   
    ForumClassifyListViewController *post = [[ForumClassifyListViewController alloc] init];
    post.sid = item.ID;
    post.forumType = forumClassifyColumn;
    [self.parentViewController.navigationController pushViewController:post animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
