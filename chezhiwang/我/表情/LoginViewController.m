//
//  LoginViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/13.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ComplainView.h"
#import "RegisterViewController.h"
#import "AskViewController.h"
#import "BasicNavigationController.h"
#import "LookPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_userName;
    UITextField *_passWord;
    UIScrollView *_scrollView;
    UIButton *logoin;
    CGFloat B;
}
@end

@implementation LoginViewController

+ (UINavigationController *)instance{
    LoginViewController *login = [[LoginViewController alloc] init];
    BasicNavigationController *nvc = [[BasicNavigationController alloc] initWithRootViewController:login];
    return nvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createLeftItemBack];
    self.view.backgroundColor = RGB_color(240, 240, 240, 1);
    B = [LHController setFont];
    self.navigationItem.title = @"登录";
    [self createScrollView];
 
    [self createRightItem];
    [self createField];
    [self createLogoin];
    [self createNotification];
}

-(void)createScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
}

#pragma mark - 注册按钮
-(void)createRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 35, 20);
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn .titleLabel.font = [UIFont boldSystemFontOfSize:B-1];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)btnClick{
    RegisterViewController *rvc = [[RegisterViewController alloc] init];
    [rvc login:^(NSString *name, NSString *passwoed) {
        [self submitNmae:name andPassword:passwoed];
    }];
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)createField{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 160)];
    imageView.image = [UIImage imageNamed:@"defaultImage_icon"];
    [_scrollView addSubview:imageView];

    UIImageView *userNameImageView =[LHController createImageViewWithFrame:CGRectMake(10, 8, 20, 20) ImageName:@"userName.png"];
    UIImageView *tempUserNameImageView = [LHController createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempUserNameImageView addSubview:userNameImageView];
    
    _userName = [LHController createTextFieldWithFrame:CGRectMake(10, 160, WIDTH-20, 50) Placeholder:@"用户名" Font:15  Delegate:self];
    _userName.leftView = tempUserNameImageView;
    _userName.backgroundColor = [UIColor whiteColor];
    _userName.layer.borderColor = RGB_color(221, 221, 221, 1).CGColor;
    _userName.layer.borderWidth = 1;
    [_scrollView addSubview:_userName];
    
    UIImageView *passwordImageView =[LHController createImageViewWithFrame:CGRectMake(10, 8, 20, 20) ImageName:@"user_password"];
    UIImageView *tempPasswordImageView = [LHController createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:nil];
    [tempPasswordImageView addSubview:passwordImageView];
    
    _passWord = [LHController createTextFieldWithFrame:CGRectMake(10, _userName.frame.origin.y+_userName.frame.size.height-1, WIDTH-20, 50) Placeholder:@"密码" Font:15  Delegate:self];
    _passWord.leftView = tempPasswordImageView;
    _passWord.secureTextEntry = YES;
    _passWord.backgroundColor = [UIColor whiteColor];
    _passWord.layer.borderColor = RGB_color(221, 221, 221, 1).CGColor;
    _passWord.layer.borderWidth = 1;
    [_scrollView addSubview:_passWord];
}

#pragma mark - createLogoin
-(void)createLogoin{
    logoin =  [LHController createButtnFram:CGRectMake(10, _passWord.frame.origin.y+_passWord.frame.size.height+60, WIDTH-20, 40) Target:self Action:@selector(logoinClick) Font:B Text:@"点击登录"];
    
    [_scrollView addSubview:logoin];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(0, 300, 30, 30) Target:self Action:@selector(buttonClick) Text:@"找回密码"];
    button.titleLabel.font = [UIFont systemFontOfSize:B];
    [button setTitleColor:[UIColor colorWithRed:6/255.0 green:143/255.0 blue:207/255.0 alpha:1] forState:UIControlStateNormal];
    [_scrollView addSubview:button];
    
   [button makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(logoin.bottom).offset(20);
       make.right.equalTo(logoin);
       make.height.equalTo(30);
   }];
}

-(void)buttonClick{
    LookPasswordViewController *look = [[LookPasswordViewController alloc] init];
    [self.navigationController pushViewController:look animated:YES];
}

#pragma mark - 登录响应按钮
-(void)logoinClick{
    
    if(_userName.text.length == 0 || _passWord.text.length == 0){
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [al show];
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        logoin.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self submitNmae:_userName.text andPassword:_passWord.text];
        });
    }
}

#pragma mark 提交登录
-(void)submitNmae:(NSString *)name andPassword:(NSString *)pass{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForLogin],name,pass];
   [HttpRequest GET:url success:^(id responseObject) {
       NSString *str = [responseObject firstObject][@"error"];
       if (str != nil) {
           if ([str isEqualToString:@"1"]) {
               [LHController alert:@"用户名或密码错误"];
           }else if([str isEqualToString:@"2"]){
               [LHController alert:@"密码错误"];
               
           }else if ([str isEqualToString:@"3"]){
               [LHController alert:@"用户名不存在"];
           }
           else{
               [LHController alert:@"因发布非法信息，您的账号已封停"];
           }
       }else{
           [[CZWManager manager] loginWithDictionary:[responseObject firstObject]];
           NSDictionary *dic = [responseObject firstObject];
           NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
           [df setObject:dic[@"name"] forKey:user_name];
           [df setObject:dic[@"path"] forKey:user_iconImage];
           [df setObject:_passWord.text forKey:user_passWord];
           [df setObject:dic[@"userid"] forKey:user_id];
           
           [self saveTime];
           if (self.navigationController.viewControllers.count > 1){
                [self.navigationController popViewControllerAnimated:YES];

           }else{
[self dismissViewControllerAnimated:YES completion:nil];
           }
       }
       logoin.enabled = YES;

   } failure:^(NSError *error) {
       
       logoin.enabled = YES;
       UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"网络请求失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
       [al show];
       [UIView animateWithDuration:0.3 animations:^{
           [al dismissWithClickedButtonIndex:0 animated:YES];
       }];
   }];
}

#pragma mark - 提示语
-(void)saveTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //
   // NSString *str = [formatter stringFromDate:[NSDate date]];
    //[[NSUserDefaults standardUserDefaults] setObject:str forKey:inDate];
}



#pragma mark - uitxetfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
    _scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-height);
}

-(void)keyboardHide:(NSNotification *)notification
{
    _scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    _scrollView.contentOffset = CGPointMake(0, 0);
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
