//
//  BasicTableViewCell.m
//  chezhiwang
//
//  Created by luhai on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicTableViewCell.h"

@implementation BasicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
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
