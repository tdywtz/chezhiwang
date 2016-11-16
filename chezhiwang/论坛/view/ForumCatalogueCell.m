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

    self.imageView.bounds =CGRectMake(0,0,44,44);

    self.imageView.frame = CGRectMake(0,0,44,44);

    self.imageView.contentMode = UIViewContentModeCenter;



    CGRect tmpFrame = self.textLabel.frame;

    tmpFrame.origin.x = 46;

    self.textLabel.frame = tmpFrame;

    // self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = colorBlack;

    tmpFrame = self.detailTextLabel.frame;

    tmpFrame.origin.x = 46;

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
