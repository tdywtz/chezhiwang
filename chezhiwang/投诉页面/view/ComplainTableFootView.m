//
//  ComplainTableFootView.m
//  chezhiwang
//
//  Created by bangong on 16/11/10.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainTableFootView.h"

@interface ComplainTableFootView ()
{
    UITextField *codeTextField;
    UIButton *codeButton;
    UILabel *describeLabel;
    NSString *code;//验证码
}
@end

@implementation ComplainTableFootView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        [self makeUI];
        [self codeButtonClick];
    }
    return self;
}

- (void)makeUI{
    codeTextField = [[UITextField alloc] init];
    codeTextField.font = [UIFont systemFontOfSize:13];
    codeTextField.placeholder = @"输入验证码";
    codeTextField.layer.borderColor = RGB_color(221, 221, 221, 1).CGColor;
    codeTextField.layer.borderWidth = 1;
    codeTextField.textAlignment = NSTextAlignmentCenter;

    codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    codeButton.layer.borderWidth = 1;
    [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [codeButton setTitleColor:colorYellow forState:UIControlStateNormal];
    codeButton.layer.borderColor = RGB_color(221, 221, 221, 1).CGColor;

    describeLabel = [[UILabel alloc] init];
    describeLabel.font = [UIFont systemFontOfSize:12];
    describeLabel.textColor = colorLightGray;
    describeLabel.text = @"看不清请点击验证码图片";

    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.layer.cornerRadius = 3;
    submitButton.layer.masksToBounds = YES;
    submitButton.backgroundColor = colorYellow;
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"提 交" forState:UIControlStateNormal];

    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.textColor = colorOrangeRed;
    promptLabel.text = @"注：请认真填写，待网站审核后不能修改";

    [self addSubview:codeTextField];
    [self addSubview:codeButton];
    [self addSubview:submitButton];
    [self addSubview:promptLabel];
    [self addSubview:describeLabel];

    codeTextField.lh_left = 10;
    codeTextField.lh_top = 30;
    codeTextField.lh_size = CGSizeMake(80, 30);

    codeButton.lh_left = codeTextField.lh_right+10;
    codeButton.lh_top = codeTextField.lh_top;
    codeButton.lh_size = CGSizeMake(70, 30);

    describeLabel.lh_left = codeButton.lh_right+10;
    describeLabel.lh_top = codeTextField.lh_top;
    describeLabel.lh_height = 30;
    describeLabel.lh_width = WIDTH - describeLabel.lh_left-10;

    submitButton.lh_left = 10;
    submitButton.lh_top = codeTextField.lh_bottom+20;
    submitButton.lh_size = CGSizeMake(WIDTH-20, 40);

    [promptLabel sizeToFit];
    promptLabel.lh_left = submitButton.lh_left;
    promptLabel.lh_top = submitButton.lh_bottom+20;

    CGRect rect = CGRectMake(0, 0, WIDTH, 100);
    rect.size.height = promptLabel.lh_bottom+40;
    self.frame = rect;
}

- (void)codeButtonClick{
    [codeButton setTitle:[self codeString] forState:UIControlStateNormal];
}

- (void)submitClick{
    BOOL isEqual = NO;
    if ([code isEqualToString:codeTextField.text]) {
        isEqual = YES;
    }
    if (self.submit) {
        self.submit(isEqual);
    }
}

- (NSString *)codeString{
    NSString *textString = [NSString stringWithFormat:@"%u",arc4random()%10];
    code = [textString copy];
    NSString *string = [NSString stringWithFormat:@"%@",textString];

    textString = [NSString stringWithFormat:@"%u",arc4random()%10];
    code       = [NSString stringWithFormat:@"%@%@",code,textString];
    string     = [NSString stringWithFormat:@"%@ %@",string,textString];

    textString = [NSString stringWithFormat:@"%u",arc4random()%10];
    code       = [NSString stringWithFormat:@"%@%@",code,textString];
    string     = [NSString stringWithFormat:@"%@ %@",string,textString];

    textString = [NSString stringWithFormat:@"%u",arc4random()%10];
    code       = [NSString stringWithFormat:@"%@%@",code,textString];
    string     = [NSString stringWithFormat:@"%@ %@",string,textString];

    return string;
}

- (void)submit:(void (^)(BOOL isEqual))submit{
    self.submit = submit;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
