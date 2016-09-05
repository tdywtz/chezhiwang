
//
//  TopCollectionViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/26.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "TopCollectionViewCell.h"
#import "ChooseViewController.h"

@implementation TopCollectionViewCell
{
    UIButton *brandUIButton;
    UIButton *seriesUIButton;
    UIButton *modelUIButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.borderColor = RGB_color(230, 230, 230, 1).CGColor;
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.backgroundColor = [UIColor whiteColor];

        NSArray *classArray = @[@"brandUIButton",@"seriesUIButton",@"modelUIButton"];
        NSArray *titles = @[@"选择品牌",@"选择车系",@"选择车型"];
        for (int i = 0; i < classArray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:colorLightGray forState:UIControlStateNormal];
            [btn setTitleColor:colorBlack forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self setValue:btn forKey:classArray[i]];
            [self.contentView addSubview:btn];

            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"auto_toolbarRightTriangle"]];
            [self.contentView addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(btn);
                make.right.equalTo(-10);
            }];

            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = RGB_color(230, 230, 230, 1);
            [self.contentView addSubview:lineView];
            [lineView makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(10);
                make.right.equalTo(-10);
                make.top.equalTo(btn.bottom);
                make.height.equalTo(1);
            }];
        }
//初始设置可否点击
        brandUIButton.selected = YES;
        seriesUIButton.enabled = NO;
        modelUIButton.enabled = NO;

        [seriesUIButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.right.equalTo(-20);
            make.height.equalTo(30);
        }];

        [brandUIButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-20);
            make.bottom.equalTo(seriesUIButton.top);
            make.height.equalTo(30);
        }];

        [modelUIButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-20);
            make.top.equalTo(seriesUIButton.bottom);
            make.height.equalTo(30);
        }];

    }
    return self;
}

- (void)btnClick:(UIButton *)btn{

    chooseType type = chooseTypeBrand;
    if (btn == brandUIButton) {
        type = chooseTypeBrand;
    }else if (btn == seriesUIButton){
        type = chooseTypeSeries;
    }else if (btn == modelUIButton){
        type = chooseTypeModel;
    }
    __weak __typeof(self)weakSelf = self;
    ChooseViewController *chose = [[ChooseViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:chose];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [chose retrunResults:^(NSString *title, NSString *ID) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (type == chooseTypeBrand) {

            strongSelf.topModel.brandName = title;
            strongSelf.topModel.brandId = ID;
            strongSelf.topModel.seriesName = @"选择车系";
            strongSelf.topModel.seriesId = @"";
            strongSelf.topModel.modelName = @"选择车型";
            strongSelf.topModel.modelId = @"";

        }else if (type == chooseTypeSeries){

            strongSelf.topModel.seriesName = title;
            strongSelf.topModel.seriesId = ID;

            strongSelf.topModel.modelName = @"选择车型";
            strongSelf.topModel.modelId = @"";

        }else if (type == chooseTypeModel){
        
            strongSelf.topModel.modelName = title;
            strongSelf.topModel.modelId = ID;
        }
        [strongSelf setData:weakSelf.topModel];
        //选中数据后回调方法
        if (strongSelf.block) {
            strongSelf.block(strongSelf.topModel);
        }
    }];

    if (type == chooseTypeSeries){
        chose.ID = self.topModel.brandId;
    }else if (type == chooseTypeModel){
        chose.ID = self.topModel.brandId;
        chose.seriesId = self.topModel.seriesId;
    }
    
    chose.choosetype = type;

    [self.parentViewController presentViewController:nvc animated:YES completion:nil];
}

- (void)setTopModel:(TopCollectionViewModel *)topModel{
    _topModel = topModel;

    [self setData:topModel];
}

- (void)setData:(TopCollectionViewModel *)topModel{
    
    [brandUIButton setTitle:topModel.brandName forState:UIControlStateNormal];
    [seriesUIButton setTitle:topModel.seriesName forState:UIControlStateNormal];
    [modelUIButton setTitle:topModel.modelName forState:UIControlStateNormal];

    seriesUIButton.enabled = NO;
    seriesUIButton.selected = NO;
    modelUIButton.enabled = NO;
    modelUIButton.selected = NO;

    if ([topModel.brandId integerValue] > 0) {
        seriesUIButton.enabled = YES;
        seriesUIButton.selected = YES;

        if ([topModel.seriesId integerValue] > 0) {
            modelUIButton.enabled = YES;
            modelUIButton.selected = YES;
        }
    }
}

- (void)ruturnModel:(void(^)(TopCollectionViewModel *topModel))block{
    self.block = block;
}

@end
