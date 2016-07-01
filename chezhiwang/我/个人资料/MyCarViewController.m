//
//  MyCarViewController.m
//  auto
//
//  Created by bangong on 15/7/23.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyCarCell.h"
#import "AreaViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tabelView;
    UIView *bgView;
    UIView *bgSmallView;
    UIImagePickerController *myPicker;
    UITextField *brandName;
    UITextField *seriesName;
    UITextField *modelName;
    NSString *brandId;
    NSString *seriesId;
    NSString *modelId;
    NSMutableDictionary *dicData;//修改数据
    UIView *DatePickView;//时间选择
    UIDatePicker *datePicker;
    
    UITextField *textFieldOfPickView;
    UIView *_pickViewOfView;
    UIPickerView *_pickView;
    NSMutableArray *_pickDataArray;
    NSInteger _number;
    NSString *tempID;
    NSString *pickViewSelectText;
    NSMutableArray *_brandArray;
    NSMutableArray *_seriesArray;
    NSMutableArray *_modelArray;
  //  UITextField *firstResponderTextField;
   // UIButton *doneBt;//数字键盘return
    
    CGPoint _point;
    CGFloat height;
    CGFloat B;
    
    UIView *logoutBGView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITextField *cellTextField;
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) UITableViewCell *cell;
@property (nonatomic,strong) MyCarCell *myCell;
@property (nonatomic,assign) NSInteger *num;
@property (nonatomic,strong) NSString *rname;
@end


@implementation MyCarViewController
- (void)dealloc
{
    [bgView removeFromSuperview];
    [logoutBGView removeFromSuperview];
    [bgSmallView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 下载用户数据
-(void)loadCar{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUser],[[NSUserDefaults standardUserDefaults] objectForKey:user_id]];
  [HttpRequest GET:url success:^(id responseObject) {
      if (responseObject) {
          [dicData setDictionary:responseObject];
          [self createData:dicData];
          
          [_tabelView reloadData];
          //加载大品牌数据
          [self loadDataOfPickView:1];
      }

  } failure:^(NSError *error) {
      
  }];
}

-(void)createData:(NSDictionary *)dict{
    
    [self.dataArray removeAllObjects];
    self.rname = dict[@"rname"];
    NSArray *rightArray = @[@"img",@"uname",@"rname",@"sex",@"birth",@"email",@"mobile",@"phone",@"qq"];
    NSArray *leftArray = @[@"头像",@"用户名",@"真实姓名",@"性别",@"生日",@"电子邮箱",@"手机",@"固定电话",@"QQ"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
   
    for (int i = 0; i < rightArray.count; i ++) {
        NSDictionary *dic = @{@"left":leftArray[i],@"right":dict[rightArray[i]],@"key":rightArray[i]};
        [array addObject:dic];
        //[dicData setObject:dict[rightArray[i]] forKey:leftArray[i]];
    }
    [self.dataArray addObject:array];
    
    NSDictionary *dictionary = @{@"brandName":dict[@"brandName"],@"brand":dict[@"brand"],
                                 @"seriesName":dict[@"seriesName"],@"series":dict[@"series"],
                                 @"modelName":dict[@"modelName"],@"model":dict[@"model"]};
    [self.dataArray addObject:@[dictionary]];
    [self.dataArray addObject:@[@"地区设置"]];
    [self.dataArray addObject:@[@"保存"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人信息";
    self.dataArray = [[NSMutableArray alloc] init];
    dicData = [[NSMutableDictionary alloc] init];
    _brandArray = [[NSMutableArray alloc] init];
    _seriesArray = [[NSMutableArray alloc] init];
    _modelArray = [[NSMutableArray alloc] init];
    _pickDataArray = [[NSMutableArray alloc] init];
    
    B = [LHController setFont];
   
    

    [self createTableView];
    NSDictionary *dict = @{@"img":@"",@"uname":@"",@"rname":@"",@"sex":@"",@"birth":@"",@"email":@"",@"mobile":@"",@"phone":@"",@"qq":@"",@"brandName":@"",@"brand":@"",@"seriesName":@"",@"series":@"",@"modelName":@"",@"model":@""};
    [dicData setDictionary:dict];
    [self createData:dicData];
    [_tabelView reloadData];
    
    [self loadCar];
    [self createNotification];
    [self createChangPickView];
}

#pragma mark - 通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
    height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    _tabelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-height);
}

-(void)keyboardHide:(NSNotification *)notification
{
    [self longFrame:YES FloatY:0];
    //doneBt.hidden = YES;
}

#pragma mark - item
-(void)createTableView{
    _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.tableFooterView = [UIView new];
    [self.view addSubview:_tabelView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 更改tabelView的frame
-(void)longFrame:(BOOL)yes FloatY:(CGFloat)y{
    if (yes) {
        [UIView animateWithDuration:0.3 animations:^{
            _tabelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
            //_tabelView.contentOffset = CGPointMake(0, y);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
           _tabelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-200);
            _tabelView.contentOffset = CGPointMake(0, y);
        }];
    }
}

#pragma mark - UItableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        MyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            cell = [[MyCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        }
        cell.num = indexPath.row;
        cell.dictCar = self.dataArray[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [cell getStr:^(NSString *key, NSString *right) {
            [self upDataCarValue:right Key:key];
        }];
        
        [cell getCell:^(MyCarCell *myCell,UITextField *cellTextField,NSInteger num) {
            self.cellTextField = cellTextField;
            if (cellTextField.keyboardType == UIKeyboardTypeNumberPad) {
//                if (doneBt == nil) {
//                    [self keyboardDidShow:nil];
//                }
              //  doneBt.hidden = NO;
            }else{
    
               // doneBt.hidden = YES;
            }
            CGFloat f =  80+num*40-(HEIGHT-64-240);
            if (f > 0) {
                [self longFrame:NO FloatY:f];
            }
            
            if (num == 4) {
                self.myCell = myCell;
                [self dateChange];
                [self.view endEditing:YES];
            }else{
                [self datePickerShow:NO];
                [self showPickView:NO];
            }
        }];
        
        [cell getIconImageView:^(UIImageView *imageView) {
            self.iconImageView = imageView;
            [self imageClick];
        }];
        
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        [self createAiChe:cell andDict:self.dataArray[indexPath.section][indexPath.row]];
        self.cell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"btn"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"btn"];
        }
        for (UIView *viv in cell.contentView.subviews) {
            [viv removeFromSuperview];
        }
        cell.textLabel.text = @"地区设置";
        cell.textLabel.font = [UIFont systemFontOfSize:B];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"button"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"button"];
    }
    for (UIView *viv in cell.contentView.subviews) {
        [viv removeFromSuperview];
    }

    UIButton *button = [LHController createButtnFram:CGRectMake(LEFT, 10, WIDTH-LEFT*2, 35) Target:self Action:@selector(postCarClick:) Font:B Text:@"保存"];
    [cell.contentView addSubview:button];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 提交用户信息
-(void)postCarClick:(UIButton *)btn{
 
    if([LHController judegmentSpaceChar:dicData[@"rname"]] == NO){
        [self alert:@"真实姓名不能为空"];
        return;
    }
    if (![LHController emailTest:dicData[@"email"]] && [dicData[@"email"] length] > 0) {
        [self alert:@"邮箱格式不正确"];
        return;
    }
    if ([dicData[@"mobile"] length] == 0) {
        [self alert:@"手机号码不能为空"];
        return;
    }else if ([dicData[@"mobile"] length] != 11) {
        [self alert:@"手机号应为11位数字"];
        return;
    }
    
    if ([dicData[@"phone"] length] > 0) {
        NSArray *array = [dicData[@"phone"] componentsSeparatedByString:@"-"];
        if (array.count != 2) {
            [self alert:@"固定电话号码格式应为(区号-电话号)"];
            return;
        }else{
            
            for (int i = 0; i < array.count; i ++) {
                NSString *str = array[i];
                for (int j = 0; j < str.length; j ++) {
                    unichar ch = [str characterAtIndex:j];
                    if (!isdigit(ch)) {
                        [self alert:@"电话号码只能为数字"];
                        return;
                    }
                }
            }
        }
    }
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForpersonalInfo],[[NSUserDefaults standardUserDefaults] objectForKey:user_id],dicData[@"rname"],dicData[@"sex"],dicData[@"birth"],dicData[@"email"],dicData[@"mobile"],dicData[@"qq"],dicData[@"phone"],brandId,brandName.text,seriesId,seriesName.text,modelId,modelName.text];
  [HttpRequest GET:url success:^(id responseObject) {
        [self alert:@"保存成功"];
  } failure:^(NSError *error) {
       [self alert:@"保存失败"];
  }];
}

#pragma mark - 爱车选择
-(void)createAiChe:(UITableViewCell *)cell andDict:(NSDictionary *)dict{
    for (UIView *viv in cell.contentView.subviews) {
        [viv removeFromSuperview];
    }
    
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(15, 15, 60, 25) Font:B  Bold:NO TextColor:nil Text:@"爱车"];
    [cell.contentView addSubview:label];
    
       NSArray *arr = @[@"品牌:",@"车系:",@"车型:"];
    for (int i = 0; i < arr.count; i ++) {
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(30 , i*35+45, 50, 30) Font:B-3 Bold:NO TextColor:[UIColor blackColor] Text:arr[i]];
        [cell.contentView addSubview:label];
        
        UITextField *textfield = [LHController createTextFieldWithFrame:CGRectMake(80, label.frame.origin.y, WIDTH-80-20, 30) andBGImageName:@"textView.png" andPlaceholder:@"" andTextFont:B-1 andSmallImageName:@"xuanze.png" andDelegate:self];
        [cell.contentView addSubview:textfield];
        textfield.returnKeyType = UIReturnKeyDone;
        if (i == 0){
            brandName = textfield;
            brandName.text = dict[@"brandName"];
            brandId = dict[@"brand"];
        }
        if (i == 1){
            seriesName = textfield;
            seriesName.text = dict[@"seriesName"];
            seriesId = dict[@"series"];
        }
        if (i == 2){
            modelName = textfield;
            modelName.text = dict[@"modelName"];
            modelId = dict[@"model"];
        }
    }
}

#pragma mark - UItableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) return 160;
    if (indexPath.section == 2) return 40;
    if (indexPath.section == 3) return 55;
    
    if (indexPath.row == 0) return 86;
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [self.view endEditing:YES];
    if (indexPath.section == 1 || indexPath.section == 3) {
        return;
    }
    else if (indexPath.section == 2) {
        AreaViewController *area = [[AreaViewController alloc] init];
        area.name = self.rname;
        [self.navigationController pushViewController:area animated:YES];
    }
    else{
        if (indexPath.row == 0) {
            [self imageClick];
        }
        if (indexPath.row == 4){
            [self dateChange];
        }
    }
}

#pragma mark - 选择上传图片方法
-(void)imageClick{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄",@"从相册选择", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
    [self.view endEditing:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (myPicker == nil) {
         myPicker = [[UIImagePickerController alloc] init];
         myPicker.navigationBar.tintColor = [UIColor whiteColor];
         myPicker.delegate = self;
         myPicker.allowsEditing = YES;
    }
    
    if (buttonIndex == 0) {

        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:myPicker animated:YES completion:nil];
        }
    }else if(buttonIndex == 1){
        myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:myPicker animated:YES completion:NULL];
    }
}

#pragma mark - 导航条代理
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (navigationController == myPicker) {
        myPicker.navigationBar.barStyle = UIBarStyleBlack;
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn.frame = CGRectMake(0, 0, 40, 20);
//        [btn setTitle:@"取消" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(pickerItemClick:) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        
//        if (navigationController.viewControllers.count > 1) {
//            viewController.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(pickerItemClick:)];
//        }
//        if (navigationController.viewControllers.count == 3) {
//            UIViewController *vc = navigationController.viewControllers[2];
//            UIView *viv = vc.view.subviews[0];
//            viv.frame = CGRectMake(0, 0, WIDTH, HEIGHT-20);
//        }
    }
}

//-(void)pickerItemClick:(UIButton *)btn{
//    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
//        [myPicker dismissViewControllerAnimated:YES completion:nil];
//    }else{
//        [myPicker popViewControllerAnimated:YES];
//    }
//    
//}
//

#pragma mark - UITextFieldDelegate
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self.view endEditing:YES];
//    return YES;
//}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textFieldOfPickView = textField;
    [_pickDataArray removeAllObjects];
    [_pickView reloadAllComponents];
    pickViewSelectText = @"";
    if (textField == brandName) {
        _number = 1;
        if (_brandArray.count > 0) {
            [_pickDataArray setArray:_brandArray];
            [_pickView reloadAllComponents];
        }else{
            [self loadDataOfPickView:1];
        }
    }else if(textField == seriesName){
        _number = 2;
        if (_seriesArray.count > 0) {
            [_pickDataArray setArray:_seriesArray];
            [_pickView reloadAllComponents];
        }else{
            [self loadDataOfPickView:2];
        }

    }else if (textField == modelName){
        _number = 3;
        if (_modelArray.count > 0) {
            [_pickDataArray setArray:_modelArray];
            [_pickView reloadAllComponents];
        }else{
            [self loadDataOfPickView:3];
        }
    }
    [self showPickView:YES];
    return NO;
}


#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self postImage:image];
    [myPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 时间选择
-(void)dateChange{
    if (!DatePickView) {
        
        DatePickView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 220)];
        DatePickView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:DatePickView];
        
        UIView *fg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        fg1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        [DatePickView addSubview:fg1];
        
        UIView *fg2 = [[UIView alloc] initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
        fg2.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0  blue:245/255.0  alpha:1];
        [DatePickView addSubview:fg2];
        
        UIButton *quxiao = [LHController createButtnFram:CGRectMake(WIDTH-60, 10, 40, 20) Target:self Action:@selector(datePickerClick:) Text:@"完成"];
        [quxiao setTitleColor:[UIColor colorWithRed:0/255.0 green:126/255.0 blue:184/255.0 alpha:1] forState:UIControlStateNormal];
        [DatePickView addSubview:quxiao];
        
        datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 180)];
        datePicker.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        //设置时间模式
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        [datePicker setLocale:locale];
        //最大时间
        datePicker.maximumDate = [NSDate date];
        //设置最小时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        //日期转化
        NSDate *minDate = [formatter dateFromString:@"1919-01-01"];
        
        datePicker.minimumDate =  minDate;
        //添加事件
        [datePicker addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventValueChanged];
        
        datePicker.backgroundColor = [UIColor whiteColor];
        //设置加载在界面
        [DatePickView addSubview:datePicker];
    }
    [self datePickerShow:YES];
}

-(void)dateClick
{
    //转换
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    NSString *str = [formatter stringFromDate:datePicker.date];
    //刷新日期
    self.cellTextField.text = str;
    [self upDataCarValue:str Key:@"birth"];
}

-(void)datePickerClick:(UIButton *)btn{
    [self datePickerShow:NO];
}

#pragma mark - 显示、隐藏时间选择器
-(void)datePickerShow:(BOOL)hide{
    if (hide) {
        [UIView animateWithDuration:0.3 animations:^{
            DatePickView.frame = CGRectMake(0, HEIGHT-64-220, WIDTH, 220);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            DatePickView.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
        }];
        self.myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self longFrame:YES FloatY:0];
    }
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
        if (pickViewSelectText) {
            textFieldOfPickView.text = pickViewSelectText;
        }
        [_pickDataArray removeAllObjects];
        [_pickView reloadAllComponents];
        pickViewSelectText = @"";
        if (textFieldOfPickView == brandName) {
            
            seriesName.text = @"";
            modelName.text = @"";
            seriesId = @"0";
            modelId = @"0";
            brandId = tempID;
            [_seriesArray removeAllObjects];
            [_modelArray removeAllObjects];
            [self loadDataOfPickView:2];
            [self upDataCarValue:brandName.text Key:@"brandName"];
            [self upDataCarValue:@"" Key:@"seriesName"];
            [self upDataCarValue:@"" Key:@"modelName"];
        }else if (textFieldOfPickView == seriesName){
            
            modelName.text = @"";
            modelId = @"0";
            seriesId = tempID;
            [_modelArray removeAllObjects];
            [self loadDataOfPickView:3];
            [self upDataCarValue:seriesName.text Key:@"seriesName"];
            [self upDataCarValue:@"" Key:@"modelName"];
        }else if (textFieldOfPickView == modelName){
            modelId = tempID;
            [self upDataCarValue:modelName.text Key:@"modelName"];
        }
    }
    [self showPickView:NO];
}

-(void)showPickView:(BOOL)yesORno{
    if (yesORno) {
        [self.cellTextField endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewOfView.frame = CGRectMake(0, HEIGHT-64-220, WIDTH, 220);
            _tabelView.contentOffset = CGPointMake(_point.x, 45*10-HEIGHT+286+160);
            _tabelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-200-64);
           
        }];
//        double delayInSeconds = 0.3;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        _tabelView.contentOffset = CGPointMake(_point.x, 45*10-HEIGHT+286+160); });
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _pickViewOfView.frame = CGRectMake(0, HEIGHT, WIDTH, 220);
           // _tabelView.contentOffset = CGPointMake(0, 0);
            _tabelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
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
    if (_number == 1 || _number == 2) {
        NSDictionary *dict = _pickDataArray[row];
        label.text = dict[@"name"];
        if (row == 0) {
            tempID = dict[@"id"];
        }
    }else if (_number == 3){
        NSDictionary *dict = _pickDataArray[row];
        label.text = [NSString stringWithFormat:@"%@款  %@",dict[@"Model_Belongsyear"],dict[@"Model_Name"]];
        if (row == 0) {
            tempID = dict[@"Id"];
        }
    }
    if (row == 0) {
        pickViewSelectText = label.text;
    }
    return label;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (_number == 1 || _number == 2) {
        NSDictionary  *dict = _pickDataArray[row];
        pickViewSelectText = dict[@"name"];
        tempID = dict[@"id"];
    }else if (_number == 3){
        NSDictionary *dict = _pickDataArray[row];
        pickViewSelectText = [NSString stringWithFormat:@"%@款  %@",dict[@"Model_Belongsyear"],dict[@"Model_Name"]];
        tempID = dict[@"Id"];
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}


#pragma mark - 记录更改的信息
-(void)upDataCarValue:(NSString *)value Key:(NSString *)key{
    
    [dicData setObject:value forKey:key];
    [self createData:dicData];
}

-(UIView *)createBGViewFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    view.center = CGPointMake(WIDTH/2, self.view.frame.size.height/2);
    view.alpha = 0.8;
    return view;
}

#pragma mark - 上传头像
-(void)postImage:(UIImage *)image{
  // uploadAvatar
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUploadAvatar],[[NSUserDefaults standardUserDefaults] objectForKey:user_id]];
   [HttpRequest POSTImage:image url:url fileName:@"touxiang" parameters:nil success:^(id responseObject) {
         [self loadCar];
   } failure:^(NSError *error) {
       
   }];
}

-(void)tishi:(NSString *)text superView:(UIView *)view Succeed:(BOOL)succeed{
    UILabel *label = [LHController createLabelWithFrame:CGRectMake(0, 50, 120, 20) Font:B Bold:NO TextColor:[UIColor whiteColor] Text:text];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(40, 0, 40, 40) ImageName:@"FriendsSendsPicturesSelectBigYIcon"];
    [view addSubview:imageView];
    
    if (succeed == NO) {
        imageView.image = [UIImage imageNamed:@"FriendsSendsPicturesSelectBigNIcon"];
    }
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [view removeFromSuperview];
    });
}

#pragma mark - 品牌、车系、车系数据下载
-(void)loadDataOfPickView:(NSInteger )num{
    NSString *url;
    if (num == 1) {
        url = [URLFile urlStringForLetter];
    }else if(num == 2){
        url = [NSString stringWithFormat:[URLFile urlStringForSeries],brandId];
    }else if (num == 3){
        url = [NSString stringWithFormat:[URLFile urlStringForModelList],seriesId];
    }
    _number = num;
   [HttpRequest GET:url success:^(id responseObject) {
       if (num == 1) {
           for (NSDictionary *dict in responseObject) {
               for (NSDictionary *subDic in dict[@"brand"]) {
                   [_brandArray addObject:subDic];
               }
           }
           [_pickDataArray setArray:_brandArray];
           [_pickView reloadAllComponents];
       }else if (num == 2){
           if (_seriesArray.count > 0) {
               [_seriesArray removeAllObjects];
           }
           for (NSDictionary *dic in responseObject) {
               
               for (NSDictionary *subDic in dic[@"series"]) {
                   [_seriesArray addObject:subDic];
               }
           }
           [_pickDataArray setArray:_seriesArray];
           [_pickView reloadAllComponents];
       }else if (num == 3){
           if (_modelArray.count > 0) {
               [_modelArray removeAllObjects];
           }
           for (NSDictionary *dict in responseObject) {
               [_modelArray addObject:dict];
           }
           
           [_pickDataArray setArray:_modelArray];
           [_pickView reloadAllComponents];
       }

   } failure:^(NSError *error) {
       
   }];
}

-(void)alert:(NSString *)str{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];

    double secend = 1.0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(secend * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
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
