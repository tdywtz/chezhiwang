//
//  AreaViewController.m
//  auto
//
//  Created by bangong on 15/7/31.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "AreaViewController.h"

@interface AreaViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CGFloat B;
    UIScrollView *scrollView;
    UITextField *province;
    UITextField *city;
    UITextField *area;
    UITextView *jiedao;
    UITextField *postcode;
    
    UITextField *textFieldOfPickView;
    UIView *_pickViewOfView;
    UIPickerView *_pickView;
    NSMutableArray *_pickDataArray;
    NSString *pickViewSelectText;
    NSString *tempID;
    NSString *pName;
    NSString *cName;
    NSString *aName;
    NSString *pId;
    NSString *cId;
    NSString *aId;
    NSInteger _number;
    
   // UIButton *doneBt;//数字键盘return
}
@property (nonatomic,strong) NSDictionary *dictionary;
@end

@implementation AreaViewController
- (void)dealloc
{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)loadData{
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForGetPersonalAddress],[CZWManager manager].userID];
    [HttpRequest GET:url success:^(id responseObject) {
        self.dictionary = [responseObject objectAtIndex:0];
        [self setData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"地区设置";

    self.view.backgroundColor = [UIColor whiteColor];
    _pickDataArray  = [[NSMutableArray alloc] init];
    B = [LHController setFont];

    [self createUI];
    [self createChangPickView];
    [self loadData];
    [self createNotification];
    [self createTap];
    
}

-(NSAttributedString *)attributeSize:(NSString *)str{

    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"STHeitiK-Medium" size:B-1] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, att.length)];
    [att addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:1.5] range:NSMakeRange(0,att.length)];
   // [att addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:1] range:NSMakeRange(0, att.length)];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 5);
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 10;
    
    [att addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, att.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    style.firstLineHeadIndent = 30;
    style.paragraphSpacing = 20;
    [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.length)];
//    CGSize size = [att boundingRectWithSize:CGSizeMake(WIDTH-65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    NSLog(@"%f==%f",size.width,size.height);
//    NSLog(@"%@",att);

    return att;
}

-(void)createTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}


#pragma mark - 注册通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
   CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    CGFloat gao = -(HEIGHT-postcode.frame.origin.y-postcode.frame.size.height-height-64);
    if(gao < 0) gao = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-height);
        scrollView.contentOffset = CGPointMake(0, gao);
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{

    scrollView.frame = self.view.frame;
}

#pragma mark - 初始数据
-(void)setData{
    
    pId = self.dictionary[@"pid"];
    cId = self.dictionary[@"cid"];
    aId = self.dictionary[@"aid"];
    pName = self.dictionary[@"pname"];
    cName = self.dictionary[@"cname"];
    aName = self.dictionary[@"aname"];
    
    province.text = self.dictionary[@"pname"];
    city.text = self.dictionary[@"cname"];
    area.text = self.dictionary[@"aname"];
    jiedao.text = self.dictionary[@"address"];
    postcode.text = self.dictionary[@"postcode"];
}

#pragma mark - 提交数据
-(void)getData:(NSDictionary *)dict{


    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUpdatePersonalAddress],[CZWManager manager].userID,self.name,pId,cId,aId,pName,cName,aName,jiedao.text,postcode.text];
    [HttpRequest GET:url success:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self alert:@"上传失败"];
    }];
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

-(void)createUI{
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
    
    UILabel *label1 = [LHController createLabelWithFrame:CGRectMake(LEFT, 40, 90, 30) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@"所在地区:"];
    [scrollView addSubview:label1];
    NSArray *array = @[@"选择省份",@"选择市区",@"选择县区"];
    for (int i = 0; i < array.count; i ++) {
        UITextField *textField = [LHController createTextFieldWithFrame:CGRectMake(LEFT+90, 40+i*35, WIDTH-90-LEFT*2, 30) andBGImageName:@"textView.png" andPlaceholder:array[i] andTextFont:B andSmallImageName:@"xuanze.png" andDelegate:self];
        textField.layer.borderColor =  colorLineGray.CGColor;
        textField.layer.borderWidth = 1;
        [scrollView addSubview:textField];
        if (i == 0) {
            province = textField;
        }else if (i == 1){
            city = textField;
        }else{
            area = textField;
        }
    }
    
    UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, area.frame.origin.y+area.frame.size.height+10, WIDTH, 1)];
    fg1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [scrollView addSubview:fg1];
    
    UILabel *label2 = [LHController createLabelWithFrame:CGRectMake(LEFT, 160, 90, 30) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@"街道地址:"];
    [scrollView addSubview:label2];

    jiedao = [[UITextView alloc] initWithFrame:CGRectMake(LEFT+90, 160, WIDTH-90-LEFT*2, 100)];
    jiedao.delegate = self;
    jiedao.font = [UIFont systemFontOfSize:B];
    jiedao.layer.borderWidth = 1;
    jiedao.layer.borderColor = colorLineGray.CGColor;
    [scrollView addSubview:jiedao];
    
    UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(0, jiedao.frame.origin.y+jiedao.frame.size.height+10, WIDTH, 1)];
    fg2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [scrollView addSubview:fg2];

    UILabel *label3 = [LHController createLabelWithFrame:CGRectMake(LEFT, jiedao.frame.origin.y+jiedao.frame.size.height+20, 90, 30) Font:B Bold:NO TextColor:[UIColor grayColor] Text:@"邮政编码:"];
    [scrollView addSubview:label3];
    postcode = [LHController createTextFieldWithFrame:CGRectMake(LEFT+90, jiedao.frame.origin.y+jiedao.frame.size.height+20, WIDTH-90-LEFT*2, 30) andBGImageName: @"textView.png" andPlaceholder:nil andTextFont:B andSmallImageName:nil andDelegate:self];
    [scrollView addSubview:postcode];
    postcode.layer.borderColor = colorLineGray.CGColor;
    postcode.layer.borderWidth = 1;
    postcode.keyboardType = UIKeyboardTypeNumberPad;
    
    UIButton *btn = [LHController createButtnFram:CGRectMake(LEFT, postcode.frame.origin.y+postcode.frame.size.height+30, WIDTH-LEFT*2, 35) Target:self Action:@selector(postClick) Font:B Text:@"保存"];
    [scrollView addSubview:btn];
    
    scrollView.contentSize = CGSizeMake(0, btn.frame.origin.y+btn.frame.size.height+30);
}

#pragma mark - 保存按钮响应方法
-(void)postClick{
    if (city.text.length == 0) {
        [self alert:@"请选择市区"];
        return;
    }
    
//    if (postcode.text.length > 0 && postcode.text.length != 6) {
//        [self alert:@"邮政编码应当是六位数字"];
//        return;
//    }
    [self getData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfield代理
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
   
    [_pickDataArray removeAllObjects];
    [_pickView reloadAllComponents];

    textFieldOfPickView = textField;
    if (textField == province) {
         _number = 1;
        [self loadDataOfPickView:1];
        [self showPickView:YES];
        [self.view endEditing:YES];
        return NO;
    }
    else if (textField == city){
         _number = 2;
        [self loadDataOfPickView:2];
        [self showPickView:YES];
        [self.view endEditing:YES];
        return NO;
    }
    else if (textField == area){
         _number = 3;
        [self loadDataOfPickView:3];
        [self showPickView:YES];
        [self.view endEditing:YES];
        return NO;
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self showPickView:NO];
    [self.view endEditing:YES];
    return YES;
}



#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
   // doneBt.hidden = YES;
    return YES;
}


#pragma  mark - 创建选择列表框pickView
-(void)createChangPickView{
    _pickViewOfView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 220)];
    _pickViewOfView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:_pickViewOfView];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"确定"];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1] forState:UIControlStateNormal];
    [_pickViewOfView addSubview:button];
    
    UIButton *qx = [LHController createButtnFram:CGRectMake(20, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"取消"];
    [qx setTitleColor:[UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1] forState:UIControlStateNormal];
    [_pickViewOfView addSubview:qx];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = [UIColor whiteColor];
    [_pickViewOfView addSubview:_pickView];
    
}


-(void)pickViewClick:(UIButton *)btn{
    
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
       
        textFieldOfPickView.text = pickViewSelectText;
        
        if (textFieldOfPickView == province) {
            
            city.text = @"";
            area.text = @"";
            cId = @"0";
            aId = @"0";
            cName = @"";
            aName = @"";
            pName = pickViewSelectText;
            pId = tempID;
            [self loadDataOfPickView:2];
        }else if (textFieldOfPickView == city){
            
            area.text = @"";
            aId = @"0";
            cId = tempID;
            aName = @"";
            cName = pickViewSelectText;
            [self loadDataOfPickView:3];
        }else if (textFieldOfPickView == area){
            aId = tempID;
            aName = pickViewSelectText;
        }
        pickViewSelectText = @"";
        tempID = @"";
    }
    [self showPickView:NO];
}

-(void)showPickView:(BOOL)yesORno{
    if (yesORno) {
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewOfView.frame = CGRectMake(0, HEIGHT-220, WIDTH, 220);
         
        }];
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewOfView.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
        }];
        
    }
}

#pragma mark - 列表框pickerViewDataSource代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickDataArray.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f,_pickView.frame.size.width,40.0f)];
    label.textAlignment = NSTextAlignmentCenter;

    NSDictionary  *dict = _pickDataArray[row];
    if (_number == 1) {
        label.text = dict[@"name"];
    }
    else if (_number == 2){
        label.text = dict[@"cityname"];
    }
    else if (_number == 3){
        label.text = dict[@"name"];
    }
    
    if (row == 0) {
        pickViewSelectText = label.text;
        if (_number == 1) {
            tempID = dict[@"id"];
        }else if (_number == 2){
            tempID = dict[@"cid"];
        }else if (_number == 3){
            tempID = dict[@"id"];
        }
        
    }
    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickDataArray.count > 0) {
         NSDictionary  *dict = _pickDataArray[row];
        if (_number == 1) {
            pickViewSelectText = dict[@"name"];
            tempID = dict[@"id"];
        }else if (_number == 2){
            pickViewSelectText = dict[@"cityname"];
            tempID = dict[@"cid"];
          
        }else if (_number == 3){
            pickViewSelectText = dict[@"name"];
            tempID = dict[@"id"];
        }
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

#pragma mark - 列表数据加载
-(void)loadDataOfPickView:(NSInteger )num{
    NSString *url;
    if (num == 1) {
        url = [URLFile urlStringForPro];
    }else if(num == 2){
        url = [NSString stringWithFormat:[URLFile urlStringForCity],pId];
    }else if (num == 3){
        url = [NSString stringWithFormat:[URLFile urlStringForArea],cId];
    }
    _number = num;

   [HttpRequest GET:url success:^(id responseObject) {
       if (num == 1 || num == 2) {
           [_pickDataArray setArray:responseObject[@"rel"]];
           [_pickView reloadAllComponents];
       }else{
           [_pickDataArray setArray:responseObject];
           [_pickView reloadAllComponents];
       }

   } failure:^(NSError *error) {
       
   }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
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
