//
//  WritePostCell.m
//  demo
//
//  Created by bangong on 15/11/6.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "WritePostCell.h"

@interface WritePostCell()<UITextViewDelegate>
{
    UIImageView *imageView;
    UITextView *_textView;
    UILabel *placeholderLabel;
}
@end

@implementation WritePostCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

-(void)createUI{
   
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 80, 80)];
    [self.contentView addSubview:imageView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(90, 5, [[UIScreen mainScreen] bounds].size.width-100, 80)];
    _textView.delegate = self;
    _textView.backgroundColor = colorBackGround;
    _textView.font = [UIFont systemFontOfSize:[LHController setFont]-3];
    [self.contentView addSubview:_textView];
    
    placeholderLabel = [LHController createLabelWithFrame:CGRectMake(3, 5, 140, 20) Font:[LHController setFont]-3 Bold:NO TextColor:colorLightGray Text:@"添加图片描述"];
    [_textView addSubview:placeholderLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-30, 5, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"write_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

-(void)btnClick{
    if (self.block) {
        self.block(self.asset,self);
    }
}

-(void)setAsset:(UIImage *)asset{
    if (_asset != asset) {
        _asset = nil;
        _asset = asset;
    }
    _textView.text = self.describe;
    
    imageView.image = self.asset;
}

-(void)deleteCell:(deleteCell)block{
    self.block = block;
}


-(void)returnConent:(returnContent)block{
    self.contentBlock = block;
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length == 0) {
        placeholderLabel.hidden = NO;
    }else{
        placeholderLabel.hidden = YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
     //NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    if (self.contentBlock) {
        self.contentBlock(textView.text,self.asset,self);
    }
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
