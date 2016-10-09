//
//  NewsTestTableViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "NewsTestTableViewCell.h"
#import "TestCellIntroduceView.h"
#import "ImageShowViewController.h"

#pragma mark - 实拍图片
@interface TimeShowImageView : UIView

@property (nonatomic,copy) void(^block)(NSInteger index, NSArray *urlArray);
@property (nonatomic,strong) NSArray *urlArray;
- (void)setImageWithUrl:(NSArray <NSString *>*)urlArray;
@end

@implementation TimeShowImageView
{
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UIImageView *imageViewFour;
}

- (instancetype)init{
    if (self = [super init]) {
        CGFloat width = 80*(WIDTH/375);
        CGFloat height = 55*(WIDTH/375);
        CGFloat space = (WIDTH-20 -width*4)/3;
        NSArray *array = @[@"imageViewOne",@"imageViewTwo",@"imageViewThree",@"imageViewFour"];
        UIImageView *temp = nil;
        for (int i =  0; i < 4; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = 100+i;
            [self addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];

            if (!temp) {
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(0);
                    make.top.equalTo(0);
                    make.bottom.equalTo(0);
                    make.width.equalTo(width);
                    make.height.equalTo(height);
                }];
            }else{
                [imageView makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(temp.right).offset(space);
                    make.top.equalTo(0);
                    make.bottom.equalTo(0);
                    make.width.equalTo(width);
                }];

            }
            [self setValue:imageView forKey:array[i]];
            temp = imageView;
        }
    }
    return self;
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap{
    NSInteger index = tap.view.tag-100;
    if (index >= 0 && index < _urlArray.count) {
        if (self.block) {
            self.block(index,_urlArray);
        }
    }
}

- (void)setImageWithUrl:(NSArray <NSDictionary *>*)urlArray{
    _urlArray = urlArray;
    imageViewOne.image = nil;
    imageViewTwo.image = nil;
    imageViewThree.image = nil;
    imageViewFour.image = nil;
    for (int i = 0; i < urlArray.count; i ++) {
        if (i == 0) {
            [imageViewOne sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 1){
            [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 2){
            [imageViewThree sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }else if (i == 3){
            [imageViewFour sd_setImageWithURL:[NSURL URLWithString:urlArray[i][@"image"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        }
    }
}
@end

#pragma mark - cell
@implementation NewsTestTableViewCell

{
    UILabel *titleLabel;//标题
    UIImageView *iconImageView;//左侧图片
    TestCellIntroduceView *introduceView;//右侧5个按钮及描述视图
    TimeShowImageView *showImageView;//底部图片展示

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self makeUI];
    }
    return self;
}

-(void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = colorBlack;

    iconImageView = [[UIImageView alloc] init];

    introduceView = [[TestCellIntroduceView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-130, 120)];

    UILabel *label = [[UILabel alloc] init];
    label.textColor = colorDeepGray;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"    实拍图片";
    UIView *lietiaotiao = [[UIView alloc] init];
    lietiaotiao.backgroundColor = colorYellow;
    [label addSubview:lietiaotiao];
    [lietiaotiao makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(0);
        make.width.equalTo(2);
    }];

    showImageView = [[TimeShowImageView alloc] init];
    __weak __typeof(self)weakSelf = self;
    showImageView.block = ^(NSInteger index, NSArray *urlArray){
        ImageShowViewController *show = [[ImageShowViewController alloc] init];
        show.mid = urlArray[index][@"mid"];
        show.pageIndex = index;
        show.hidesBottomBarWhenPushed = YES;
        [weakSelf.parentController.navigationController pushViewController:show animated:YES];
    };

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = colorLineGray;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:iconImageView];
    [self.contentView addSubview:introduceView];
    [self.contentView addSubview:label];
    [self.contentView addSubview:showImageView];
    [self.contentView addSubview:line];

    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];

    [iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(5);
        make.size.equalTo(CGSizeMake(100, 120));
    }];

    [introduceView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.right).offset(10);
        make.top.equalTo(iconImageView);
        make.right.equalTo(-10);
        make.height.equalTo(iconImageView);
    }];

    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(iconImageView.bottom).offset(10);
    }];

    [showImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(label.bottom).offset(10);
        make.width.equalTo(WIDTH-20);
    }];

    [line makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(showImageView.bottom).offset(10);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (void)setModel:(NewsTestTableViewModel *)model{
    titleLabel.text = model.title;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.maxImage] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    [showImageView setImageWithUrl:model.minImage];
    introduceView.model = model;
    introduceView.descArray = model.desc;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
