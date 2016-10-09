//
//  ComplainListCell.m
//  chezhiwang
//
//  Created by bangong on 15/9/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainListCell.h"
#import "FmdbManager.h"

@implementation ComplainListCell
{
    UILabel *questionLable;
    UILabel *cpidLabel;
    UILabel *dateLabel;
    UILabel *brandnameLabel;
    UILabel *modelsnameLabel;
    
    UIView *fgView;
    CGFloat B;
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
    
    questionLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, WIDTH-30, 20)];
    questionLable.font = [UIFont systemFontOfSize:B];
    questionLable.textColor = colorBlack;
    [self.contentView addSubview:questionLable];
    
    cpidLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 100, 20)];
    cpidLabel.font = [UIFont systemFontOfSize:B-5];
    cpidLabel.textColor = colorLightGray;
    [self.contentView addSubview:cpidLabel];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 35, WIDTH-140, 20)];
    dateLabel.font = [UIFont systemFontOfSize:B-5];
    dateLabel.textColor = colorLightGray;
    [self.contentView addSubview:dateLabel];
    

    
    brandnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, WIDTH-40, 20)];
    brandnameLabel.font = [UIFont systemFontOfSize:B-3];
    brandnameLabel.textColor = colorDeepGray;
    [self.contentView addSubview:brandnameLabel];
    
    UILabel *labelmodel = [LHController createLabelWithFrame:CGRectMake(15, 80, 40, 20) Font:B-3 Bold:NO TextColor:colorLightGray Text:@"车型:"];
    [self.contentView addSubview:labelmodel];
    
    modelsnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 80, WIDTH-70, 20)];
    modelsnameLabel.font = [UIFont systemFontOfSize:B-3];
    modelsnameLabel.textColor = colorDeepGray;
    [self.contentView addSubview:modelsnameLabel];
    
    fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 1)];
    fgView.backgroundColor = colorLineGray;
    [self.contentView addSubview:fgView];
}


-(void)setDictionary:(NSDictionary *)dictionary{
    if (_dictionary != dictionary) {
        _dictionary = dictionary;
    }
    
    questionLable.text = _dictionary[@"question"];
    cpidLabel.text = [NSString stringWithFormat:@"编号:【%@】",_dictionary[@"cpid"]];
    dateLabel.text = _dictionary[@"date"];
    brandnameLabel.text = _dictionary[@"brandname"];
    brandnameLabel.attributedText = [self attributeSize:[NSString stringWithFormat:@"品牌：%@   车系：%@",_dictionary[@"brandname"],_dictionary[@"seriesname"]] Font:B-3];
    modelsnameLabel.text = _dictionary[@"modelsname"];
  
    questionLable.textColor = colorBlack;
    for (NSDictionary *dict in self.readArray) {
        if ([dict[@"id"] isEqualToString:_dictionary[@"cpid"]]) {
            questionLable.textColor = colorDeepGray;
        }
    }
     _point = CGPointMake( 15, 105);
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[_dictionary[@"tsbw"] componentsSeparatedByString:@","]];
    [array removeObject:@""];
    [self createImageCar:array];
    [self createImageQuestion:_dictionary[@"fwtd"]];
    if (_block) {
        _block(_point.y+40);
    }
    fgView.frame = CGRectMake(0, _point.y+40-1, WIDTH, 1);
}

-(void)setCellHeight:(myBlock)block{
    _block = block;
}

-(void)createImageCar:(NSArray *)array{
   
    if (array.count == 0) return;
    
    UIImageView  *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, 20, 20)];
    carImageView.image = [UIImage imageNamed:@"zl.png"];
    [self.contentView addSubview:carImageView];
    
    _point = CGPointMake(40, _point.y);
    for (int i = 0; i < array.count; i ++) {
        
        NSDictionary *ceDic = [[FmdbManager shareManager] selectFormQuestion:array[i]];
        
        NSString *str1 = [NSString stringWithFormat:@"%@%@",ceDic[@"name"],@":"];
        CGFloat length1 = [self getStr:str1 andFont:12];
        [self upDataPint:length1];
        
        UIImageView *immageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, length1+20, 20)];
        UIImage *image1 = [UIImage imageNamed:@"kk(1)"];
        
        image1 = [image1 stretchableImageWithLeftCapWidth:15 topCapHeight:9];
        immageView1.image=image1;
        immageView1.userInteractionEnabled = YES;
        [self.contentView addSubview:immageView1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, length1+20, 20)];
        label.text = str1;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = colorDeepBlue;
        label.font = [UIFont systemFontOfSize:B-5];
        
        [immageView1 addSubview:label];
        _point = CGPointMake(immageView1.frame.size.width+immageView1.frame.origin.x, _point.y);
        
        //
        NSString *str2 = ceDic[@"title"];
        CGFloat length2 = [self getStr:str2 andFont:B-5];
        [self upDataPint:length2];
        
        UIImageView *immageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x-5, _point.y, length2+20, 20)];
        UIImage* img=[UIImage imageNamed:@"kk1(2)"];//原图
        
        img = [img stretchableImageWithLeftCapWidth:15 topCapHeight:9];
        immageView2.image=img;
        immageView2.userInteractionEnabled = YES;
        [self.contentView addSubview:immageView2];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, length2+20, 20)];
        label2.text = str2;
        label2.textColor = colorDeepBlue;
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:B-5];
        
        [immageView2 addSubview:label2];
        
        _point = CGPointMake(immageView2.frame.size.width+immageView2.frame.origin.x+5,_point.y);
    }
}

-(void)createImageQuestion:(NSString *)string{
    
    if (string.length == 0) {
        return;
    }
   
    if (_point.x+40 > WIDTH) {
        _point = CGPointMake(15, _point.y+25);
    }
    CGFloat x;
    if (_point.x == 15) {
        x = 15;
    }else{
        x = _point.x + 10;
    }
    
    UIImageView *questionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, _point.y, 20, 20)];
    questionImageView.image = [UIImage imageNamed:@"fw.png"];
    [self.contentView addSubview:questionImageView];
    _point = CGPointMake(questionImageView.frame.origin.x+questionImageView.frame.size.width+5, _point.y);
    
    if (_point.x+70 > WIDTH-20) {
        _point = CGPointMake(10, _point.y+25);
    }
    
    NSArray *arr = [string componentsSeparatedByString:@","];
    
    for (int i = 0; i < arr.count; i ++) {
        CGFloat w = [self getStr:arr[i] andFont:B-5];
        [self upDataPint:w];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_point.x, _point.y, w+20, 20)];
        UIImage *image = [UIImage imageNamed:@"tt_09.png"];
        image = [image stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        imageView.image = image;
        [self.contentView addSubview:imageView];
        
        UILabel *labelServer = [LHController createLabelWithFrame:CGRectMake(0, 0, w+20, 20) Font:B-5 Bold:NO TextColor:nil Text:arr[i]];
        labelServer.textColor = colorYellow;
        labelServer.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:labelServer];
        
        _point = CGPointMake(imageView.frame.origin.x+imageView.frame.size.width+5, imageView.frame.origin.y);
    }
}

#pragma mark - 计算字符串长度
-(CGFloat)getStr:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - 计算坐标
-(void)upDataPint:(CGFloat)length{
    if (length+_point.x > WIDTH-30) {
        _point = CGPointMake(15, _point.y+25);
    }
}

+(instancetype)manager{
    static ComplainListCell *complainListcell = nil;
    if (complainListcell == nil) {
        complainListcell = [[ComplainListCell alloc] init];
    }
    for (UIView *vi in complainListcell.contentView.subviews) {
        [vi removeFromSuperview];
    }
    return complainListcell;
}

+(CGFloat)returnCellHeight:(NSDictionary *)dict{
    ComplainListCell *cell = [ComplainListCell manager];
    
    cell.point = CGPointMake( 15, 105);
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[dict[@"tsbw"] componentsSeparatedByString:@","]];
    [array removeObject:@""];
    [cell createImageCar:array];
    [cell createImageQuestion:dict[@"fwtd"]];

    return cell.point.y+40;
}

#pragma mark 属性化字符串
-(NSAttributedString *)attributeSize:(NSString *)str Font:(CGFloat)size{
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, att.length)];
    
    // [att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:0.5] range:NSMakeRange(0,att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:NSMakeRange(0, 3)];
    NSRange range = [str rangeOfString:@"车系："];
    [att addAttribute:NSForegroundColorAttributeName value:colorLightGray range:range];
    
    return att;
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
