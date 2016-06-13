
//  MyCarCell.m
//  auto
//
//  Created by bangong on 15/7/24.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCarCell.h"

@implementation MyCarCell
{
    UILabel *labelLeft;
    UITextField *textFieldRight;
    UIImageView *iconImageView;
    CGFloat B;
    UIView *sexView;
    UILabel *nameLabel;
}
- (void)awakeFromNib {
    // Initialization code
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //创建UI
        B = [LHController setFont];
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    labelLeft = [LHController createLabelWithFrame:CGRectMake(LEFT, 10, 100, 20) Font:B Bold:NO TextColor:nil Text:nil];
    [self.contentView addSubview:labelLeft];
    

    textFieldRight = [[UITextField alloc] initWithFrame:CGRectMake(LEFT*2+100, 0, WIDTH-100-LEFT*4, 40)];
    textFieldRight.textColor = [UIColor grayColor];
    textFieldRight.delegate = self;
    textFieldRight.font = [UIFont systemFontOfSize:B];
    textFieldRight.returnKeyType = UIReturnKeyDone;
    textFieldRight.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:textFieldRight];
    
    nameLabel  = [LHController createLabelWithFrame:CGRectMake(LEFT*2+100, 0, WIDTH-100-LEFT*4, 40) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@""];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:nameLabel];
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-96, 10, 66, 66 )];
    iconImageView.image  = [UIImage imageNamed:@"defaultImage_icon"];
    iconImageView.backgroundColor = [UIColor grayColor];
    iconImageView.userInteractionEnabled = YES;
//    iconImageView.layer.cornerRadius = iconImageView.frame.size.width/2;
//    iconImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [iconImageView addGestureRecognizer:tap];
    [self.contentView addSubview:iconImageView];
}


-(void)setDictCar:(NSDictionary *)dictCar{
 
    if (_dictCar != dictCar) {
        _dictCar = nil;
        _dictCar = dictCar;
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    labelLeft.text = _dictCar[@"left"];
    textFieldRight.text = _dictCar[@"right"];
    [sexView removeFromSuperview];
    if (self.num == 0) {
        nameLabel.hidden = YES;
        labelLeft.frame =CGRectMake(LEFT, 33, 100, 20);
        textFieldRight.hidden = YES;
        iconImageView.hidden = NO;
        [[SDImageCache sharedImageCache] removeImageForKey:_dictCar[@"right"] fromDisk:YES];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:_dictCar[@"right"]] placeholderImage:[UIImage imageNamed:@"defaultImage_icon"]];
    }
    else if (self.num == 1){
        
        nameLabel.hidden = NO;
        textFieldRight.hidden = YES;
        iconImageView.hidden = YES;
        nameLabel.text = _dictCar[@"right"];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (self.num == 3){
        self.accessoryType = UITableViewCellAccessoryNone;
        nameLabel.hidden = YES;
        textFieldRight.hidden = YES;
        iconImageView.hidden = YES;
        sexView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH-100-LEFT*2-3, 0, 100, 40)];
        [self.contentView addSubview:sexView];
        
        UIButton *manBtn = [LHController createButtnFram:CGRectMake(0, 5, 30, 30) Target:self Action:@selector(manClick:)];
        manBtn.tag = 101;
        [sexView addSubview:manBtn];
        
        UILabel *manLabel = [LHController createLabelWithFrame:CGRectMake(manBtn.frame.origin.x+manBtn.frame.size.width+3, 10, 20, 20) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@"男"];
        [sexView addSubview:manLabel];
        
        UIButton *womenBtn = [LHController createButtnFram:CGRectMake(manLabel.frame.origin.x+manLabel.frame.size.width+10,5, 30, 30) Target:self Action:@selector(womenClick:)];
        womenBtn.tag = 102;
        [sexView addSubview:womenBtn];
        UILabel *womenLabel = [LHController createLabelWithFrame:CGRectMake(womenBtn.frame.origin.x+womenBtn.frame.size.width+3,10, 20, 20) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@"女"];
        [sexView addSubview:womenLabel];
        
        if ([_dictCar[@"right"] integerValue] == 2) {
            womenBtn.selected = YES;
            manBtn.selected = NO;
        }else{
            womenBtn.selected = NO;
            manBtn.selected = YES;
        }

    }
    else{
        nameLabel.hidden = YES;
        labelLeft.frame =CGRectMake(LEFT, 10, 100, 20);
        textFieldRight.hidden = NO;
        iconImageView.hidden = YES;
    }
}

-(void)manClick:(UIButton *)btn{
    btn.selected = YES;
    UIButton *button = (UIButton *)[self.contentView viewWithTag:102];
    button.selected = NO;
    if (self.myBlock) {
        self.myBlock(_dictCar[@"key"],@"1");
    }
}

-(void)womenClick:(UIButton *)btn{
    btn.selected = YES;
    UIButton *button = (UIButton *)[self.contentView viewWithTag:101];
    button.selected = NO;
    if (self.myBlock) {
        self.myBlock(_dictCar[@"key"],@"2");
    }
}

-(void)tap:(UITapGestureRecognizer *)tap{
    if (self.iconImage) {
        self.iconImage(iconImageView);
    }
}

-(void)getStr:(void(^)(NSString *key,NSString *right))block{
    self.myBlock = block;
}

-(void)getCell:(void (^)(MyCarCell *,UITextField *,NSInteger))block{
    self.myCell = block;
}

-(void)getIconImageView:(void (^)(UIImageView *))block{
    self.iconImage = block;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.contentView endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.accessoryType = UITableViewCellAccessoryNone;
    if (self.num == 5)textFieldRight.keyboardType = UIKeyboardTypeEmailAddress;
    if (self.num == 6)textFieldRight.keyboardType = UIKeyboardTypeNumberPad;
    if (self.num == 8)textFieldRight.keyboardType = UIKeyboardTypeEmailAddress;
    if (self.myCell) {
        self.myCell(self,textFieldRight,self.num);
    }
    if ([_dictCar[@"left"] isEqualToString:@"生日"]) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.myBlock) {
        self.myBlock(_dictCar[@"key"],textFieldRight.text);
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
