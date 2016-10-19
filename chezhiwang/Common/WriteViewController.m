//
//  WriteViewController.m
//  chezhiwang
//
//  Created by bangong on 16/10/11.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "WriteViewController.h"

@interface WriteViewController ()
{
    UITextView *_textView;
    UIView *_bgView;
    UILabel *titleLabel;
}

@end

@implementation WriteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.5];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self createNotification];
        [self makeUI];
        [_textView becomeFirstResponder];
    }
    return self;
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
    CGRect frame = _bgView.frame;
    frame.origin.y = HEIGHT-height-frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.frame = frame;
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{
    [self close];
}


-(void)makeUI{


    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 200)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];

    UIButton *cancel = [LHController createButtnFram:CGRectMake(10, 10, 40, 20) Target:self Action:@selector(cancelClick) Text:@"取消"];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel setTitleColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [_bgView addSubview:cancel];

    UIButton *certain =  [LHController createButtnFram:CGRectMake(WIDTH-50, 10, 40, 20) Target:self Action:@selector(certainClick) Text:@"发送"];
    certain.titleLabel.font = [UIFont systemFontOfSize:15];
    [certain setTitleColor:[UIColor colorWithRed:5/255.0 green:143/255.0 blue:206/255.0 alpha:1] forState:UIControlStateNormal];
    [_bgView addSubview:certain];

    titleLabel =  [LHController createLabelWithFrame:CGRectMake(WIDTH/2-20, 10, 40, 20) Font:17 Bold:NO TextColor:nil Text:@"评论"];
    [_bgView addSubview:titleLabel];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, WIDTH, 1)];
    bgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [_bgView addSubview:bgView];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 34, WIDTH, 150)];
    _textView.font = [UIFont systemFontOfSize:16];
    //_textView.delegate = self;
    [_bgView addSubview:_textView];
}

-(void)cancelClick{
    [_textView resignFirstResponder];
    [self close];
}

-(void)certainClick{
    [_textView resignFirstResponder]; 
    if (self.sendBlick) {
        self.sendBlick(_textView.text);
    }
    [self close];
}

-(void)setLabelText:(NSString *)labelText{
    _labelText = labelText;
    titleLabel.text = labelText;
}

-(void)send:(void (^)(NSString *))block{
    self.sendBlick = block;
}

-(void)close{

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
