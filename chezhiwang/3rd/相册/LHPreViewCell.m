//
//  LHPreViewCell.m
//  auto
//
//  Created by bangong on 15/7/30.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "LHPreViewCell.h"

@implementation LHPreViewCell
{
    UIImageView *imageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //创建UI
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, WIDTH-4, HEIGHT)];
        [self.contentView addSubview:imageView];
        self.contentView.center = CGPointMake(WIDTH/2, HEIGHT/2);
        self.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)setAsset:(ALAsset *)asset{
    if (_asset != asset) {
        _asset = asset;
    }
    imageView.image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
