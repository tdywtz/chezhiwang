//
//  PasswordViewController.m
//  auto
//
//  Created by bangong on 15/8/3.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()<UITextFieldDelegate>

@end

@implementation PasswordViewController
{
    UITextField *oldPassword;
    UITextField *newPassword;
    UITextField *confirmPassword;
    UIScrollView *scrollView;
    CGFloat temp;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"密码修改";
    self.view.backgroundColor = [UIColor whiteColor];
    

    //[self createRightItem];
    [self createTextField];
    [self createTap];
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
    scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-height);
    CGFloat gao = HEIGHT - 64 - height-temp;
    if (gao > 0) {
        gao = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-height);
        scrollView.contentOffset = CGPointMake(0, -gao);
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{
    scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    scrollView.contentOffset = CGPointMake(0, 0);
}


-(void)submitClick{
    
    if (oldPassword.text.length == 0) {
        [self alert:@"请输入当前密码"];
        return;
    }
    if (newPassword.text.length == 0) {
        [self alert:@"请输入新密码"];
        return;
    }
    if (newPassword.text.length < 6 || newPassword.text.length > 20) {
        [self alert:@"密码长度需在6到20个字符之间"];
        return;
    }
    if (![self password:newPassword.text]) {
        [self alert:@"密码不能是完全一样的字符"];
        return;
    }
    if(![newPassword.text isEqualToString:confirmPassword.text]){
        [self alert:@"两次输入的新密码不相同，请重新输入"];
        return;
    }
    
    for (int i= 0; i < newPassword.text.length; i ++) {
        unichar c = [newPassword.text characterAtIndex:i];
        if (!(c >= 0 && c <= 127)) {
            [self alert:@"密码只能是字母、数字、字符组成"];
            return;
        }
    }
    [self updatePassword];
}

-(BOOL)password:(NSString *)str{
    for (int i = 0; i < str.length; i ++) {
        NSString *te = [str substringWithRange:NSMakeRange(0, 1)];
        NSString *sub = [str substringWithRange:NSMakeRange(i, 1)];
        if (![sub isEqualToString:te]) {
            return YES;
        }
    }
    return NO;
}

-(void)createTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
-(void)updatePassword{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUpdatePWD],[[NSUserDefaults standardUserDefaults] objectForKey:user_id],oldPassword.text,newPassword.text];
   [HttpRequest GET:url success:^(id responseObject) {
       NSString *str = [[responseObject objectAtIndex:0] objectForKey:@"result"];
       [self alert:str];

   } failure:^(NSError *error) {
       
   }];
}

-(void)createTextField{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    [self.view addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 329*(WIDTH/640.0))];
    imageView.image = [UIImage imageNamed:@"sife"];
    [scrollView addSubview:imageView];
    
    NSArray *array = @[@"当前密码",@"新密码",@"确认密码"];
    for (int i = 0; i < array.count; i ++) {
       
       UITextField *textField = [LHController createTextFieldWithFrame:CGRectMake(LEFT, imageView.frame.size.height+i*51, WIDTH-LEFT, 50) andBGImageName:nil andPlaceholder:array[i] andTextFont:17 andSmallImageName:nil andDelegate:self];
        textField.secureTextEntry = YES;
        [scrollView addSubview:textField];
        if (i == 0) {
            oldPassword = textField;
        }else if(i == 1){
            newPassword = textField;
        }else{
            confirmPassword = textField;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, textField.frame.origin.y+textField.frame.size.height, WIDTH, 1)];
        view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [scrollView addSubview:view];
        
        if (i == 2) {
            UIButton *btn = [LHController createButtnFram:CGRectMake(LEFT, textField.frame.origin.y+textField.frame.size.height+40, WIDTH-LEFT*2, 35) Target:self Action:@selector(submitClick) Font:17 Text:@"提交"];
            [scrollView addSubview:btn];
            scrollView.contentSize = CGSizeMake(0, btn.frame.origin.y+btn.frame.size.height+50);
        }
    }
}

-(void)alert:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [al dismissWithClickedButtonIndex:0 animated:YES];
    });
}


#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    temp = textField.frame.origin.y+textField.frame.size.height;
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
