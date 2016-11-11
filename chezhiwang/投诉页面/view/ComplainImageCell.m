//
//  ComplainImageCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainImageCell.h"
#import "ComplainSectionModel.h"
#import "CZWShowImageView.h"

@interface ComplainImageCell ()

@end

@implementation ComplainImageCell
{
    UILabel *nameLabel;
    CZWShowImageView *showImageView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }

    return self;
}

- (void)makeUI{
    nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = colorBlack;
    nameLabel.font = [UIFont systemFontOfSize:15];

    showImageView = [[CZWShowImageView alloc] initWithWidth:WIDTH-110 ViewController:self.parentVC];
    showImageView.maxNumber = 6;
    showImageView.backgroundColor = [UIColor clearColor];
    
    __weak __typeof(self)weakSelf = self;
    [showImageView updateFrame:^(CGRect frame) {
        //通知tableview刷新
       CGFloat height = (WIDTH-110-15)/3;
        if (showImageView.imageArray.count > 2) {
            weakSelf.imageModel.cellHeight = height*2+5+30;
        }else{
            weakSelf.imageModel.cellHeight = height+30;
        }
        [weakSelf.delegate updateCellheight];
    }];
    
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:showImageView];
}

- (void)resetLayout{
    nameLabel.lh_left = 10;
    nameLabel.lh_centerY = 43;
    nameLabel.lh_size = CGSizeMake(70, 30);

    showImageView.lh_left = 100;
    showImageView.lh_top = 15;
    showImageView.lh_width =WIDTH-110;
    CGFloat height =  (WIDTH-110-15)/3;
    if (showImageView.imageArray.count > 2) {
        showImageView.lh_height = height*2+5;
    }else{
        showImageView.lh_height = height;
    }
}

- (void)setParentVC:(UIViewController *)parentVC{
    _parentVC = parentVC;
    showImageView.myVC = parentVC;
}

- (void)setImageModel:(ComplainImageModel *)imageModel{
    _imageModel = imageModel;

    nameLabel.text = imageModel.name;

    showImageView.imageArray = imageModel.imageArray;
    if (showImageView.imageArray.count == 0) {
         showImageView.imageUrlArray = imageModel.imageUrlArray;
    }
    [self resetLayout];
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
