//
//  ComplainChartFirstShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/8/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainChartFirstShowCell.h"


@implementation ComplainChartFirstShowCell
{

    UILabel *contentLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGB_color(246, 247, 248, 1);
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    UILabel * exampleLabel = [LHController createLabelWithFrame:CGRectZero Font:14 Bold:NO TextColor:colorLightGray Text:@"典型问题："];
    contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;


    [self.contentView addSubview:exampleLabel];
    [self.contentView addSubview:contentLabel];

    [exampleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(10);
    }];

    [contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(90);
        make.top.equalTo(10);
        make.right.equalTo(-15);
    }];

}

- (void)setErrorInfo:(NSArray *)errorInfo{
    _errorInfo = errorInfo;

    NSMutableAttributedString *matt;
    for (int i = 0; i < errorInfo.count; i ++) {
        NSDictionary *dict = errorInfo[i];
        if (matt == nil) {
            matt = [[NSMutableAttributedString alloc] init];
        }
        YYLabel *leftLabel = [[YYLabel alloc] init];
        leftLabel.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2);
        leftLabel.text = dict[@"bw"];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.backgroundColor = RGB_color(171, 92, 158, 1);
        leftLabel.textColor = [UIColor whiteColor];
        [leftLabel sizeToFit];

        YYLabel *rightLabel = [[YYLabel alloc] init];
        rightLabel.textContainerInset = UIEdgeInsetsMake(2, 2, 2, 2);
        rightLabel.text = dict[@"ques"];
        rightLabel.font = [UIFont systemFontOfSize:12];
        rightLabel.textColor = RGB_color(171, 92, 158, 1);
        rightLabel.layer.borderColor = RGB_color(171, 92, 158, 1).CGColor;
        rightLabel.layer.borderWidth = 1;
        [rightLabel sizeToFit];

        [matt appendAttributedString:[self attributeWithView:leftLabel]];
        [matt appendAttributedString:[self blankAttrubute]];
        [matt appendAttributedString:[self attributeWithView:rightLabel]];
        if (i < errorInfo.count+1) {
            [matt appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
    }

    contentLabel.attributedText = matt;
}

- (NSAttributedString *)blankAttrubute{
    unichar objectReplacementChar           = 0xFFFC;
    NSString *objectReplacementString       = [NSString stringWithCharacters:&objectReplacementChar length:1];
    return [[NSAttributedString alloc] initWithString:objectReplacementString];
}

- (NSAttributedString *)attributeWithView:(UIView *)view{

    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [self imageWithView:view];
    attachment.bounds = view.bounds;
    return [NSAttributedString attributedStringWithAttachment:attachment];
}

- (UIImage *)imageWithView:(UIView *)view{
    CGFloat width = view.frame.size.width;
    CGFloat height = view.frame.size.height;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}


- (CGFloat)getCellHeight{

    CGRect rect =  [contentLabel.attributedText boundingRectWithSize:CGSizeMake(WIDTH-105, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGRectGetHeight(rect)+20;
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
