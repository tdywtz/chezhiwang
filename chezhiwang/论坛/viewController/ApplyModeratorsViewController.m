//
//  ApplyModeratorsViewController.m
//  chezhiwang
//
//  Created by bangong on 15/10/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ApplyModeratorsViewController.h"
#import "ChooseSexViewController.h"

#define SPACE 50

@interface ApplyModeratorsViewController ()<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIScrollView *_scrollView;
    UILabel *userNameLabel;
    UITextField *realNameField;
    UITextField *sexTextField;
    UITextField *provinceField;
    UITextField *cityField;
    UITextField *countyField;
    UITextField *addressField;
    UITextField *applyForumField;
    UITextField *occupationField;//职业
    UITextField *mobileField;
    UITextField *QQField;
    UITextField *emailField;
    UITextField *carIDField;
    UITextField *brandField;
    UITextField *seriesField;
    UITextField *modelField;
    UITextView *reasonTextView;
    UILabel *textViewplaceholder;
    
    UIButton *manButton;
    UIButton *womenButton;
    
    CGFloat _sizeFont;
    CGFloat frame_y;//点击textfield的坐标
    
    UIView *_pickViewSuper;
    UIPickerView *_pickView;
    NSMutableArray *_pickDataArray;
    NSInteger _number;
    NSMutableArray *provinceArray;
    NSMutableArray *brandArray;
    NSString *tempId;
    NSString *tempName;
    UITextField *tempTextField;
    NSString *brandId;
    NSString *seriesId;
    NSString *modelId;
    NSString *provinceId;
    NSString *cityId;
    NSString *countyId;
}
@property (nonatomic,strong) NSMutableDictionary *dictionary;
@end

@implementation ApplyModeratorsViewController
#pragma mark - 下载用户数据
-(void)loadDataCar{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlString_getApplyOwner],[CZWManager manager].userID];
  [HttpRequest GET:url success:^(id responseObject) {
     
      [self setCar:responseObject];
  } failure:^(NSError *error) {
      
  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"申请当版主";
    self.view.backgroundColor = [UIColor whiteColor];
    _sizeFont = [LHController setFont];
   
    [self createArray];
  
    [self makeUI];
    [self createNotifacation];
    [self createChangPickView];
    [self loadDataOfPickView:1];
    [self loadDataOfPickView:4];
    [self loadDataCar];
}

-(void)createArray{
    _pickDataArray = [[NSMutableArray alloc] init];
    provinceArray = [[NSMutableArray alloc] init];
    brandArray = [[NSMutableArray alloc] init];
}


#pragma mark - 注册通知
-(void)createNotifacation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notifaction{
   
    CGFloat height = [[notifaction.userInfo objectForKeyedSubscript:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
     [self showPickView:NO];
    _scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-height-64);
    if (frame_y-_scrollView.contentOffset.y > HEIGHT-height) {
        _scrollView.contentOffset = CGPointMake(0, frame_y-HEIGHT+height+60);
    }
}

-(void)keyboardHide:(NSNotification *)notifaction{
    _scrollView.frame = self.view.frame;
}

-(void)makeUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_scrollView addGestureRecognizer:tap];

    CZWLabel *tishilabel = [[CZWLabel alloc] initWithFrame:CGRectZero];
    tishilabel.textInsets = UIEdgeInsetsMake(0, 13, 0, 0);
    tishilabel.font = [UIFont systemFontOfSize:13];
    tishilabel.textColor = colorLightGray;
    tishilabel.text = @"以下信息全是必填选项，请您认真填写以下内容";
    [tishilabel insertImage:[UIImage imageNamed:@"auto_common_提示"] frame:CGRectMake(0, -7, 20, 20) index:0];
    tishilabel.backgroundColor = RGB_color(240, 240, 240, 1);
    [_scrollView addSubview:tishilabel];

    [tishilabel sizeToFit];
    tishilabel.lh_left = 0;
    tishilabel.lh_top = 0;
    tishilabel.lh_height += 20;
    tishilabel.lh_width = WIDTH;

   

    NSArray *array = @[@"用户名：",@"真实姓名：",@"性别：",@"所在地区：",@"街道地址：",@"申请论坛：",@"职业：",@"手机：",@"QQ：",@"电子邮箱：",@"身份证号码：",@"爱车：",@"申请理由："];
     NSArray *placeholderArray = @[@"用户名",@"请输入真实姓名",@"性别",@"所在地区",@"请输入街道地址",@"申请论坛",@"请输入您的职业",@"请输入您的手机号码",@"请输入您的QQ",@"请输入电子邮箱",@"请输入身份证号码",@"爱车",@"请输入申请理由"];
    CGFloat frameY = tishilabel.lh_bottom+1;
    
    for (int i = 0; i < array.count; i ++) {
        CGFloat width = [self getStr:array[i] andFont:_sizeFont];

        UILabel *nameLabel = [LHController createLabelWithFrame:CGRectMake(15, frameY+SPACE*i+1, width, SPACE) Font:_sizeFont Bold:NO TextColor:colorBlack Text:array[i]];
        [_scrollView addSubview:nameLabel];
       
        UIView *fgView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.lh_bottom, WIDTH, 1)];
        fgView.backgroundColor = colorLineGray;
        [_scrollView addSubview:fgView];
        
        if (i > 3) {
            nameLabel.lh_top = nameLabel.frame.origin.y+SPACE*3+3;
            fgView.lh_top =  nameLabel.lh_bottom;
        }
        if (i > 11) {
            nameLabel.lh_top =  nameLabel.frame.origin.y+SPACE*3+3;
            fgView.lh_top = nameLabel.lh_bottom;
        }
        
        if (i == 0) {
            userNameLabel = [LHController createLabelWithFrame:CGRectMake(nameLabel.lh_right, nameLabel.lh_top, WIDTH-20, SPACE) Font:_sizeFont Bold:NO TextColor:colorDeepGray Text:nil];
            [_scrollView addSubview:userNameLabel];
        }else if (i == 3){
            NSArray *areaArray = @[@"省份",@"地级市",@"市、县级市、县"];
            for (int k = 0; k < 3; k ++) {
                UITextField  *field = [LHController createTextFieldWithFrame:CGRectMake(nameLabel.lh_left+10, nameLabel.lh_bottom+SPACE*k+1, WIDTH-nameLabel.lh_left-20, SPACE) Placeholder:areaArray[k] Font:_sizeFont  Delegate:self];
                field.rightViewMode = UITextFieldViewModeAlways;
                field.rightView = [self textFieldRightView];
                [_scrollView addSubview:field];
                UIView *bgbg = [[UIView alloc] initWithFrame:CGRectMake(20, field.lh_bottom, WIDTH-20, 1)];
                bgbg.backgroundColor = colorLineGray;
                [_scrollView addSubview:bgbg];
                
                if      (k == 0) provinceField = field;
                else if (k == 1) cityField     = field;
                else             countyField   = field;
            }
        }else if (i == 11){

            NSArray *areaArray = @[@"===请选择品牌===",@"===请选择车系===",@"===请选择车型==="];
            for (int k = 0; k < 3; k ++) {
                UITextField  *field = [LHController createTextFieldWithFrame:CGRectMake(nameLabel.lh_left+10, nameLabel.lh_bottom+SPACE*k+1, WIDTH-nameLabel.lh_left-20, SPACE) Placeholder:areaArray[k] Font:_sizeFont  Delegate:self];
                field.rightViewMode = UITextFieldViewModeAlways;
                field.rightView = [self textFieldRightView];
                [_scrollView addSubview:field];
                UIView *bgbg  =[[ UIView alloc] initWithFrame:CGRectMake(20, field.lh_bottom, WIDTH-20, 1)];
                bgbg.backgroundColor = colorLineGray;
                [_scrollView addSubview:bgbg];
                
                if      (k == 0) brandField  = field;
                else if (k == 1) seriesField = field;
                else             modelField = field;
            }

        }else if (i == 12){
          
            reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, nameLabel.lh_bottom+1, WIDTH-30, 100)];
            reasonTextView.delegate = self;
            reasonTextView.font = [UIFont systemFontOfSize:_sizeFont-2];
            [_scrollView addSubview:reasonTextView];
           
            textViewplaceholder = [LHController createLabelWithFrame:CGRectMake(3, 7, 120, 20) Font:_sizeFont-2 Bold:NO TextColor:colorLineGray Text:@"请输入申请理由"];
            [reasonTextView addSubview:textViewplaceholder];
            
            UIView *bgbg = [[UIView alloc] initWithFrame:CGRectMake(0, reasonTextView.frame.origin.y+reasonTextView.frame.size.height, WIDTH, 1)];
            bgbg.backgroundColor = colorLineGray;
            [_scrollView addSubview:bgbg];
            
            //版主申请按钮
            UIButton *button = [LHController createButtnFram:CGRectMake(10, bgbg.frame.origin.y+20, WIDTH-20, 40) Target:self Action:@selector(buttonClick) Font:_sizeFont Text:@"申请版主"];
            [_scrollView addSubview:button];
            
             _scrollView.contentSize = CGSizeMake(0, button.frame.origin.y+80);
        }else{
            UITextField  *field = [LHController createTextFieldWithFrame:CGRectMake(nameLabel.lh_right, nameLabel.lh_top, WIDTH-nameLabel.lh_right-10, SPACE) Placeholder:nil Font:_sizeFont Delegate:self];
            [_scrollView addSubview:field];
            [self fuzhi:field and:i];
            field.placeholder = placeholderArray[i];
        }
    }
}

- (UIView *)textFieldRightView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    return imageView;
}
//手势
-(void)tap:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

-(void)fuzhi:(UITextField *)textField and:(NSInteger)num{
  
    //[textField setInputAccessoryView:[self createToorBar]];
    
    switch (num) {
        case 1:
            realNameField = textField;
            break;

        case 2:{
            sexTextField = textField;
            sexTextField.rightViewMode = UITextFieldViewModeAlways;
            sexTextField.rightView = [self textFieldRightView];
            break;
        }

        case 4:
            addressField = textField;
            break;
            
        case 5:
            applyForumField = textField;
            break;
            
        case 6:
            occupationField = textField;
            break;
            
        case 7:
            mobileField = textField;
            mobileField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        case 8:
            QQField = textField;
            break;
            
        case 9:
            emailField = textField;
            break;
            
        case 10:
            carIDField = textField;
            carIDField.keyboardType = UIKeyboardTypeNumberPad;
            break;
            
        default:
            break;
    }
}

#pragma mark - 计算字符串长度
-(CGFloat)getStr:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - 男女选项
-(void)createSexButton:(CGFloat)y andX:(CGFloat)x{
    manButton = [LHController createButtnFram:CGRectMake(x, y, SPACE, SPACE) Target:self Action:@selector(manClick)];
    manButton.selected = YES;
    [_scrollView addSubview:manButton];
    
    UILabel *manLabel = [LHController createLabelWithFrame:CGRectMake(manButton.frame.origin.x+manButton.frame.size.width+5, y, SPACE, SPACE) Font:_sizeFont-2 Bold:NO TextColor:nil Text:@"男"];
    [_scrollView addSubview:manLabel];
    
    womenButton = [LHController createButtnFram:CGRectMake(manLabel.frame.size.width+manLabel.frame.origin.x, y, SPACE, SPACE) Target:self Action:@selector(womenClick)];
    [_scrollView addSubview:womenButton];
    
    UILabel *womenLabel = [LHController createLabelWithFrame:CGRectMake(womenButton.frame.origin.x+womenButton.frame.size.width+5, y, SPACE, SPACE) Font:_sizeFont-2 Bold:NO TextColor:nil Text:@"女"];
    [_scrollView addSubview:womenLabel];
    
    manButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    womenButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
}

-(void)manClick{
    manButton.selected = YES;
    womenButton.selected = NO;
}

-(void)womenClick{
    manButton.selected = NO;
    womenButton.selected = YES;
}


#pragma mark - 初始化数据
-(void)setCar:(NSDictionary *)dict{
   
   // NSLog(@"%@",dict);
    userNameLabel.text = dict[@"username"];
    realNameField.text = dict[@"realname"];
    if ([dict[@"sex"] integerValue] == 2) {
        sexTextField.text = @"男";
    }else{
        sexTextField.text = @"女";
    }
    provinceField.text = dict[@"sheng"];
    provinceId = dict[@"pid"];
    cityField.text =  dict[@"shi"];
    cityId = dict[@"cid"];
    countyField.text = dict[@"qu"];
    countyId = dict[@"aid"];
   
    addressField.text = dict[@"address"];
    applyForumField.text = self.dict[@"fname"];//dict[@"lovesname"];
   
    occupationField.text = dict[@"profession"];
    mobileField.text = dict[@"mobile"];
    QQField.text = dict[@"qq"];
    emailField.text = dict[@"email"];
    carIDField.text = dict[@"idnumber"];
    brandField.text = dict[@"lovebname"];
    brandId = dict[@"lovebid"];
    seriesField.text = dict[@"lovesname"];
    seriesId = dict[@"lovesid"];
    modelField.text = dict[@"lovemname"];
    modelId = dict[@"lovemid"];
}

#pragma mark - 提交申请按钮
-(void)buttonClick{
    if (![LHController judegmentSpaceChar:realNameField.text]) {
        [LHController alert:@"真实姓名不能为空"];
    }else if (![LHController judegmentSpaceChar:countyField.text]){
        [LHController alert:@"所在地区没选择完全"];
    }else if (![LHController judegmentSpaceChar:addressField.text]){
        [LHController alert:@"街道地址不能为空"];
    }else if (![LHController judegmentSpaceChar:occupationField.text]){
        [LHController alert:@"职业不能为空"];
    }
    else if (![LHController judegmentSpaceChar:mobileField.text]){
        [LHController alert:@"手机号码不能为空"];
    }else if (![LHController judegmentSpaceChar:QQField.text]){
        [LHController alert:@"QQ号不能为空"];
    }else if (![LHController judegmentSpaceChar:carIDField.text]){
        [LHController alert:@"身份证号不能为空"];
    }else if ([LHController judegmentSpaceChar:reasonTextView.text] == NO){
        [LHController alert:@"申请理由不能为空"];
    }
    else{
        [self createData];
    }
}


-(void)createData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[CZWManager manager].userID forKey:@"uid"];
    [dict setObject:[CZWManager manager].userName forKey:@"username"];
    [dict setObject:realNameField.text forKey:@"realname"];
    if ([sexTextField.text isEqualToString:@"男"]) {
        [dict setObject:@"1" forKey:@"sex"];
    }else{
        [dict setObject:@"2" forKey:@"sex"];
    }
    [dict setObject:provinceField.text forKey:@"sheng"];
    [dict setObject:cityField.text forKey:@"shi"];
    [dict setObject:countyField.text forKey:@"qu"];
    
    [dict setObject:addressField.text forKey:@"address"];
    [dict setObject:self.dict[@"bname"] forKey:@"applybname"];
    [dict setObject:self.dict[@"bid"] forKey:@"applybid"];
    [dict setObject:self.dict[@"sname"] forKey:@"applysname"];
    [dict setObject:self.dict[@"sid"] forKey:@"applysid"];
    
    [dict setObject:occupationField.text forKey:@"profession"];
    [dict setObject:mobileField.text forKey:@"mobile"];
    [dict setObject:QQField.text forKey:@"qq"];
    [dict setObject:emailField.text forKey:@"email"];
    [dict setObject:carIDField.text forKey:@"idnumber"];
  
    [dict setObject:brandField.text forKey:@"lovebname"];
    [dict setObject:brandId forKey:@"lovebid"];
    [dict setObject:seriesField.text forKey:@"lovesname"];
    [dict setObject:seriesId forKey:@"lovesid"];
    [dict setObject:modelField.text forKey:@"lovemname"];
    [dict setObject:modelId forKey:@"lovemid"];
    
    [dict setObject:reasonTextView.text forKey:@"applyreason"];
    [self postData:dict];
}

#pragma mark - 提交申请
-(void)postData:(NSDictionary *)dict{

  [HttpRequest POST:[URLFile urlStringForApplyOwner] parameters:dict success:^(id responseObject) {
      if (responseObject[@"error"]) {
          [LHController alert:responseObject[@"error"]];
      }else{
           [LHController alert:responseObject[@"success"]];
          [self.navigationController popViewControllerAnimated:YES];
      }

  } failure:^(NSError *error) {
      
  }];
}


#pragma  mark - 创建选择列表框pickView
-(void)createChangPickView{
    _pickViewSuper = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 220)];
    _pickViewSuper.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:_pickViewSuper];
    
    UIButton *button = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"确定"];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1] forState:UIControlStateNormal];
    [_pickViewSuper addSubview:button];
    
    UIButton *qx = [LHController createButtnFram:CGRectMake(20, 10, 40, 20) Target:self Action:@selector(pickViewClick:) Text:@"取消"];
    [qx setTitleColor:[UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1] forState:UIControlStateNormal];
    [_pickViewSuper addSubview:qx];
    
    _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    _pickView.backgroundColor = [UIColor whiteColor];
    [_pickViewSuper addSubview:_pickView];
}


-(void)pickViewClick:(UIButton *)btn{
    
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {
        if (_number == 1) {
            provinceId = tempId;
            provinceField.text = tempName;
            cityId = cityField.text = countyId = countyField.text = @"";
            
        }else if (_number == 2){
            cityId = tempId;
            cityField.text = tempName;
            countyId = countyField.text = @"";
        }else if (_number == 3){
            countyId = tempId;
            countyField.text = tempName;
        }else if (_number == 4){
            brandId = tempId;
            brandField.text = tempName;
            seriesId = seriesField.text = modelId = modelField.text = @"";
        }else if (_number == 5){
            seriesId = tempId;
            seriesField.text = tempName;
            modelId = modelField.text = @"";
        }else if (_number == 6){
            modelId = tempId;
            modelField.text = tempName;
        }
    }
    [self showPickView:NO];
}

-(void)showPickView:(BOOL)yesORno{
    if (yesORno) {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewSuper.frame = CGRectMake(0, HEIGHT-64-220, WIDTH, 220);
            if (frame_y-_scrollView.contentOffset.y > HEIGHT-220-64) {
                _scrollView.contentOffset = CGPointMake(0, frame_y-HEIGHT+220+64+60);
            }
            _scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-200-64);
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewSuper.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
            _scrollView.frame = self.view.frame;
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
    
    label.text = _pickDataArray[row][@"name"];
    if (row == 0) {
        tempId = _pickDataArray[row][@"id"];
        tempName = _pickDataArray[row][@"name"];
    }
    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    tempId = _pickDataArray[row][@"id"];
    tempName = _pickDataArray[row][@"name"];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

#pragma mark - 品牌、车系、车系数据下载
-(void)loadDataOfPickView:(NSInteger )num{
    NSString *url;
    if (num == 1) {
        url = [URLFile urlStringForPro];
    }else if (num == 2) {
        url = [NSString stringWithFormat:[URLFile urlStringForCity],provinceId];
    }else if (num == 3){
        url = [NSString stringWithFormat:[URLFile urlStringForArea],cityId];
    }else if (num == 4) {
        url = [URLFile urlStringForLetter];
    }else if(num == 5){
        url = [NSString stringWithFormat:[URLFile urlStringForSeries],brandId];
    }else if (num == 6){
        url = [NSString stringWithFormat:[URLFile urlStringForModelList],seriesId];
    }

  
    [HttpRequest GET:url success:^(id responseObject) {

        if (num == 1) {
            for (NSDictionary *dict in responseObject[@"rel"]) {
                [provinceArray addObject:@{@"id":dict[@"id"],@"name":dict[@"name"]}];
            }
            [_pickDataArray setArray:provinceArray];
            
        }else if (num == 2){
            for (NSDictionary *dict in responseObject[@"rel"]) {
                [_pickDataArray addObject:@{@"id":dict[@"cid"],@"name":dict[@"cityname"]}];
            }
        }
        else if (num == 3){
            for (NSDictionary *dict in responseObject[@"rel"]) {
                [_pickDataArray addObject:@{@"id":dict[@"id"],@"name":dict[@"name"]}];
            }
        }
        else if (num == 4){
            for (NSDictionary *dict in responseObject[@"rel"]) {
                for (NSDictionary *subDic in dict[@"brand"]) {
                    [brandArray addObject:@{@"id":subDic[@"id"],@"name":subDic[@"name"]}];
                }
            }
            [_pickDataArray setArray:brandArray];
        }else if (num == 5){
            for (NSDictionary *dict in responseObject[@"rel"]) {
                for (NSDictionary *subDic in dict[@"series"]) {
                    [_pickDataArray addObject:@{@"id":subDic[@"seriesid"],@"name":subDic[@"seriesname"]}];
                }
            }
        }else if (num == 6){
       
            for (NSDictionary *dict in responseObject[@"rel"]) {
                [_pickDataArray addObject:@{@"id":[NSString stringWithFormat:@"%@",dict[@"mid"]],@"name":dict[@"modelname"]}];
            }
        }
        [_pickView reloadAllComponents];

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    frame_y = textField.frame.origin.y+textField.frame.size.height;

    if (textField == sexTextField) {
        [self.view endEditing:YES];
        NSDictionary *dict1 = @{@"title":@"男",@"id":@"1"};
        NSDictionary *dict2 = @{@"title":@"女",@"id":@"2"};
        NSArray *array = @[dict1,dict2];
        ChooseSexViewController *picker = [[ChooseSexViewController alloc] init];
        picker.dataArray = array;
        picker.titleText = @"性别";
        [picker showPickerView];

        [picker returnResult:^(NSString *title, NSString *ID) {
            sexTextField.text = title;
        }];
        [self presentViewController:picker animated:YES completion:nil];
        return  NO;
    }
    tempTextField = textField;
    tempId = @"";
    tempName = @"";
    [_pickDataArray removeAllObjects];
    [_pickView reloadAllComponents];
    
    if (textField == provinceField) {
        _number = 1;
        if (provinceArray.count == 0) {
            [self loadDataOfPickView:1];
        }else{
            [_pickDataArray setArray:provinceArray];
            [_pickView reloadAllComponents];
        }
        [self showPickView:YES];
        return NO;
    }else if (textField == cityField){
         _number = 2;
        [self loadDataOfPickView:2];
        [self showPickView:YES];
        return NO;
    }else if (textField == countyField){
         _number = 3;
        [self loadDataOfPickView:3];
        [self showPickView:YES];
        return NO;
    }else if (textField == brandField){
         _number = 4;
        if (brandArray.count == 0) {
            [self loadDataOfPickView:4];
        }else{
            [_pickDataArray setArray:brandArray];
            [_pickView reloadAllComponents];
        }
        [self showPickView:YES];
        return NO;
    }else if (textField == seriesField){
         _number = 5;
        [self loadDataOfPickView:5];
        [self showPickView:YES];
        return NO;
    }else if (textField == modelField){
         _number = 6;
        [self loadDataOfPickView:6];
        [self showPickView:YES];
        return NO;
    }
    
    if (textField == applyForumField) {
        return NO;
    }
    
    if (textField == applyForumField) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length == 0) {
        textViewplaceholder.hidden = NO;
    }else{
        textViewplaceholder.hidden = YES;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    frame_y = textView.frame.origin.y+textView.frame.size.height+50;
    return YES;
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
