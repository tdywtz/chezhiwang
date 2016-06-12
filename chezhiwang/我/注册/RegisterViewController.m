//
//  RegisterViewController.m
//  auto
//
//  Created by bangong on 15/6/9.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate,UITextViewDelegate,UIWebViewDelegate>
{
    UIScrollView * scrollView;
    UITextField *userNameTextField;
    UITextField *passwordTextField;
    UITextField *certainPassword;
    UITextField *addressTextFeild;
    UIView *serverView;
    //UITextView *_textView;
    UIButton *jujue;
    UIButton *agree;
    UIActivityIndicatorView *_activity;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
    [self createLeftItem];
    [self createTExtField];
    
    // NSString *str = [LHController deviceIPAdress];
    
}

-(void)createTExtField{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    scrollView.alwaysBounceVertical = YES;
    scrollView.backgroundColor = colorLineGray;
    [self.view addSubview:scrollView];
    
    //    for (int i = 0; i < 5; i ++) {
    //        UILabel *label = [ZCControl createLabelWithFrame:CGRectMake(0, 30+45*i, WIDTH, 1.5) Font:11 Text:nil];
    //        label.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    //        [scrollView addSubview:label];
    //    }
    userNameTextField = [LHController createTextFieldWithFrame:CGRectMake(10, 30, WIDTH-20, 45) Placeholder:@"用户名" Font:15  Delegate:self];
    userNameTextField.autocapitalizationType = NO;
    userNameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    userNameTextField.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:userNameTextField];
    
    passwordTextField = [LHController createTextFieldWithFrame:CGRectMake(10, userNameTextField.frame.origin.y+userNameTextField.frame.size.height+1, WIDTH-20, 45) Placeholder:@"密码" Font:15  Delegate:self];
    passwordTextField.autocapitalizationType = YES;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    passwordTextField.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:passwordTextField];
    
    certainPassword = [LHController createTextFieldWithFrame:CGRectMake(10, passwordTextField.frame.origin.y+passwordTextField.frame.size.height+1, WIDTH-20, 45) Placeholder:@"确认密码" Font:15  Delegate:self];
    certainPassword.autocapitalizationType = YES;
    certainPassword.secureTextEntry = YES;
    certainPassword.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    certainPassword.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:certainPassword];
    
    addressTextFeild = [LHController createTextFieldWithFrame:CGRectMake(10, certainPassword.frame.origin.y+certainPassword.frame.size.height+1, WIDTH-20, 45) Placeholder:@"电子邮箱" Font:15  Delegate:self];
    addressTextFeild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    addressTextFeild.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:addressTextFeild];
    
    [self createRegister];
    [self createLabelAndServerButton];
}

-(void)createRegister{
    
    UIButton *registerBtn = [LHController createButtnFram:CGRectMake(10, addressTextFeild.frame.origin.y+70, WIDTH-20, 40)  Target:self Action:@selector(registerClick:) Font:17 Text:@"注册"];
    [scrollView addSubview:registerBtn];
}

#pragma mark - 点击注册
-(void)registerClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    if (![passwordTextField.text isEqualToString:certainPassword.text]) {
        [self alert:@"两次密码输入不匹配，请重新输入"];
    }else if (!userNameTextField.text.length){
        [self alert:@"请输入用户名"];
    }else if (!passwordTextField.text.length){
        [self alert:@"请输入密码"];
    }else{
        if (passwordTextField.text.length < 6 || passwordTextField.text.length > 20) {
            [self alert:@"密码长度需在6到20个字符之间"];
            return;
        }
        if (userNameTextField.text.length < 4 || userNameTextField.text.length > 20) {
            [self alert:@"用户名必须在4-20个字符之间"];
        }
        
        if (![LHController judegmentChar:userNameTextField.text]){
            [self alert:@"用户名只能包含汉字、字母、数字"];
            return;
        }
        if (![LHController emailTest:addressTextFeild.text]){
            if(addressTextFeild.text.length == 0)
                [self alert:@"邮箱不能为空"];
            else
                [self alert:@"邮箱格式不正确"];
            return;
        }
        
        if (![self password:passwordTextField.text]){
            [self alert:@"密码不能是完全一样的字符"];
            return;
        }
        
        [self serverButtonClick:nil];
    }
}

-(BOOL)password:(NSString *)str{
    for (int i = 0; i < str.length; i ++) {
        NSString *temp = [str substringWithRange:NSMakeRange(0, 1)];
        NSString *sub = [str substringWithRange:NSMakeRange(i, 1)];
        if (![sub isEqualToString:temp]) {
            
            return YES;
        }
    }
    return NO;
}

-(void)alert:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [al show];
}

#pragma mark - post数据
-(void)registerData{
    [MobClick endEvent:@"register"];//友盟统计
    if (userNameTextField.text.length == 0 || passwordTextField.text.length == 0) {
        return;
    }
    
    NSDictionary *dict = @{@"uname":userNameTextField.text,@"psw":passwordTextField.text,@"email":addressTextFeild.text,@"origin":@"7"};
    
  [HttpRequest POST:[URLFile urlStringForRegister] parameters:dict success:^(id responseObject) {
      
      if ([responseObject isKindOfClass:[NSArray class]]) {
          if ([responseObject count] > 0) {
              NSDictionary *dict = responseObject[0];
              NSString *str = [dict objectForKey:@"error"];
              if (str != nil) {
                  [self alert:str];
              }else{
                  if (dict[@"name"] != nil) {
                      if (self.succeed) {
                          self.succeed(userNameTextField.text,passwordTextField.text);
                      }
                      [self.navigationController popViewControllerAnimated:YES];
                  }
              }
          }
      }

  } failure:^(NSError *error) {
       [self alert:@"网络请求失败"];
  }];
}


#pragma mark - 底部label、服务协议按钮
-(void)createLabelAndServerButton{
    UIButton *serverButton = [LHController createButtnFram:CGRectMake(LEFT, addressTextFeild.frame.origin.y+130, WIDTH-LEFT*2, 20) Target:self Action:@selector(serverButtonClick:) Text:@"点击注册即表示已阅读并同意《网络服务协议》"];
    serverButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [serverButton setTitleColor:colorOrangeRed forState:UIControlStateNormal];
    [scrollView addSubview:serverButton];
    
    //    UIImageView *iamgeView = [ZCControl createImageViewWithFrame:CGRectMake(0, 0, 390*40/59.0, 40) ImageName:@"wz_03.png"];
    //    iamgeView.center = CGPointMake(WIDTH/2, 440);
    //    [scrollView addSubview:iamgeView];
    
    scrollView.contentSize = CGSizeMake(0, serverButton.frame.origin.y+100);
}

#pragma mark - 点击服务协议弹出页面
-(void)serverButtonClick:(UIButton *)btn{
    if (serverView == nil) {
        serverView = [[UIView alloc] initWithFrame:CGRectMake(-WIDTH, 20, WIDTH, HEIGHT-20)];
        serverView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:serverView];
        
        jujue = [LHController createButtnFram:CGRectMake(WIDTH/2+LEFT, serverView.frame.size.height-50, WIDTH/2-LEFT*2, 40) Target:self Action:@selector(tongyi:) Text:@"拒绝"];
        [jujue setBackgroundColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1]];
        jujue.layer.cornerRadius = 2;
        jujue.layer.masksToBounds = YES;
        [serverView addSubview:jujue];
        
        agree = [LHController createButtnFram:CGRectMake(LEFT, serverView.frame.size.height-50, WIDTH/2-LEFT*2, 40) Target:self Action:@selector(tongyi:) Text:@"我接受"];
        [agree setBackgroundColor:[UIColor colorWithRed:255/255.0 green:84/255.0 blue:0/255.0 alpha:1]];
        agree.layer.cornerRadius = 2;
        agree.layer.masksToBounds = YES;
        [serverView addSubview:agree];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 40, WIDTH-20, serverView.frame.size.height-100)];
        webView.delegate = self;
        
        NSURL *url = [NSURL URLWithString:xieyi];
        [ webView setScalesPageToFit:YES];
        webView.pageLength = 10;
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        [webView loadData:data MIMEType:@"text/html" textEncodingName:@"GBK" baseURL:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [serverView addSubview:webView];
        
    }
    
    if (btn != nil) {
        agree.hidden = YES;
        
        jujue.frame = CGRectMake(LEFT, serverView.frame.size.height-50, WIDTH-LEFT*2, 40);
        [jujue setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        agree.hidden = NO;
        // jujue.center = CGPointMake(WIDTH/4, serverView.frame.size.height-30);
        jujue.frame = CGRectMake(WIDTH/2+LEFT, serverView.frame.size.height-50, WIDTH/2-LEFT*2, 40);
        [jujue setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.1 animations:^{
        serverView.frame = CGRectMake(0, 20, WIDTH, HEIGHT-20);
    }];
}

-(void)tongyi:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"我接受"]) {
        [self registerData];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        serverView.frame = CGRectMake(-WIDTH, 20, WIDTH, HEIGHT-20);
    }];
}

#pragma mark - 返回
-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(itemClick)];
}

-(void)itemClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - webView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activity stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_activity stopAnimating];
}
#pragma mark 回调
-(void)login:(void (^)(NSString *, NSString *))block{
    self.succeed = block;
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
