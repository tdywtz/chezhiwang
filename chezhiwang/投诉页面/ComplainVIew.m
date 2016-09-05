                                 //
//  Complain2.m
//  auto
//
//  Created by bangong on 15/6/4.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "ComplainView.h"
#import "MyComplainViewController.h"
#import "LHAssetPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LHDatePickView.h"
#import "LHPickerView.h"
#import "CityChooseViewController.h"
#import "ChooseViewController.h"
#import "EditImageViewController.h"

#define SPACE 35
#define H 30

@interface ComplainView ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIScrollView *scrollView;
    CGFloat y;
    
    //一
    UITextField *nameTextField;//姓名
    UITextField *ageTextField;//年龄
    UITextField *phoneTextField;//手机号
    UITextField *emailTextField;//邮箱
    UITextField *callTextField;//手机号
    UITextField *addressTextField;//地址
    UITextField *occupationTextField;//职业车主
    UITextField *sexField;//性别
    
    //二
    UITextField *brandName;//品牌
    UITextField *series;//车系
    UITextField *model;//车型
    UITextField *engine;//发动机号
    UITextField *carNum;//车架号
    UITextField *numberPlate;//车牌号
    UITextField *province;//省份简称
    UITextField *dateBuy;//购车日期
    UITextField *dateBreakdown;//问题日期
    UITextField *mileage;//行驶里程
    UITextField *sheng_shi;
    UIButton *addImageButton;
    UIView *imageBGView;
    UIView *BusinessNameSuperView;
    UITextField *businessName;
    UITextField *hideBusinessName;
    CGRect addImageButtonFrame;
    
    //照片相关
    UIImagePickerController *myPicker;

    //三
    LHDatePickView *_datePicer;
    UIView *threeView;
    UITextField *complainPart;//投诉部位
    UITextField *complainServer;//服务问题
    UIView *moveBgView;
    UIButton *qualityBtn;
    UIButton *serveBtn;
    UIButton *totalBtn;
    UITextField *describe;
    UITextView *details;
    UILabel *textViewplaceholder;
    //yanzheng
    UITextField *test;
    UILabel *testLabel;
    UIButton *next;
    
    //键盘高度
    CGFloat height;

    NSString *brandId;//大品牌
    NSString *seriesId;//车系
    NSString *modelId;//车型
    NSString *provinceId;//省份id
    NSString *_cityId;//市
    NSString *businessId;//经销商id

    //字体大小
    CGFloat B;
    CGFloat frame_y;//被选中控件的位置;
    BOOL first;
}
@property (nonatomic,copy) NSString *code;//验证码
@property (nonatomic,strong) NSMutableArray *imageArray;//存储图片

@end

@implementation ComplainView
- (void)dealloc
{
    [_datePicer removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        brandId = seriesId = modelId = provinceId = _cityId = businessId = @"";
        self.imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor whiteColor];
     B = [LHController setFont];

    first = YES;
     self.title = @"我要投诉";
    
    [self createScorll];
    [self createHeader];
    [self createUI];
    [self createTap];
    [self createNotification];
   
    [self getcar];
}

#pragma mark - 注册通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
     height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    CGFloat a = HEIGHT-64-(frame_y-scrollView.contentOffset.y)-height; 
    if (a > 0) {
        a = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-height);
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-a);
    }];
}

-(void)keyboardHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.frame = self.view.frame;
    }];
}

-(void)createScorll{
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:scrollView];
}

#pragma mark - 头部
-(void)createHeader{
    UILabel *leftLabel = [LHController createLabelWithFrame:CGRectMake(LEFT, 20, 10, 10) Font:B-4 Bold:NO TextColor:colorOrangeRed Text:@"*"];
    [scrollView addSubview:leftLabel];
    
    UILabel *label1 = [LHController createLabelWithFrame:CGRectMake(LEFT+20, 10, WIDTH-2*LEFT-20, 40) Font:B-4 Bold:NO TextColor:colorOrangeRed Text:@"号为必填选项，为了我们能及时与您取得联系，了解到更详细信息，请您认真填写以下内容。"];
    [scrollView addSubview:label1];
    y = label1.frame.origin.y+label1.frame.size.height+20;
}

#pragma mark - ui搭建
-(void)createUI{
    [self createHeaderWithY:y ImageName:@"tss_07.gif" Title:@"车主信息" Content:@"您填写的信息我们会严格保密，敬请放心！" superView:scrollView];
    [self createOne];
    
    [self createHeaderWithY:y+20 ImageName:@"tss_13.gif" Title:@"车辆信息" Content:@"请如实填写您要投诉的车辆信息。" superView:scrollView];
    [self createTwo];
    [self createThree];
}

#pragma mark - 计算字符串长度
-(CGFloat)getLenth:(NSString *)str andFont:(CGFloat)font{
    CGSize size =[str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return size.width;
}

#pragma mark - 模块头部
-(void)createHeaderWithY:(CGFloat)frameY ImageName:(NSString *)imageName Title:(NSString *)title Content:(NSString *)content superView:(id)superView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, frameY, 20, 20)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:imageName];
    [superView addSubview:imageView];
    
    CGFloat width = [self getLenth:title andFont:B];
    UILabel *label2 = [LHController createLabelWithFrame:CGRectMake(LEFT+25, frameY, width, 20) Font:B Bold:NO TextColor:colorBlack Text:title];
    [superView addSubview:label2];
    
    UILabel *label3 = [LHController createLabelWithFrame:CGRectMake(label2.frame.origin.x+label2.frame.size.width, label2.frame.origin.y, WIDTH-label2.frame.origin.x-label2.frame.size.width-10, 20) Font:B-5 Bold:NO TextColor:colorOrangeRed Text:content];
    label3.textAlignment = NSTextAlignmentRight;
    [superView addSubview:label3];
    
    UILabel *fg = [[UILabel alloc] initWithFrame:CGRectMake(0, label2.frame.origin.y+label2.frame.size.height+10, WIDTH, 1)];
    fg.backgroundColor = colorLineGray;
    [superView addSubview:fg];
    if (superView == scrollView) {
         y = fg.frame.origin.y+fg.frame.size.height+10;
    }
}

#pragma mark - 第一部分
-(void)createOne{
   
    //姓名;
    NSArray *array1 = @[@"姓名:",@"年龄:",@"性别:",@"移动电话:",@"电子邮箱:",@"固定电话:",@"通讯地址:",@"车主职业:"];
    NSArray *array2 = @[@"请输入您的真实姓名，否则无法与厂家根进协调",@"请输入您的真实年龄",@"选择性别",@"请输入您的手机号码",@"",@"",@"",@"",@""];
    for (int i = 0; i < array1.count; i ++) {
        UILabel *leftLabel = [LHController createLabelWithFrame:CGRectMake(LEFT, y+(SPACE+1)*i+3.5, WIDTH-LEFT*2, SPACE) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
        [scrollView addSubview:leftLabel];
        
        CGFloat width = [self getLenth:array1[i] andFont:B-2];
        
        UILabel *labelTile = [LHController createLabelWithFrame:CGRectMake(LEFT+20, y+(SPACE+1)*i, width, SPACE) Font:B-2 Bold:NO TextColor:colorBlack Text:array1[i]];
        [scrollView addSubview:labelTile];
        
        UITextField *textField= [LHController createTextFieldWithFrame:CGRectMake(labelTile.frame.origin.x+labelTile.frame.size.width+10, labelTile.frame.origin.y, WIDTH-labelTile.frame.origin.x-width-LEFT, SPACE) Placeholder:array2[i] Font:B Delegate:self];
        [scrollView addSubview:textField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelTile.frame.origin.y+labelTile.frame.size.height, WIDTH,1)];
        lineView.backgroundColor = colorLineGray;
        [scrollView addSubview:lineView];
        if (i > 3) {
            [leftLabel removeFromSuperview];
        }
        
        if (i == 0) {
            nameTextField = textField;
        }else if (i == 1){
            ageTextField = textField;
        }else if (i == 2){
            sexField = textField;
        }else if (i == 3){
            phoneTextField = textField;
        }else if (i == 4){
            emailTextField = textField;
        }else if (i == 5){
            callTextField = textField;
        }else if (i == 6){
            addressTextField = textField;
        }else{
            occupationTextField = textField;
            y = lineView.frame.origin.y;
        }
    }
}

#pragma mark - 第二部分
-(void)createTwo{
    
    NSArray *array1 = @[@"投诉车型:",@"发动机号:",@"车架号:",@"车牌号:",@"购车日期:",@"出现问题日期:",@"已行驶里程(km):",@"经销商名称:"];
    NSArray *array2 = @[@"",@"发动机号，可从您的行驶本上查找",@"车架号，可从您的行驶本上查找",@"请输入您的车牌号",@"选择购车日期",@"选择出问题日期",@"输入行驶里程",@""];
   
    for (int i = 0; i < array1.count; i ++) {
        UILabel *labelLeft = [LHController createLabelWithFrame:CGRectMake(LEFT, y+(SPACE+1)*i+3.5, 10, SPACE) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
        [scrollView addSubview:labelLeft];
        
        CGFloat width = [self getLenth:array1[i] andFont:B-2];
        UILabel *labelTitle = [LHController createLabelWithFrame:CGRectMake(LEFT+20, y, width, SPACE) Font:B-2 Bold:NO TextColor:colorBlack Text:array1[i]];
        [scrollView addSubview:labelTitle];
       
        if (i == 0) {
            NSArray *arr1 = @[@"品牌：",@"车系：",@"车型："];
            NSArray *arr2 = @[@"选择品牌",@"选择车系",@"选择车型"];
            for (int j = 0; j < 3; j ++) {
                UILabel *starlabel = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, y+(SPACE-4)*j+SPACE+2.5, 10, SPACE-5) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
                [scrollView addSubview:starlabel];
                
                UILabel *labelName = [LHController createLabelWithFrame:CGRectMake(starlabel.frame.origin.x+10, y+(SPACE-4)*j+SPACE, 50, SPACE-5) Font:B-2 Bold:NO TextColor:colorBlack Text:arr1[j]];
                [scrollView addSubview:labelName];
               
                UITextField *field = [LHController createTextFieldWithFrame:CGRectMake(labelName.frame.origin.x+labelName.frame.size.width, labelName.frame.origin.y, WIDTH-labelName.frame.origin.x-labelName.frame.size.width-LEFT-60,SPACE-5) Placeholder:arr2[j] Font:B Delegate:self];
                [scrollView addSubview:field];
                //自定义按钮
                UIButton *customBran = [LHController createButtnFram:CGRectMake(WIDTH-60-LEFT, labelName.frame.origin.y, 60, SPACE-5) Target:self Action:@selector(customClick:) Text:@"自定义"];
                customBran.titleLabel.font = [UIFont systemFontOfSize:B-5];
                [customBran setTitleColor:colorLightBlue forState:UIControlStateNormal];
                [customBran setTitle:@"返回" forState:UIControlStateSelected];
                customBran.tag = 100+j;
                [scrollView addSubview:customBran];
                UIImageView *bgIg = [LHController createImageViewWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"complain_customBtnBackGround"];
                [bgIg setContentMode:UIViewContentModeScaleAspectFill];
                bgIg.center = CGPointMake(customBran.frame.size.width/2, customBran.frame.size.height/2);
                [customBran addSubview:bgIg];
               //虚线
                UIView *lineA = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, labelName.frame.origin.y+labelName.frame.size.height, WIDTH-labelName.frame.origin.x-LEFT, 1)];
                lineA.backgroundColor  = colorLineGray;
                [scrollView addSubview:lineA];
                
                if (j == 0) brandName = field;
                else if (j == 1) series = field;
                else model = field;
            }
        }
       else if (i > 0 && i < 7) {
           
            labelLeft.frame = CGRectMake(LEFT,  y+(SPACE+1)*i+(SPACE-5)*3+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20,  y+(SPACE+1)*i+(SPACE-5)*3, width, SPACE);
           UITextField *textField = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-labelTitle.frame.origin.x-labelTitle.frame.size.width-LEFT, SPACE) Placeholder:array2[i] Font:B Delegate:self];
           [scrollView addSubview:textField];
           if (i == 1) engine = textField;
           if (i == 2) carNum = textField;
           if (i == 3){
               province = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10,labelTitle.frame.origin.y, 40, SPACE) Placeholder:@"京" Font:B Delegate:self];
               province.text = @"京";
               [scrollView addSubview:province];
               
               UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(20, 10, 15, 15) ImageName:@"xuanze"];
               [imageView setContentMode:UIViewContentModeScaleAspectFit];
               [province addSubview:imageView];
               
               numberPlate = textField;
               numberPlate.frame = CGRectMake(province.frame.origin.x+province.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-province.frame.origin.x-province.frame.size.width-LEFT, SPACE);
           }
           if (i == 4) dateBuy = textField;
           if (i == 5)dateBreakdown = textField;
           if (i == 6){
               mileage = textField;
               textField.keyboardType = UIKeyboardTypeNumberPad;
           }
          //虚线
           UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelTitle.frame.origin.y+labelTitle.frame.size.height, WIDTH, 1)];
           lineView.backgroundColor = colorLineGray;
           [scrollView addSubview:lineView];
        }
        else {
            labelLeft.frame = CGRectMake(LEFT,  y+(SPACE+1)*i+(SPACE-5)*3+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20,  y+(SPACE+1)*i+(SPACE-5)*3, width, SPACE);
            //自定义按钮
            UIButton *customBran = [LHController createButtnFram:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, 60, SPACE) Target:self Action:@selector(customClick:) Text:@"自定义"];

            UIImageView *bgIg = [LHController createImageViewWithFrame:CGRectMake(0, 0, 50, 20) ImageName:@"complain_customBtnBackGround"];
            [bgIg setContentMode:UIViewContentModeScaleAspectFit];
            bgIg.center = CGPointMake(customBran.frame.size.width/2, customBran.frame.size.height/2);
            [customBran addSubview:bgIg];
        
            [customBran setTitleColor:colorLightBlue forState:UIControlStateNormal];
            [customBran setTitle:@"返回" forState:UIControlStateSelected];
            customBran.titleLabel.font = [UIFont systemFontOfSize:B-5];
            customBran.tag = 103;
            [scrollView addSubview:customBran];
            
            CGFloat _yy = labelTitle.frame.origin.y+labelTitle.frame.size.height;
            UILabel *starhide = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, _yy+2.5, 10, SPACE) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [scrollView addSubview:starhide];
            
            hideBusinessName = [LHController createTextFieldWithFrame:CGRectMake(starhide.frame.origin.x+15, _yy, WIDTH-starhide.frame.origin.x-LEFT, SPACE) Placeholder:@"输入经销商名称" Font:B Delegate:self];
            [scrollView addSubview:hideBusinessName];
            
            UIView *hideLine = [[UIView alloc] initWithFrame:CGRectMake(starhide.frame.origin.x+10, hideBusinessName.frame.origin.y+hideBusinessName.frame.size.height+5, hideBusinessName.frame.size.width, 1)];
            hideLine.backgroundColor = colorLineGray;
            [scrollView addSubview:hideLine];
            
            BusinessNameSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, _yy, WIDTH, SPACE*2)];
            BusinessNameSuperView.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:BusinessNameSuperView];
            
            UILabel *star1 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, 2.5, 10, SPACE-5) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [BusinessNameSuperView addSubview:star1];
            
            UILabel *starLabel1 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x+10, 0, 60, SPACE-5) Font:B-2 Bold:NO TextColor:colorBlack Text:@"省、市:"];
            [BusinessNameSuperView addSubview:starLabel1];
            
            sheng_shi = [LHController createTextFieldWithFrame:CGRectMake(starLabel1.frame.origin.x+starLabel1.frame.size.width, starLabel1.frame.origin.y, WIDTH-starLabel1.frame.origin.x-starLabel1.frame.size.width-LEFT+10, SPACE-5) Placeholder:@"选择省份、市区" Font:B Delegate:self];
            [BusinessNameSuperView addSubview:sheng_shi];
           
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, starLabel1.frame.origin.y+starLabel1.frame.size.height, WIDTH-starLabel1.frame.origin.x-LEFT, 1)];
            line1.backgroundColor = colorLineGray;
            [BusinessNameSuperView addSubview:line1];
            
            UILabel *star2 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x, SPACE-1.5, 10, SPACE-5) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
            [BusinessNameSuperView addSubview:star2];
            
            UILabel *starLabel2 = [LHController createLabelWithFrame:CGRectMake(labelTitle.frame.origin.x+10, SPACE-4, 60, SPACE-5) Font:B-2 Bold:NO TextColor:colorBlack Text:@"经销商:"];
            [BusinessNameSuperView addSubview:starLabel2];
            
            businessName = [LHController createTextFieldWithFrame:CGRectMake(starLabel2.frame.origin.x+starLabel2.frame.size.width, starLabel2.frame.origin.y, WIDTH-starLabel1.frame.origin.x-starLabel1.frame.size.width-LEFT+10, SPACE-5) Placeholder:@"选择经销商" Font:B Delegate:self];
            [BusinessNameSuperView addSubview:businessName];
            
            UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(labelTitle.frame.origin.x, starLabel2.frame.origin.y+starLabel2.frame.size.height, WIDTH-starLabel2.frame.origin.x-LEFT, 1)];
            line2.backgroundColor = colorLineGray;
            [BusinessNameSuperView addSubview:line2];
            
            y = BusinessNameSuperView.frame.origin.y+BusinessNameSuperView.frame.size.height;
        }
    }

    CGFloat imageWidth = (WIDTH-100-LEFT-LEFT)/3-1;
    imageBGView = [[UIView alloc] initWithFrame:CGRectMake(0, y+10, WIDTH, imageWidth)];
    [scrollView addSubview:imageBGView];
    //上传图片
    UILabel *labelImage = [LHController createLabelWithFrame:CGRectMake(LEFT+20,(imageWidth-20)/2, 90, 20) Font:B Bold:NO TextColor:colorBlack Text:@"上传图片:"];
    [imageBGView addSubview:labelImage];
    
    addImageButton = [LHController createButtnFram:CGRectMake(110+LEFT, 0, imageWidth-1, imageWidth-1) Target:self Action:@selector(addImageClick) Text:nil];
    UIImage *ig = [UIImage imageNamed:@"selectIamge_add"];
    [addImageButton setImage:ig forState:UIControlStateNormal];
    [imageBGView addSubview:addImageButton];
    
    addImageButtonFrame = addImageButton.frame;
    
    y = imageBGView.frame.origin.y+imageWidth;
}

#pragma mark - 自定义点击按钮响应方法
-(void)customClick:(UIButton *)btn{
   
    [self.view endEditing:YES];
    
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:102];
    btn.selected = !btn.selected;
    if (btn.tag == 100) {
        brandName.placeholder = @"请输入品牌";//品牌
        series.placeholder = @"请输入车系";//车系
        model.placeholder = @"请输入车型";//车型
        brandName.text = @"";//品牌
        series.text = @"";//车系1
        model.text = @"";//车型
        
        btn1.enabled = NO;
        btn2.enabled = NO;
        btn1.selected = NO;
        btn2.selected = NO;
        [btn1 setTitleColor:colorLightGray forState:UIControlStateNormal];
        [btn2 setTitleColor:colorLightGray forState:UIControlStateNormal];
        
        if (btn.selected == NO) {
            btn1.enabled = YES;
            btn2.enabled = YES;
             [btn1 setTitleColor:colorLightBlue forState:UIControlStateNormal];
             [btn2 setTitleColor:colorLightBlue forState:UIControlStateNormal];
           
            brandName.placeholder = @"选择品牌";//品牌
            series.placeholder = @"选择车系";//车系
            model.placeholder = @"选择型号";//车型
        }else{
             seriesId = @"";//车系
             modelId = @"";//车型
             brandId = @"";//大品牌
        }
        
    }else if (btn.tag == 101){
        series.placeholder = @"请输入车系";//车系
        model.placeholder = @"请输入车型";//车型
        series.text = @"";//车系
        model.text = @"";//车型

        btn2.enabled = NO;
        btn2.selected = NO;
        [btn2 setTitleColor:colorLightGray forState:UIControlStateNormal];

        if (btn.selected == NO) {
            btn2.enabled = YES;
            [btn2 setTitleColor:colorLightBlue forState:UIControlStateNormal];

           // brandName.placeholder = @"请输入品牌";//品牌
            series.placeholder = @"选择车系";//车系
            model.placeholder = @"选择型号";//车型
        }
        if (btn.selected == YES) {
            seriesId = @"";//车系
            modelId = @"";//车型
        }

    }else if (btn.tag == 102){
        model.placeholder = @"请输入车型";//车型
        model.text = @"";//车型
        if (btn.selected == NO) {
            model.placeholder = @"选择车型";//车型
        }
        if (btn.selected == YES) {
            modelId = @"";//车型
        }

    }else{
        if (btn.selected == YES) {
            businessName.text = @"";
            sheng_shi.text = @"";
            provinceId = @"";//省份id
            _cityId = @"";//市
            businessId = @"";//经销商id
            BusinessNameSuperView.hidden = YES;
        }
       
        if (btn.selected == NO) {
            hideBusinessName.text = @"";
            BusinessNameSuperView.hidden = NO;
        }
    }
    
    if(btn.selected){
        businessId = @"";//经销商id
        businessName.text = @"";
    }
}

#pragma mark - 选择上传图片方法
-(void)addImageClick{
    [self.view endEditing:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"摄像",@"从相册选择", nil];
    sheet.delegate = self;
    [sheet showInView:self.view];
}

#pragma mark - uiactionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (myPicker == nil) {
        myPicker = [[UIImagePickerController alloc] init];
        myPicker.delegate = self;
    }
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:myPicker animated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        LHAssetPickerController *picker = [[LHAssetPickerController alloc] init];
        picker.maxNumber = 6;
        [picker getAssetArray:^(NSArray *assetArray) {
            
            for (ALAsset *asset in assetArray) {
                
                if (_imageArray.count < 6) {
                    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
                    if (image.size.width > 550) {
                        CGSize size = CGSizeMake(550, image.size.height*(550.0/image.size.width));
                        image = [self scaleToSize:image size:size];
                    }
                    [_imageArray addObject:image];
                }else{
                    [self alertView:@"图片不能超过6张"];
                    break;
                }
                
            }
            [self showImage];
        }];
        picker.maxNumber = 6 - self.imageArray.count;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - 第三部分
-(void)createThree{
  
    threeView = [[UIView alloc] initWithFrame:CGRectMake(0, y+20, WIDTH, 400)];
    [scrollView addSubview:threeView];
    
    [self createHeaderWithY:0 ImageName:@"tss_10.gif" Title:@"投诉内容" Content:@"请务必如实、详细地描述完整的投诉信息。" superView:threeView];

    moveBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 300)];
    moveBgView.backgroundColor = [UIColor whiteColor];
    [threeView addSubview:moveBgView];
    NSArray *array1 = @[@"投诉类型:",@"质量投诉部位:",@"服务投诉问题:",@"问题描述:",@"投诉详情:"];
  //  NSArray *array2 = @[@"",@"请选择质量投诉部位",@"控制在24个汉字以内、仅限汉字、数字、字母",@""];
    
    //初始位置
    CGFloat beginY = SPACE;
    for (int i = 0; i < array1.count; i ++) {
        UILabel *labelLeft = [LHController createLabelWithFrame:CGRectMake(LEFT,beginY +(SPACE+1)*i+3.5, 10, SPACE) Font:B Bold:NO TextColor:colorOrangeRed Text:@"*"];
        
        
        CGFloat width = [self getLenth:array1[i] andFont:B-2];
        UILabel *labelTitle = [LHController createLabelWithFrame:CGRectMake(LEFT+20, beginY+(SPACE+1)*i, width, SPACE) Font:B-2 Bold:NO TextColor:colorBlack Text:array1[i]];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = colorLineGray;
        
        
        if (i > 0) {
            labelLeft.frame = CGRectMake(LEFT, beginY+(SPACE+1)*i+SPACE+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20, beginY+(SPACE+1)*i+SPACE, width, SPACE);
        }
   
        if (i == 0) {
            NSArray *array = @[@"质量问题",@"服务问题",@"综合问题"];
            for (int k = 0; k < 3; k ++) {
                UIButton *btn = [LHController createButtnFram:CGRectMake(labelTitle.frame.origin.x+(WIDTH-labelTitle.frame.origin.x-LEFT)/3*k, beginY+SPACE, 20, H) Target:self Action:@selector(btnClick:)];
                [threeView addSubview:btn];
                
                UILabel *label = [LHController createLabelWithFrame:CGRectMake(btn.frame.origin.x+btn.frame.size.width+5, beginY+SPACE, 80, H) Font:B-2 Bold:NO TextColor:colorBlack Text:array[k]];
                [threeView addSubview:label];
                if(k == 0){
                    qualityBtn = btn;
                    qualityBtn.selected = YES;
                }else if (k == 1){
                    serveBtn = btn;
                }else{
                    totalBtn = btn;
                }
            }
            lineView.frame = CGRectMake(0, labelTitle.frame.origin.y+labelTitle.frame.size.height+SPACE, WIDTH, 1);
            [threeView addSubview:labelLeft];
            [threeView addSubview:labelTitle];
            [threeView addSubview:lineView];
        }else if (i == 1){
            moveBgView.frame = CGRectMake(0, labelTitle.frame.origin.y, WIDTH, 300);
            
            UIView *combg = [[UIView alloc] initWithFrame:CGRectMake(0, labelTitle.frame.origin.y, WIDTH, SPACE+1)];
            [threeView addSubview:combg];
            labelLeft.frame = CGRectMake(LEFT, 3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20, 0, width, SPACE);
            lineView.frame = CGRectMake(0, SPACE, WIDTH, 1);
            [combg addSubview:labelLeft];
            [combg addSubview:lineView];
            [combg addSubview:labelTitle];
    
            complainPart = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-labelTitle.frame.origin.x-labelTitle.frame.size.width-LEFT, SPACE) Placeholder:@"请选择质量投诉部位" Font:B Delegate:self];
            [combg addSubview:complainPart];
            
        }else if (i == 2){
           
            UIView *bgbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, SPACE)];
            bgbg.hidden = YES;
            [moveBgView addSubview:bgbg];
            
            labelLeft.frame = CGRectMake(LEFT, 3.5, 10, SPACE);
            [bgbg addSubview:labelLeft];
            
            labelTitle.frame = CGRectMake(LEFT+20, 0, labelTitle.frame.size.width, SPACE);
            [bgbg addSubview:labelTitle];
            
            complainServer = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x+labelTitle.frame.size.width+10, labelTitle.frame.origin.y, WIDTH-labelTitle.frame.origin.x-labelTitle.frame.size.width-LEFT, SPACE) Placeholder:@"请选择服务投诉问题" Font:B Delegate:self];
            [bgbg addSubview:complainServer];
            
            lineView.frame = CGRectMake(0, labelTitle.frame.origin.y+labelTitle.frame.size.height, WIDTH, 1);
            [bgbg addSubview:lineView];
        }
        else if (i == 3){
            
            labelLeft.frame = CGRectMake(LEFT, SPACE+4.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20, SPACE+1, width, SPACE);
            [moveBgView addSubview:labelLeft];
            [moveBgView addSubview:labelTitle];
            
            describe = [LHController createTextFieldWithFrame:CGRectMake(labelTitle.frame.origin.x, labelTitle.frame.origin.y+labelTitle.frame.size.height+1, WIDTH-labelTitle.frame.origin.x-LEFT, SPACE) Placeholder:@"控制在24个汉字以内、仅限汉字、数字、字母" Font:B Delegate:self];
            [moveBgView addSubview:describe];
            
            lineView.frame = CGRectMake(0, describe.frame.origin.y+SPACE, WIDTH, 1);
            [moveBgView addSubview:lineView];
        }else{
            labelLeft.frame = CGRectMake(LEFT, (SPACE+1)*3+3.5, 10, SPACE);
            labelTitle.frame = CGRectMake(LEFT+20,(SPACE+1)*3, width, SPACE);
            [moveBgView addSubview:labelLeft];
            [moveBgView addSubview:labelTitle];
            [self createFoot:labelTitle.frame.origin.y+labelTitle.frame.size.height];
        }
    }
}

#pragma mark - 尾部视图创建
-(void)createFoot:(CGFloat)frameY{

    details = [[UITextView alloc] initWithFrame:CGRectMake(LEFT+20, frameY, WIDTH-LEFT*2-LEFT, 80)];
    details.delegate  = self;
    details.textColor = colorBlack;
    details.font = [UIFont systemFontOfSize:B-2];
    [moveBgView addSubview:details];
    
    textViewplaceholder = [LHController createLabelWithFrame:CGRectMake(3, 7, 200, 20) Font:B-2 Bold:NO TextColor:colorLightGray Text:@"输入投诉详情"];
    [details addSubview:textViewplaceholder];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, details.frame.origin.y+details.frame.size.height+10, WIDTH, 1)];
    lineView.backgroundColor = colorLineGray;
    [moveBgView addSubview:lineView];
    //验证码
    test = [LHController createTextFieldWithFrame:CGRectMake(details.frame.origin.x, lineView.frame.origin.y+20, 80, 30) Placeholder:@"输入验证码" Font:B Delegate:self];
    test.layer.borderColor = colorLineGray.CGColor;
    test.layer.borderWidth = 1;
    UIImage *img = [UIImage imageNamed:@"textView"];
    img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [test setBackground:img];
    test.textAlignment = NSTextAlignmentCenter;
    test.keyboardType = UIKeyboardTypeNumberPad;
    [moveBgView addSubview:test];
    
    testLabel = [[UILabel alloc] initWithFrame:CGRectMake(test.frame.origin.x+test.frame.size.width+10, test.frame.origin.y, 60, 30)];
   //testLabel.backgroundColor = [UIColor grayColor];
    testLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapToGenerateCode:)];
    [testLabel addGestureRecognizer:tap];
    [moveBgView addSubview:testLabel];

    UILabel *ts = [LHController createLabelWithFrame:CGRectMake(testLabel.frame.origin.x+testLabel.frame.size.width+10, test.frame.origin.y, WIDTH-testLabel.frame.origin.x-testLabel.frame.size.width-10, 30) Font:B-4 Bold:NO TextColor:colorDeepGray Text:@"看不清请点击验证码图片"];
    [moveBgView addSubview:ts];
    
    //创建下一步按钮
    next = [LHController createButtnFram:CGRectMake(LEFT, test.frame.origin.y+test.frame.size.height+20, WIDTH-LEFT*2, 40) Target:self Action:@selector(nextClick) Font:B Text:@"提  交"];
    [moveBgView addSubview:next];
    
    UILabel *labeltishi = [LHController createLabelWithFrame:CGRectMake(next.frame.origin.x, next.frame.origin.y+next.frame.size.height+5, WIDTH-next.frame.origin.x*2, 20) Font:B-4 Bold:NO TextColor:colorOrangeRed Text:@"注：请认真填写，待网站审核后不能修改"];
    [moveBgView addSubview:labeltishi];
    
    [self onTapToGenerateCode:nil];
    
    moveBgView.frame = CGRectMake(0, moveBgView.frame.origin.y, WIDTH, labeltishi.frame.origin.y);
    threeView.frame = CGRectMake(0, threeView.frame.origin.y, WIDTH, moveBgView.frame.origin.y+moveBgView.frame.size.height);
    
    scrollView.contentSize = CGSizeMake(0, threeView.frame.origin.y+threeView.frame.size.height+50);
}

#pragma mark - 圆圈选择按钮响应事件
-(void)btnClick:(UIButton *)btn{

    //投诉类型
    if (btn == qualityBtn) {
        qualityBtn.selected = YES;
        serveBtn.selected = NO;
        totalBtn.selected = NO;
        complainServer.superview.hidden = YES;
        complainPart.superview.hidden = NO;
        complainServer.text = @"";
        CGRect frame = moveBgView.frame;
        frame.origin.y = complainPart.superview.frame.origin.y;
        moveBgView.frame = frame;
       
    }else if (btn == serveBtn){
        
        qualityBtn.selected = NO;
        serveBtn.selected = YES;
        totalBtn.selected = NO;
        complainServer.superview.hidden = NO;
        complainPart.superview.hidden = YES;
        complainPart.text = @"";
        CGRect frame = moveBgView.frame;
        frame.origin.y = complainPart.superview.frame.origin.y;
        moveBgView.frame = frame;
        //[threeView insertSubview:moveBgView aboveSubview:complainPart];
    }else if (btn == totalBtn){
            qualityBtn.selected = NO;
            serveBtn.selected = NO;
            totalBtn.selected = YES;
        complainServer.superview.hidden = NO;
        complainPart.superview.hidden = NO;
        CGRect frame = moveBgView.frame;
        frame.origin.y = complainPart.superview.frame.origin.y+complainPart.frame.size.height+1;
        moveBgView.frame = frame;
       // [threeView insertSubview:moveBgView belowSubview:complainPart];
    }
    threeView.frame = CGRectMake(0, threeView.frame.origin.y, WIDTH, moveBgView.frame.origin.y+moveBgView.frame.size.height);
    scrollView.contentSize = CGSizeMake(0, threeView.frame.origin.y+threeView.frame.size.height+50);

}



#pragma mark - 提交按钮,点击发布
-(void)nextClick{

    if ([LHController judegmentSpaceChar:nameTextField.text] == NO) {
        [self alertView:@"名字不能为空"];
        
    }else if ([ageTextField.text integerValue] < 10){
        [self alertView:@"年龄小于10岁"];
        
    }else if (sexField.text.length == 0){
        [self alertView:@"请选择性别"];
    }
    else if ([LHController judegmentSpaceChar:phoneTextField.text] == NO){
        [self alertView:@"手机号码不能为空"];
        
    }else if ([LHController judegmentSpaceChar:brandName.text] == NO){
        [self alertView:@"品牌不能为空"];
        
    }else if ([LHController judegmentSpaceChar:series.text] == NO){
        [self alertView:@"车系不能为空"];
        
    }else if ([LHController judegmentSpaceChar:model.text] == NO) {
        [self alertView:@"车型不能为空"];
        
    }else if ([LHController judegmentSpaceChar:engine.text] == NO){
        [self alertView:@"发动机号不能为空"];
        
    }else if ([LHController judegmentSpaceChar:carNum.text] == NO) {
        [self alertView:@"车架号不能为空"];
        
    }
    else if (dateBuy.text.length == 0){
        [self alertView:@"购车日期不能为空"];
        
    }else if (dateBreakdown.text.length == 0){
        [self alertView:@"出现故障日期不能为空"];
        
    }else if (![NSString isDigital:mileage.text]){
        [self alertView:@"行驶里程只能为数字，请重新输入"];
    }
    else if([LHController judegmentSpaceChar:describe.text] == NO){
        [self alertView:@"问题描述不能为空"];
        
    }else if ([LHController judegmentSpaceChar:details.text] == NO){
        [self alertView:@"投诉详情不能为空"];
    }else if (complainPart.text.length == 0 && complainServer.text.length == 0){
        [self alertView:@"请选择投诉类型"];
    }else if (!([test.text caseInsensitiveCompare:self.code] == NSOrderedSame)) {
        [self alertView:@"验证码不正确"];

    }else{
        if (![LHController judegmentCarNum:numberPlate.text] || numberPlate.text.length > 6 || ![LHController judegmentSpaceChar:numberPlate.text]) {
            [self alertView:@"车牌号只能是6位以内字母和数字组成的"];
            
        }
        else if ([LHController judegmentSpaceChar:businessName.text] == NO && [LHController judegmentSpaceChar:hideBusinessName.text] == NO){
            [self alertView:@"经销商名称不能为空"];
        }else if ([LHController judegmentChar:describe.text]){
            if (describe.text.length > 24) {
                [self alertView:@"问题描述不能大于24个汉字"];
            }else{
                [self createData];
            }
            
        }else{
            [self alertView:@"问题描述只能包含汉字、数字、字母、标点符号"];
        }
    }
}

#pragma mark - 建立数据字典
-(void)createData{
 
    NSMutableDictionary *superDict = [[NSMutableDictionary alloc] init];
    [superDict setObject:@"0" forKey:@"Cpid"];
    if (self.dictionary[@"cpid"]) {
        [superDict setObject:self.dictionary[@"cpid"] forKey:@"Cpid"];
    }
    
    [superDict setObject:nameTextField.text forKey:@"Name"];
    [superDict setObject:ageTextField.text forKey:@"Age"];
    [superDict setObject:phoneTextField.text forKey:@"Mobile"];
    [superDict setObject:emailTextField.text forKey:@"Email"];
    [superDict setObject:callTextField.text forKey:@"Telephone"];
    [superDict setObject:addressTextField.text forKey:@"Address"];
    [superDict setObject:occupationTextField.text forKey:@"Occupation"];
    [superDict setObject:sexField.text forKey:@"Sex"];
    
    
    NSString *brandSring = brandId.length > 0?@"":brandName.text;
    NSString *seriesSring = seriesId.length > 0?@"":series.text;
    NSString *modelSring = modelId.length > 0?@"":model.text;
    [superDict setObject:brandSring forKey:@"Autoname"];
    [superDict setObject:seriesSring forKey:@"Autopart"];
    [superDict setObject:modelSring forKey:@"Autostyle"];
    [superDict setObject:brandId forKey:@"BrandId"];
    [superDict setObject:seriesId forKey:@"SeriesId"];
    [superDict setObject:modelId forKey:@"ModelId"];
    
    [superDict setObject:engine.text forKey:@"Engine_Number"];
    [superDict setObject:carNum.text forKey:@"Carriage_Number"];//
    [superDict setObject:[NSString stringWithFormat:@"%@^%@",province.text,numberPlate.text] forKey:@"AutoSign"];
    [superDict setObject:dateBuy.text forKey:@"Buyautotime"];
    [superDict setObject:dateBreakdown.text forKey:@"Questiontime"];
    
    [superDict setObject:hideBusinessName .text forKey:@"Buyname"];
    [superDict setObject:businessName.text forKey:@"Disname"];
    [superDict setObject:mileage.text forKey:@"mileage"];
    [superDict setObject:businessId forKey:@"Disid"];
    [superDict setObject:@"" forKey:@"Image"];
    
    
    [superDict setObject:describe.text forKey:@"Question"];
    [superDict setObject:details.text forKey:@"Content"];
    if (qualityBtn.selected == YES) {
        [superDict setObject:@"质量问题" forKey:@"C_Tslx"];
    }else if (serveBtn.selected == YES){
        [superDict setObject:@"服务问题" forKey:@"C_Tslx"];
    }else{
        [superDict setObject:@"综合问题" forKey:@"C_Tslx"];
    }
    
    
    [superDict setObject:complainPart.text forKey:@"C_Tsbw"];
    [superDict setObject:complainServer.text forKey:@"C_Tsfw"];
 

    [superDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:user_id] forKey:@"User_ID"];
    
    [superDict setObject:appOrigin forKey:@"origin"];
    if (self.again) {
        [superDict setObject:@"again" forKey:@"again"];
    }else{
        [superDict setObject:@"" forKey:@"again"];
    }
    next.enabled = NO;
    next.titleLabel.text = @"正在提交";
    next.backgroundColor = [UIColor grayColor];
    [self
     postData:superDict];
}

#pragma mark - 提交数据
-(void)postData:(NSDictionary *)dic{
    UIActivityIndicatorView *act= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置中心点为view的中心点
    act.frame = CGRectMake(0, 0, 15, 15);
    act.color = [UIColor grayColor];
    [next addSubview:act];
    [act startAnimating];
    
    [HttpRequest POST:[URLFile urlStringForProgressComplain] parameters:dic images:_imageArray success:^(id responseObject) {
        [act stopAnimating];
        if (self.updata) {
            self.updata();
        }
        [self.navigationController popViewControllerAnimated:YES];

    } failure:^(NSError *error) {
        [act stopAnimating];
        next.enabled = YES;
        next.backgroundColor = [UIColor colorWithRed:254/255.0 green:153/255.0 blue:23/255.0 alpha:1];
        [self alertView:@"上传失败"];

    }];
}

#pragma mark - alert信息提示语
-(void)alertView:(NSString *)str{

    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [al dismissWithClickedButtonIndex:0 animated:YES];
    });
   
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITxetField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    frame_y = textField.frame.origin.y+textField.frame.size.height;
    if(textField == describe || textField == test){
        frame_y = threeView.frame.origin.y+moveBgView.frame.origin.y+textField.frame.origin.y+50;
    }

    if (textField == sexField) {
        NSDictionary *dict1 = @{@"title":@"男",@"id":@"1"};
        NSDictionary *dict2 = @{@"title":@"女",@"id":@"2"};
        NSArray *array = @[dict1,dict2];
        LHPickerView *picker = [[LHPickerView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        picker.dataArray = array;
        picker.titleText = @"性别";
        [picker showPickerView];
        [picker returnResult:^(NSString *title, NSString *ID) {
            textField.text = title;
        }];
        [self.view endEditing:YES];
        return NO;
    }
    if (textField == ageTextField) {
        ageTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (textField == phoneTextField) {
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (textField == addressTextField) {
        emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    if (textField == test) {
       
    }

    //如果是车牌号
    if (textField == province) {
        LHPickerView *picker = [[LHPickerView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:picker];
        picker.dataArray = [HttpRequest readProvince];
        picker.titleText = @"省份简称";
        [picker showPickerView];
        [picker returnResult:^(NSString *title, NSString *ID) {
            textField.text = title;
        }];
        [self.view endEditing:YES];
        return NO;
    }
    //如果是投诉类型
    if (textField == brandName) {
        //是否自定义
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:100];
        if (btn.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        [self chooseViewController:textField];
        return NO;
    }
    //投诉车系
    if (textField == series) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        if (btn1.selected || btn2.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        if (brandId.length > 0) {
             [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择品牌"];
        }
        
        return NO;
    }
    //车型
    if (textField == model) {
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:100];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:101];
        UIButton *btn3 = (UIButton *)[self.view viewWithTag:102];
        if (btn1.selected || btn2.selected || btn3.selected) {
            return YES;
        }
        [self.view endEditing:YES];
        
//       NSString *str = [NSString stringWithUTF8String:object_getClassName(seriesId)];
        if ([seriesId floatValue] > 0) {
             [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择车系"];
        }
       
        return NO;
    }
       //购买时间
      if (textField == dateBuy) {

          [self createDatePicerView:dateBuy];
          [self.view endEditing:YES];
          return NO;
        }else if(textField == dateBreakdown){
            [self createDatePicerView:dateBreakdown];
            [self.view endEditing:YES];
            return NO;
        }
    //省市选择
    if (textField == sheng_shi) {
        CityChooseViewController *city = [[CityChooseViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:city];
        [city returnRsults:^(NSString *pName, NSString *pid, NSString *cName, NSString *cid) {
            if ([pName isEqualToString:cName]) {
                textField.text = pName;
            }else{
                 textField.text = [NSString stringWithFormat:@"%@%@",pName,cName];
            }
            provinceId = pid;
            _cityId = cid;
            if ([cid isKindOfClass:[NSString class]] == NO) {
                _cityId = [NSString stringWithFormat:@"%@",cid];
            }
           
        }];
        [self.view endEditing:YES];
        [self presentViewController:nvc animated:YES completion:nil];
        return NO;
    }
    //经销商
    if (textField == businessName) {
       
        if ([_cityId intValue] > 0) {
           
             [self chooseViewController:textField];
        }else{
            [self alertView:@"还未选择省、市"];
        }
        [self.view endEditing:YES];
        return NO;
    }
    //
    if (textField == complainPart || textField == complainServer) {
        [self.view endEditing:YES];
        [self chooseViewController:textField];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == describe) {
        if (describe.text.length > 24) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"问题描述不能超过24个汉字" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [al show];
        }else if (![LHController judegmentChar:describe.text]){
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"问题描述只能包含汉字、字母、数字、标点符号" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"完成", nil];
            [al show];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
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
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  //  doneBt.hidden = YES;
    frame_y = threeView.frame.origin.y+textView.frame.origin.y+moveBgView.frame.origin.y+textView.frame.origin.y;
    return YES;
}

#pragma mark - 选择列表
-(void)chooseViewController:(UITextField *)field{
   
    ChooseViewController *choose = [[ChooseViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:choose];
    nvc.navigationBar.barStyle = UIBarStyleBlack;
    [choose retrunResults:^(NSString *title, NSString *ID) {
        field.text = title;
  
        if (field == brandName) {
            brandId = ID;
            seriesId = modelId =businessId = @"";
            series.text = model.text = businessName.text = @"";
        }else if (field == series){
            seriesId = ID;
            modelId =businessId = @"";
            model.text = businessName.text = @"";
        }else if (field == model){
            modelId = ID;
            businessId = @"";
            businessName.text = @"";
        }else if (field == complainPart){
        
        }else if (field == businessName){
            businessId = ID;
        }
    }];
    if (field == brandName) {
        choose.choosetype = chooseTypeBrand;
    }else if (field == series){
        choose.ID = brandId;
        choose.choosetype = chooseTypeSeries;
      
    }else if (field == model){
        choose.ID = seriesId;
        choose.choosetype = chooseTypeModel;

    }else if (field == complainPart){
        choose.choosetype = chooseTypeComplainQuality;
        
    }else if (field == complainServer){
        choose.choosetype = chooseTypeComplainService;
    }
    else if (field == businessName){
        choose.ID = provinceId;
        choose.cityId = _cityId;
        choose.seriesId = seriesId;
        choose.choosetype = chooseTypeBusiness;
    }
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - 创建时间选择控件
-(void)createDatePicerView:(UITextField *)field{
    if (_datePicer == nil) {
        _datePicer = [[LHDatePickView alloc] init];
        _datePicer.minimumDate = @"2005-01-01";
        [[UIApplication sharedApplication].keyWindow addSubview:_datePicer];
    }
    _datePicer.minimumDate = dateBuy.text.length>0?dateBuy.text:@"2005-01-01";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    if (field == dateBuy) {
        _datePicer.titleText = @"购车日期";
        _datePicer.minimumDate = @"2005-01-01";
        _datePicer.maximumDate = dateBreakdown.text.length > 0 ? dateBreakdown.text:dateString;
    }else if (field == dateBreakdown){
        _datePicer.titleText = @"出故障日期";
         _datePicer.maximumDate = dateBuy.text.length > 0 ? dateBuy.text:@"2005-01-01";
        _datePicer.maximumDate = dateString;
    }
    [_datePicer returnDate:^(NSString *date) {
        field.text = date;
    }];
    _datePicer.hidden = NO;
    [_datePicer showDatePicerView];
}

#pragma mark - 空白收回键盘/手势

-(void)createTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [scrollView addGestureRecognizer:tap];
}
-(void)tap:(UITapGestureRecognizer *)tap{
   
    [self.view endEditing:YES];
}

#pragma mark - ###########################################################################
#pragma mark - 选择照片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
    if (image.size.width > 550) {
        CGSize size = CGSizeMake(550, image.size.height*(550.0/image.size.width));
        image = [self scaleToSize:image size:size];
    }

    if (_imageArray.count < 6) {
        [_imageArray addObject:image];
        [self showImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 改变图片尺寸
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -  显示所选择德图片
-(void)showImage{
    for (UIView *view in imageBGView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    if (self.imageArray.count == 0) {
        addImageButton.hidden = NO;
        addImageButton.frame = addImageButtonFrame;
        CGRect frame = imageBGView.frame;
        frame.size.height = addImageButtonFrame.size.width+1;
        imageBGView.frame = frame;
    }
    for (int i = 0; i < _imageArray.count; i ++) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(addImageButtonFrame.origin.x+(addImageButtonFrame.size.width+1)*(i%3), (addImageButtonFrame.size.width+1)*(i/3), addImageButtonFrame.size.width, addImageButtonFrame.size.height)];
        imageView.image = self.imageArray[i];
        imageView.tag = 200+i;
        imageView.userInteractionEnabled = YES;
        [imageBGView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [imageView addGestureRecognizer:tap];
        
        if (i == self.imageArray.count-1) {
            imageBGView.frame = CGRectMake(0, imageBGView.frame.origin.y, WIDTH, imageView.frame.origin.y+imageView.frame.size.height+1);
            
            if (self.imageArray.count == 6) {
                addImageButton.hidden = YES;
                addImageButton.frame = imageView.frame;
            }else{
                addImageButton.hidden = NO;
                addImageButton.frame = CGRectMake(addImageButtonFrame.origin.x+(addImageButtonFrame.size.width+1)*((i+1)%3), (addImageButtonFrame.size.width+1)*((i+1)/3), addImageButtonFrame.size.width, addImageButtonFrame.size.height);
            }
        }
        CGRect frame = imageBGView.frame;
        frame.size.height = addImageButton.frame.size.height+addImageButton.frame.origin.y+3;
        imageBGView.frame = frame;
    }

    threeView.frame = CGRectMake(0, imageBGView.frame.origin.y+imageBGView.frame.size.height+15, WIDTH, threeView.frame.size.height);
    scrollView.contentSize = CGSizeMake(0, threeView.frame.origin.y+threeView.frame.size.height+50);
}

#pragma mark - 图片手势响应方法
-(void)imageTap:(UITapGestureRecognizer *)tap {
    
    EditImageViewController *editor = [[EditImageViewController alloc] init];
   // UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:editor];
    editor.imageArray = self.imageArray;
    editor.index = tap.view.tag - 200;
    [editor deleteImage:^(NSInteger index) {
        [self showImage];
    }];
    [self.navigationController pushViewController:editor animated:YES];
}


#pragma mark - ###########################################################################
#pragma mark - 验证码生成
- (void)onTapToGenerateCode:(UITapGestureRecognizer *)tap {
    for (UIView *view in testLabel.subviews) {
        [view removeFromSuperview];
    }
    // @{
    // @name 生成背景色
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
   // NSLog(@"%f=%f=%f",red,green,blue);
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    [testLabel setBackgroundColor:color];

    const int count = 4;
    char data[count];
    for (int x = 0; x < count; x++) {
        int j = '0' + (arc4random_uniform(75));
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
    
    CGSize cSize = CGSizeMake(10.0, 17.0);
    int width = testLabel.frame.size.width / text.length - cSize.width;
    int gao = testLabel.frame.size.height - cSize.height;
    CGPoint point;
    float pX, pY;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int i = 0, count = (int)text.length; i < count; i++) {
        pX = arc4random() % width + testLabel.frame.size.width / text.length * i - 1;
        //pX = testLabel.frame.size.width/5 * i;
        pY = arc4random() % gao-5;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        UILabel *tempLabel = [[UILabel alloc]
                              initWithFrame:CGRectMake(pX, 0,
                                                       testLabel.frame.size.width / 4,
                                                       testLabel.frame.size.height)];
        tempLabel.backgroundColor = [UIColor clearColor];
        
        // 字体颜色
        float red = arc4random() % 100 / 100.0;
        float green = arc4random() % 100 / 100.0;
        float blue = arc4random() % 100 / 100.0;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        tempLabel.textColor = color;
        tempLabel.text = textC;
        [testLabel addSubview:tempLabel];
        [str appendFormat:@"%C",c];
    }
    self.code = str;
    str = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 获取用户信息
-(void)getcar{
      if (self.siChange) {
            if (self.dictionary) {
                [self fuzhi];
            }else{
                [self loadUserData];
            }
        }else{
            [self loadCar];
        }
}

-(void)usercar:(NSDictionary *)dicCar{
  //  NSLog(@"%@",dicCar);
    nameTextField.text = dicCar[@"rname"];
    if ([dicCar[@"sex"] isEqualToString:@"1"]) {
        sexField.text = @"男";
    }else{
        sexField.text = @"女";
    }
    ageTextField.text = [self age:dicCar[@"birth"]];//年龄
    phoneTextField.text = dicCar[@"mobile"];//手
    emailTextField.text = dicCar[@"email"];//邮
    callTextField.text = dicCar[@"phone"];//手机

    brandName.text = dicCar[@"brandName"];//品牌
    brandId = dicCar[@"brand"];
    series.text = dicCar[@"seriesName"];//车系
    seriesId = dicCar[@"series"];
    model.text = dicCar[@"modelName"];//车型
    modelId = dicCar[@"model"];
    
    engine.text = dicCar[@"engineNumber"];//发动
    carNum.text = dicCar[@"carriageNumber"];//车架
    NSArray *arr = [dicCar[@"autosign"] componentsSeparatedByString:@"^"];
    if (arr.count == 2) {
        province.text = arr[0];
        numberPlate.text = arr[1];
    }
}
#pragma mark - 下载用户数据
-(void)loadCar{
    
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUser],[[NSUserDefaults standardUserDefaults] objectForKey:user_id]];
    [HttpRequest GET:url success:^(id responseObject) {
         [self usercar:responseObject];
    } failure:^(NSError *error) {
      
    }];
}

//赋值
-(void)fuzhi{
    ageTextField.text = _dictionary[@"age"];
    nameTextField.text = _dictionary[@"uname"];
    sexField.text = _dictionary[@"sex"];
    
    phoneTextField.text = _dictionary[@"mobile"];//手
    emailTextField.text = _dictionary[@"email"];//邮
    callTextField.text = _dictionary[@"phone"];//
    addressTextField.text = _dictionary[@"address"];
    occupationTextField.text = _dictionary[@"occ"];
    
    brandName.text = self.dictionary[@"brand"];//品牌
    brandId = _dictionary[@"brandId"];
    series.text = self.dictionary[@"series"];//车系
    seriesId = _dictionary[@"seriesId"];
    model.text = self.dictionary[@"model"];//车型
    modelId = _dictionary[@"modelId"];
    engine.text = _dictionary[@"engine"];//发动
    carNum.text = _dictionary[@"carriage"];//车架
    
    if ([self.dictionary[@"sign"] length] > 0) {
        province.text = [self.dictionary[@"sign"] substringToIndex:1];//车牌省份
        numberPlate.text = [self.dictionary[@"sign"] substringFromIndex:1];//车牌省份

    }
    
    dateBuy.text = _dictionary[@"buytime"];//购车
    dateBreakdown.text = _dictionary[@"issuetime"];
    mileage.text = _dictionary[@"mileage"];

    if ([self.dictionary[@"lid"] length] > 0) {
        if ([_dictionary[@"pro"] isEqualToString:_dictionary[@"city"]]) {
            sheng_shi.text = _dictionary[@"city"];
        }else{
            sheng_shi.text = [NSString stringWithFormat:@"%@、%@",_dictionary[@"pro"],_dictionary[@"city"]];
        }
        provinceId = _dictionary[@"pid"];
        _cityId = _dictionary[@"cid"];
        businessId = _dictionary[@"lid"];
        businessName.text = _dictionary[@"lname"];
    }else{
        UIButton *btn = (UIButton *)[scrollView viewWithTag:103];
        [self customClick:btn];
        hideBusinessName.text = _dictionary[@"lname"];
    }

    if ([_dictionary[@"type"] isEqualToString:@"质量问题"]) {
        qualityBtn.selected = YES;
        [self btnClick:qualityBtn];
    }else if ([_dictionary[@"type"] isEqualToString:@"服务问题"]){
       
        serveBtn.selected = YES;
        [self btnClick:serveBtn];
    }else{
        totalBtn.selected = YES;
        [self btnClick:totalBtn];
    }
   
    complainPart.text = _dictionary[@"tsbw"];
    complainServer.text = _dictionary[@"tsfw"];
    describe.text = _dictionary[@"question"];
    details.text = _dictionary[@"content"];
   
    NSString *str = self.dictionary[@"image"];
    
    if (str.length < 1) return;
    NSArray *array = [str componentsSeparatedByString:@"||"];
    for (int i = 0; i < array.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80,80)];
        [self.view insertSubview:imageView belowSubview:scrollView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [_imageArray addObject:image];
                [self showImage];
                [imageView removeFromSuperview];
            }
        }];
    }
}


-( NSString *)age:(NSString *)str{
  
    if (str.length == 0) {
        return @"";
    }
    //将传入时间转化成需要的格式
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromdate=[format dateFromString:str];
    
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    
    //获取当前时间
    NSDate *Time = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: Time];
    NSDate *localeDate = [Time  dateByAddingTimeInterval: interval];
    
    double intervalTime = [localeDate timeIntervalSinceReferenceDate] - [fromDate timeIntervalSinceReferenceDate];
    
    NSInteger iYears = intervalTime/60/60/24/365;

    return [NSString stringWithFormat:@"%ld",iYears];
}

#pragma mark - 修改投诉时加载原投诉图片
-(void)loadUserData{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDetail],self.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {
        self.dictionary = responseObject;
        [self fuzhi];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -提交成功回调函数
-(void)notifacation:(void (^)())block{
    self.updata = block;
}
@end
