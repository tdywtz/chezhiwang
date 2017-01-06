
//
//  ChartTableViewCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/24.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ChartTableViewCell.h"


@implementation ChartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, self.frame.size.height)];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = colorDeepGray;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameLabel];

        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.minimumLineSpacing = 1.0f;
//        layout.minimumInteritemSpacing = 0.5f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc ] initWithFrame:CGRectMake(100, 0, self.frame.size.width-100, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_collectionView];

    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, RGB_color(230, 230, 230, 1).CGColor);
    CGContextAddRect(context, CGRectMake(0, 0, 100, rect.size.height));
    CGContextStrokePath(context);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
