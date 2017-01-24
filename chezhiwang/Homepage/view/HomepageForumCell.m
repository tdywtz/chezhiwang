//
//  HomepageForumCell.m
//  chezhiwang
//
//  Created by bangong on 16/9/29.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "HomepageForumCell.h"

@implementation HomepageForumCell
{
    UILabel *titleLabel;
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *replycountLabel;
    UILabel *viewcountLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self makeUI];
    }
    return self;
}

- (void)makeUI{
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(23)];
    titleLabel.numberOfLines = 1;
    titleLabel.textColor = colorBlack;
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    nameLabel.textColor = colorLightGray;
    
    dateLabel = [[UILabel alloc] init];
    dateLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(18)];
    dateLabel.textColor = colorLightGray;
    
    replycountLabel = [[UILabel alloc] init];
    replycountLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    replycountLabel.textColor = colorDeepGray;

    viewcountLabel = [[UILabel alloc] init];
    viewcountLabel.font = [UIFont systemFontOfSize:PT_FROM_PX(19)];
    viewcountLabel.textColor = colorDeepGray;

    UIImageView *replyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"留言"]];
    replyImageView.contentMode = UIViewContentModeScaleAspectFit;

    UIImageView *viewImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"查看"]];
    viewImageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:dateLabel];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:replycountLabel];
    [self.contentView addSubview:replyImageView];
    [self.contentView addSubview:viewcountLabel];
    [self.contentView addSubview:viewImageView];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(titleLabel.bottom).offset(15);
        make.bottom.equalTo(-10);
        make.width.equalTo(80);
    }];
    
    [dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-110);
        make.bottom.equalTo(nameLabel);
    }];
    
    [viewcountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(nameLabel);
    }];

    [viewImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewcountLabel.left).offset(-5);
        make.centerY.equalTo(viewcountLabel);
        make.size.equalTo(CGSizeMake(14, 14));
    }];

    [replycountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewImageView.left).offset(-8);
        make.centerY.equalTo(viewcountLabel);
    }];

    [replyImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(replycountLabel.left).offset(-5);
        make.centerY.equalTo(viewcountLabel);
        make.size.equalTo(CGSizeMake(12, 12));
    }];
}

- (void)setForumModel:(HomepageForumModel *)forumModel{
    _forumModel = forumModel;
    [self setData];
}


- (void)setData{
    titleLabel.attributedText = [self attributedTitle];
    nameLabel.text = _forumModel.username;
    dateLabel.text = _forumModel.date;
    replycountLabel.text = _forumModel.replycount;
    viewcountLabel.text = _forumModel.viewcount;

}

- (NSMutableAttributedString *)attributedTitle{
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",_forumModel.title]];


    if ([_forumModel.type integerValue] == 3) {
        //内容有图片
         [attributed insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];

        NSTextAttachment *achment = [[NSTextAttachment alloc] init];
        achment.image = [UIImage imageNamed:@"auto_forumCell_image"];
        achment.bounds = CGRectMake(0, -1, 15, 15);
        [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:achment] atIndex:0];
    }else if([_forumModel.type integerValue] == 2){
        //内容没图片
    }


    if (_forumModel.essence) {
        //精华
        NSTextAttachment *jinghua = [[NSTextAttachment alloc] init];
        jinghua.image = [UIImage imageNamed:@"forum_jing"];
        jinghua.bounds = CGRectMake(0, -1, 15, 15);

        [attributed insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:0];
        
        [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:jinghua] atIndex:0];
    }
    return attributed;
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
