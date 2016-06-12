//
//  CommentListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/16.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CommentListCell.h"

@implementation CommentListCell
{
    UIImageView *iconImageView;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *contentLabel;
    UIButton *button;
    UIView *fgView2;
    UIView *huifuView;
    CGFloat B;
    NSString *_id;

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //创建UI
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    B = [LHController setFont];
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 , 15, 40, 40)];
//    iconImageView.layer.cornerRadius = 20;
//    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = [UIImage imageNamed:@"defaultImage_icon"];
    iconImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:iconImageView];
    
    
    nameLabel = [LHController createLabelWithFrame:CGRectMake(50, 15, 200, 20) Font:B-2 Bold:NO TextColor:[UIColor colorWithRed:70/255.0 green:128/255.0 blue:209/255.0 alpha:1] Text:nil];
    [self.contentView addSubview:nameLabel];
    
    contentLabel = [LHController createLabelWithFrame:CGRectMake(50, 50, WIDTH-65, 40) Font:B-1 Bold:NO TextColor:nil Text:nil];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    
    timeLabel = [LHController createLabelWithFrame:CGRectMake(10, 80, 200, 20) Font:B-5 Bold:NO TextColor:nil Text:nil];
    timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    
    button = [LHController createButtnFram:CGRectMake(WIDTH-40, 60, 40, 20) Target:self Action:@selector(btnClick) Text:@"回复"];
    [button setTitleColor:[UIColor colorWithRed:70/255.0 green:128/255.0 blue:209/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:B-2];
    [self.contentView addSubview:button];
    
    
    
    huifuView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, WIDTH, 100)];
    huifuView.hidden = YES;
    //huifuView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self.contentView addSubview:huifuView];
    
    fgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 1)];
    fgView2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.contentView addSubview:fgView2];
}
//回复按钮
-(void)btnClick{
    if (self.getpid != nil) {
        
        self.getpid(_id);
    }
}

-(void)setDictionary:(NSDictionary *)dictionary{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
    }
    [self fuzhi:_dictionary];
}

-(void)fuzhi:(NSDictionary *)f_dict{
 
    NSDictionary *h_dict = f_dict[@"huifu"];
    if (h_dict) {
        _id = h_dict[@"h_id"];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:h_dict[@"h_logo"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        nameLabel.text = h_dict[@"h_uname"];
        timeLabel.text = h_dict[@"h_time"];
        contentLabel.text = h_dict[@"h_content"];
        NSAttributedString *att1 = [self attString:h_dict[@"h_content"] Font:B-1];
        //CGSize size =[h_dict[@"h_content"] boundingRectWithSize:CGSizeMake(WIDTH-65, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-1]} context:nil].size;
       CGSize size1 = [att1 boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        contentLabel.frame = CGRectMake(50, 40, WIDTH-60, size1.height);
        contentLabel.attributedText = att1;
        for (UIView *viv in huifuView.subviews) {
            [viv removeFromSuperview];
        }
        UILabel *name = [LHController createLabelWithFrame:CGRectMake(10, 0, 200, 20) Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:170/255.0 green:170/255.0  blue:170/255.0  alpha:1] Text:[NSString stringWithFormat:@"原评论：%@",f_dict[@"p_uname"]]];
        [huifuView addSubview:name];
        
        CGSize size2 =[f_dict[@"p_content"] boundingRectWithSize:CGSizeMake(WIDTH-70, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-3]} context:nil].size;
        UILabel *content = [LHController createLabelWithFrame:CGRectMake(10, 25, WIDTH-70, size2.height) Font:B-3 Bold:NO TextColor:[UIColor colorWithRed:170/255.0 green:170/255.0  blue:170/255.0  alpha:1] Text:nil];
        content.text = f_dict[@"p_content"];
        [huifuView addSubview:content];
        if (size2.height > 80) {
            content.frame = CGRectMake(10, 20, WIDTH-70, 80);
        }
        
        huifuView.frame = CGRectMake(50, contentLabel.frame.origin.y+contentLabel.frame.size.height+10, WIDTH-60, content.frame.origin.y+content.frame.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, huifuView.frame.size.height)];
        view.backgroundColor =  [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [huifuView addSubview:view];
        
        timeLabel.frame = CGRectMake(LEFT, huifuView.frame.origin.y+huifuView.frame.size.height+10, 200, 20);
        button.frame = CGRectMake(WIDTH-40, timeLabel.frame.origin.y, 40, 20);
        fgView2.frame = CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height+10, WIDTH, 1);
        huifuView.hidden = NO;
    }else{
        huifuView.hidden = YES;
        _id = f_dict[@"p_id"];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:f_dict[@"p_logo"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
        nameLabel.text = f_dict[@"p_uname"];
        timeLabel.text = f_dict[@"p_time"];
        contentLabel.text = f_dict[@"p_content"];
        NSAttributedString *att = [self attString:f_dict[@"p_content"] Font:B-1];
       // CGSize size =[_dictionary[@"p_content"] boundingRectWithSize:CGSizeMake(WIDTH-65, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:B-1]} context:nil].size;
        CGSize size = [att boundingRectWithSize:CGSizeMake(WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        contentLabel.frame = CGRectMake(50, 40, WIDTH-60, size.height);
        contentLabel.attributedText = att;
        
        timeLabel.frame =CGRectMake(LEFT , contentLabel.frame.origin.y+size.height+10, 200, 20);
        button.frame = CGRectMake(WIDTH-40, timeLabel.frame.origin.y, 40, 20);
        fgView2.frame = CGRectMake(0, timeLabel.frame.origin.y+timeLabel.frame.size.height+10, WIDTH, 1);
    }
    
    if (self.block != nil) {
        self.block(fgView2.frame.origin.y+1);
    }
    self.yy = fgView2.frame.origin.y+1;
}

-(void)getHeight:(getHeight)block{
    self.block = block;
}

-(void)getPid:(getPid)getpid{
    self.getpid = getpid;
}

#pragma mark - 属性化字符串
-(NSAttributedString *)attString:(NSString *)str Font:(CGFloat)size{
    if (!str) {
        return nil ;
    }
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *syyle = [[NSMutableParagraphStyle alloc] init];
    [syyle setLineSpacing:5];
    [syyle setLineBreakMode:NSLineBreakByWordWrapping];
   // syyle.firstLineHeadIndent = 30;
    [syyle setParagraphSpacing:10];
    [att addAttribute:NSParagraphStyleAttributeName value:syyle range:NSMakeRange(0, str.length)];
    //[att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,str.length)];
    return att;
}


+(instancetype)manager{
    static CommentListCell *userConmentListCell = nil;
    if (userConmentListCell == nil) {
        userConmentListCell = [[CommentListCell alloc] init];
    }
    for (UIView *vi in userConmentListCell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    return userConmentListCell;
}

+(CGFloat)returnCellHeight:(NSDictionary *)dict{
    CommentListCell *cell = [CommentListCell manager];
    [cell fuzhi:dict];
    
    return cell.yy;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
