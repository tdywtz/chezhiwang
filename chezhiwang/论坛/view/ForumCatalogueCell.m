//
//  ForumCatalogueCell.m
//  chezhiwang
//
//  Created by bangong on 16/11/16.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ForumCatalogueCell.h"

@implementation ForumCatalogueCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {

    [super layoutSubviews];


    self.imageView.frame = CGRectMake(10,0,self.lh_height-10,self.lh_height-10);
    self.imageView.lh_centerY = self.lh_height/2;

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;



    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = self.imageView.lh_right+10;

    self.textLabel.frame = tmpFrame;

    // self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = colorBlack;

    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = self.textLabel.lh_left;

    self.detailTextLabel.frame = tmpFrame;

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
