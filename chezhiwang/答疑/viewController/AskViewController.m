//
//  AskViewController.m
//  auto
//
//  Created by bangong on 15/6/8.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AskViewController.h"
#import "MyAskViewController.h"

#define SPACE 35
#define H 30

@interface AskViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UITextField *titleField;
    UITextView *contentView;
    UITextField *_testField;
    UILabel *textLabel;
    UILabel *PlaceholderLebel;
    
    UIScrollView *scrollView;
    CGFloat B;
    UIButton *button;
    CGFloat frame_y;//testfield纵坐标
}
@property (nonatomic,copy) NSString *code;
@end

@implementation AskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    B = [LHController setFont];
 
    self.navigationItem.title = @"我要提问";
    self.view.backgroundColor = [UIColor whiteColor];

    [self createScrollView];
    [self createUI];
    [self onTapToGenerateCode:nil];
    [self createNotification];
}

#pragma mark - 通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat gao = HEIGHT-64-(frame_y-scrollView.contentOffset.y)-height;
    if (gao > 0) {
        gao = 0;
    }
    CGRect rect = self.view.frame;
    rect.size.height -= height;
    scrollView.frame = rect;
    [UIView animateWithDuration:0.2 animations:^{
        
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-gao);
        
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{

    scrollView.frame = self.view.frame;

}

-(void)createScrollView{
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
-(void)tap{
    [self.view endEditing:YES];
}

-(void)createUI{
    UILabel *labelLeftTitle = [self createLabel:@"*" andFont:B andFram:CGRectMake(LEFT+10, 11.5, 10, H)];
    [scrollView addSubview:labelLeftTitle];

    
    titleField = [LHController createTextFieldWithFrame:CGRectMake(LEFT+20, 10, WIDTH-LEFT*2-20, H)  andBGImageName:nil andPlaceholder:@"输入标题(最多20个字)" andTextFont:B+1 andSmallImageName:nil andDelegate:self];
    [scrollView addSubview:titleField];
    titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *fg = [[UIView alloc] initWithFrame:CGRectMake(LEFT, titleField.frame.origin.y+titleField.frame.size.height+10, WIDTH-LEFT*2, 1)];
    fg.backgroundColor = colorLineGray;
    [scrollView addSubview:fg];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(LEFT, fg.frame.origin.y+15, WIDTH-LEFT*2, 340)];
    bgView.backgroundColor = colorLineGray;
    [scrollView addSubview:bgView];
    
    UILabel *labelLeftContent = [self createLabel:@"*" andFont:B andFram:CGRectMake(10, 5, 10, H)];
    [bgView addSubview:labelLeftContent];
    
    
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, bgView.frame.size.width-10, 330)];
    contentView.font = [UIFont systemFontOfSize:B-2];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.delegate  = self;
    [bgView addSubview:contentView];
    
    PlaceholderLebel = [LHController createLabelWithFrame:CGRectMake(22, 7, 80, 20) Font:B-2 Bold:NO TextColor:colorLightGray Text:@"输入内容"];
    [bgView addSubview:PlaceholderLebel];
    
    _testField = [LHController createTextFieldWithFrame:CGRectMake(LEFT, bgView.frame.origin.y+bgView.frame.size.height+30, 100, H)  andBGImageName:@"textView.png" andPlaceholder:@"输入验证码" andTextFont:B+1 andSmallImageName:nil andDelegate:self];
    _testField.layer.borderWidth = 1;
    _testField.layer.borderColor = colorLineGray.CGColor;
    [scrollView addSubview:_testField];
    
    textLabel = [self createLabel:nil andFont:B-4 andFram:CGRectMake(LEFT+105, _testField.frame.origin.y, 60, H)];
    textLabel.userInteractionEnabled = YES;
    textLabel.backgroundColor = [UIColor grayColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode:)];
    [textLabel addGestureRecognizer:tap];
    [scrollView addSubview:textLabel];
    
    UILabel *label = [self createLabel:@"看不清请点击验证码图片" andFont:B-5 andFram:CGRectMake( LEFT+170, _testField.frame.origin.y,WIDTH-LEFT+170, H)];
    label.textColor = colorLightGray;
    [scrollView addSubview:label];
    
    //提交按钮
    button = [LHController createButtnFram:CGRectMake(0, 0, WIDTH-LEFT*2, H+10) Target:self Action:@selector(buttonClick) Font:B Text:@"提  交"];
    button.center = CGPointMake(WIDTH/2, _testField.frame.origin.y+_testField.frame.size.height+50);
    [scrollView addSubview:button];
    
    UILabel *labelTS = [self createLabel:@"注：请认真填写，待网站审核后不能修改" andFont:B-5 andFram:CGRectMake( LEFT, button.frame.origin.y+button.frame.size.height+10, 260, H)];
    [scrollView addSubview:labelTS];
    
    scrollView.contentSize = CGSizeMake(0, labelTS.frame.origin.y+50);
}

#pragma mark - 提交按钮响应事件
-(void)buttonClick{
    
    if (!([_testField.text caseInsensitiveCompare:self.code] == NSOrderedSame)) {
        [self alert:@"验证码不正确，请重新输入"];
        
    }else if (![LHController judegmentSpaceChar:titleField.text]){
        [self alert:@"提问标题不能为空"];
        
    }else if (![LHController judegmentSpaceChar:contentView.text]){
        [self alert:@"提问内容不能为空"];
        
    }else{
        if (titleField.text.length > 20) {
            [self alert:@"标题不能大于20个汉字"];
            
        }else{
            button.enabled = NO;
            button.backgroundColor = [UIColor grayColor];
            [self submitData];
            [MobClick endEvent:@"ask"];//友盟统计
        }
    }
}

#pragma mark - 提示框
-(void)alert:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [al dismissWithClickedButtonIndex:0 animated:YES];
    });
}

#pragma mark - 提交数据
-(void)submitData{
    
    NSDictionary *dict = @{@"id":@"0",@"uid":[CZWManager manager].userID,@"title":titleField.text,@"content":contentView.text,@"origin":@"7"};
    [HttpRequest POST:[URLFile urlStringForEditZJDY] parameters:dict success:^(id responseObject) {
        button.enabled = YES;
        [button setBackgroundColor:[UIColor colorWithRed:254/255.0 green:153/255.0 blue:23/255.0 alpha:1]];
        NSDictionary *dict = responseObject[0];
        if ([dict[@"success"] isEqualToString:@"1"]) {
            
            [self onTapToGenerateCode:nil];

            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [self alert:@"提交失败"];
        }
        
    } failure:^(NSError *error) {
        button.enabled = YES;
        [button setBackgroundColor:[UIColor colorWithRed:254/255.0 green:153/255.0 blue:23/255.0 alpha:1]];
        [self alert:@"提交失败"];
    }];
}

#pragma mark - 控件
//label
-(UILabel *)createLabel:(NSString *)name andFont:(CGFloat)size andFram:(CGRect)fram{
    UILabel *label = [[UILabel alloc] initWithFrame:fram];
    label.text = name;
    label.textColor = RGB_color(255, 84, 0, 1);
    label.font = [UIFont boldSystemFontOfSize:size];
    return label;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [scrollView endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITxetField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    frame_y = textField.frame.origin.y+textField.frame.size.height;
    if (textField == _testField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    frame_y = textView.superview.frame.origin.y+textView.superview.frame.size.height;
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length == 0) {
        PlaceholderLebel.hidden = NO;
    }else{
        PlaceholderLebel.hidden = YES;
    }
}

- (void)onTapToGenerateCode:(UITapGestureRecognizer *)tap {
    for (UIView *view in textLabel.subviews) {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [textLabel setBackgroundColor:color];
    // @} end 生成背景色
    
    // @{
    // @name 生成文字
    const int count = 4;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
        //        if((j >= 58 && j <= 64) || (j >= 91 && j <= 96)){
        //            --x;
        //        }else{
        //            data[x] = (char)j;
        //        }
        if (j >= '0' && j <= '0'+9) {
            data[x] = (char)j;
        }else{
            --x;
        }
        
    }
    NSString *text = [[NSString alloc] initWithBytes:data
                                              length:count encoding:NSUTF8StringEncoding];
    // self.code = text;
    // @} end 生成文字
    
    //CGSize cSize = [@"S" sizeWithFont:[UIFont systemFontOfSize:16]];
    // CGSize cSize = [@"S" sizeWithAttributes:@{@"UIFont":@"16"}];
    CGSize cSize = CGSizeMake(10.0, 17.0);
    int width = textLabel.frame.size.width / text.length - cSize.width;
    int height = textLabel.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0, count = (int)text.length; i < count; i++) {
        pX = arc4random() % width + textLabel.frame.size.width / text.length * i - 1;
        pY = arc4random() % height-3;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, 0,
                                                       textLabel.frame.size.width / 4,
                                                       textLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [textLabel addSubview:tempLabel];
        [str appendFormat:@"%C",c];
    }
    self.code = str;
    str = nil;
    
    return;
}

#pragma mark 回调刷新信息
-(void)notifactionRefresh:(void (^)())block{
    self.refresh = block;
}
@end
