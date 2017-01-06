
//
//  ComplainViewController.m
//  chezhiwang
//
//  Created by bangong on 16/11/9.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "ComplainViewController.h"

#import "ComplainSectionModel.h"

#import "ComplainTableViewCell.h"
#import "BrandTableViewCell.h"
#import "ComplainImageCell.h"
#import "ComplainBusinessCell.h"
#import "ComplainTypeCell.h"
#import "ComplainContentCell.h"

#import "ComplainSectionHeaderView.h"

#import "ComplainTableFootView.h"


@interface ComplainViewController ()<UITableViewDelegate,UITableViewDataSource,ComplainImageCellDelegate,ComplainTypeCellDelegate,ComplainBusinessCellDelegate,BrandTableViewCellDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@property (nonatomic,weak)ComplainBusinessModel *businessModel;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary;

@end

@implementation ComplainViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我要投诉";
    _dataDictionary = [[NSMutableDictionary alloc] init];

    [self createLeftItemBack];
    [self setData];
    [self createTableView];
    [self keyboardNotificaion];
    if ([self.Cpid integerValue] > 0) {
         [self loadDataUpdate];
    }else{
        [self loadUserInfo];
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

#pragma mark - 下载用户数据
-(void)loadUserInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUser],[CZWManager manager].userID];

    [HttpRequest GET:url success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (int i  = 0; i < _dataArray.count; i ++) {
            if (i != 0 && i != 2) {
                continue;
            }
            ComplainSectionModel *sectionModel = _dataArray[i];
            for (int j = 0; j < sectionModel.rowModels.count; j ++) {
                NSObject *rowModel = sectionModel.rowModels[j];
                if (i == 0) {
                    ComplainModel *model = (ComplainModel *)rowModel;
                    if (j == 0) {
                        model.value = responseObject[@"rname"];
                    }else if (j == 1){

                        model.value = [self age:responseObject[@"birth"]];//年龄
                    }else if (j == 2){
                        model.value = [responseObject[@"sex"] isEqualToString:@"1"]?@"男":@"女";
                    }else if (j == 3){
                        model.value = responseObject[@"mobile"];
                    }

                }else if (i == 2){
                    if (j == 0) {
                        ComplainBrandModel *brandModel = (ComplainBrandModel *)rowModel;
                        brandModel.brandName = responseObject[@"brandName"];//品牌
                        brandModel.BrandId = responseObject[@"brand"];
                        brandModel.seriesName = responseObject[@"seriesName"];//车系
                        brandModel.SeriesId = responseObject[@"series"];
                        brandModel.modelName = responseObject[@"modelName"];//车型
                        brandModel.ModelId = responseObject[@"model"];

                        _businessModel.seriesId = responseObject[@"series"];

                    }else if(j <= 3){
                         ComplainModel *model = (ComplainModel *)rowModel;
                       if (j == 1){
                            model.value = responseObject[@"engineNumber"];//发动
                        }else if (j == 2){
                            model.value = responseObject[@"carriageNumber"];//车架
                        }else if (j == 3){
                            model.value = responseObject[@"autosign"];//车牌省份
                        }
                    }
                }
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)loadDataUpdate{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForDetail],self.Cpid];
    [HttpRequest GET:url success:^(id responseObject) {
     [MBProgressHUD hideHUDForView:self.view animated:YES];

       [weakSelf setDateInfo:responseObject];
       [_tableView reloadData];

    } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)setDateInfo:(NSDictionary *)responseObject{
    for (int i  = 0; i < _dataArray.count; i ++) {
        ComplainSectionModel *sectionModel = _dataArray[i];
        for (int j = 0; j < sectionModel.rowModels.count; j ++) {
            NSObject *rowModel = sectionModel.rowModels[j];
            if (i == 0) {
                ComplainModel *model = (ComplainModel *)rowModel;
                if (j == 0) {
                    model.value = responseObject[@"uname"];
                }else if (j == 1){

                    model.value = responseObject[@"age"];//年龄
                }else if (j == 2){
                    model.value = responseObject[@"sex"];
                }else if (j == 3){
                    model.value = responseObject[@"mobile"];
                }

            }else if(i == 1){
                ComplainModel *model = (ComplainModel *)rowModel;
                if (j == 0) {
                    model.value = responseObject[@"email"];
                }else if (j == 1){
                    model.value = responseObject[@"phone"];
                }else if (j == 2){
                    model.value = responseObject[@"address"];
                }else if (j == 3){
                    model.value = responseObject[@"occ"];
                }

            }else if (i == 2){
                if (j == 0) {
                    ComplainBrandModel *brandModel = (ComplainBrandModel *)rowModel;
                    brandModel.brandName = responseObject[@"brand"];//品牌
                    brandModel.BrandId = responseObject[@"brandId"];
                    brandModel.seriesName = responseObject[@"series"];//车系
                    brandModel.SeriesId = responseObject[@"seriesId"];
                    brandModel.modelName = responseObject[@"model"];//车型
                    brandModel.ModelId = responseObject[@"modelId"];
                    [brandModel resetSelected];
                }else if(j <= 6){
                    ComplainModel *model = (ComplainModel *)rowModel;
                    if (j == 1){
                        model.value = responseObject[@"engine"];//发动
                    }else if (j == 2){
                        model.value = responseObject[@"carriage"];//车架
                    }else if (j == 3){
                        NSMutableString *text = [responseObject[@"sign"] mutableCopy];
                        if (text.length > 0) {
                            [text insertString:@"^" atIndex:1];
                        }
                        model.value = text;//车牌省份
                    }else if (j == 4){
                        model.value = responseObject[@"buytime"];//购车
                    }else if (j == 5){
                        model.value = responseObject[@"issuetime"];//问题时间
                    }else if (j == 6){
                        model.value = responseObject[@"mileage"];//里程
                    }
                }else if (j == 7){

                        ComplainBusinessModel *businessModel = (ComplainBusinessModel *)rowModel;
                        businessModel.province = responseObject[@"pro"];
                        businessModel.city = responseObject[@"city"];
                        businessModel.businessValue = responseObject[@"lname"];
                        businessModel.pid = responseObject[@"pid"];
                        businessModel.cid = responseObject[@"cid"];
                        businessModel.lid = responseObject[@"lid"];
                        businessModel.seriesId = responseObject[@"seriesId"];
                    if (businessModel.lid.integerValue == 0) {
                        businessModel.custom = YES;
                    }

                }else if (j == 8){
                        ComplainImageModel *imageModel = (ComplainImageModel *)rowModel;
                        NSString *str = responseObject[@"image"];
                        NSArray *array = [str componentsSeparatedByString:@"||"];
                        imageModel.imageUrlArray = array;

                }
            }else if (i == 3){

                    if (j == 0) {
                        ComplainTypeModel *typeModel = sectionModel.rowModels[j];
                        typeModel.type = responseObject[@"type"];
                        typeModel.qualityValue =  responseObject[@"tsbw"];
                        typeModel.serveValue = responseObject[@"tsfw"];
                    }else if (j == 1){
                        ComplainModel *model = sectionModel.rowModels[j];
                         model.value = responseObject[@"question"];
                    }else if (j == 2){
                        ComplainModel *model = sectionModel.rowModels[j];
                        model.value = responseObject[@"content"];

                    }
            }
        }
    }
}

-(void)keyboardShow:(NSNotification *)notification
{
    //读取键盘高度
    CGFloat  height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect frame = self.view.frame;
    frame.size.height -= height;
    _tableView.frame = frame;
}

-(void)keyboardHide:(NSNotification *)notification
{
    _tableView.frame  = self.view.frame;
}


- (void)setData{
    _dataDictionary = [[NSMutableDictionary alloc] init];
    _dataArray =[ComplainSectionModel dataArray];

    ComplainSectionModel *sectionModel = _dataArray[2];
    _businessModel = sectionModel.rowModels[7];
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];

    YYLabel *headerLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    headerLabel.textColor = colorLightGray;
    headerLabel.backgroundColor = colorBackGround;
    headerLabel.font = [UIFont systemFontOfSize:12];
    headerLabel.numberOfLines = 0;
    headerLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    headerLabel.text = @"  为了我们能及时与您取得联系，了解到更详细信息，请您认真填写以下内容";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"  为了我们能及时与您取得联系，了解到更详细信息，请您认真填写以下内容"];
    att.yy_font = [UIFont systemFontOfSize:12];
    att.yy_color = colorLightGray;
    NSMutableAttributedString *chment = [NSMutableAttributedString yy_attachmentStringWithContent:[UIImage imageNamed:@"auto_common_提示"] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(20, 20) alignToFont:att.yy_font alignment:YYTextVerticalAlignmentCenter];
    [att insertAttributedString:chment atIndex:0];
    headerLabel.attributedText = att;
    [headerLabel sizeToFit];
    _tableView.tableHeaderView = headerLabel;

    ComplainTableFootView *footView = [[ComplainTableFootView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 400)];
    _tableView.tableFooterView = footView;
    footView.backgroundColor = [UIColor clearColor];
    __weak __typeof(self)weakSelf = self;
    [footView submit:^(BOOL isEqual) {
        [weakSelf.view endEditing:YES];
        if ([weakSelf testInformation:isEqual]) {
            [weakSelf postData:weakSelf.dataDictionary];
        }
    }];
}

#pragma mark - 提交数据
-(void)postData:(NSDictionary *)dic{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在提交...";
    hud.detailsLabelText = nil;
    ComplainSectionModel *sectionModel = _dataArray[2];
    ComplainImageModel *imageModel = sectionModel.rowModels[8];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest POST:[URLFile urlStringForProgressComplain] parameters:dic images:imageModel.imageArray success:^(id responseObject) {

        if (responseObject[@"success"]) {
            hud.mode = MBProgressHUDModeText;
             hud.labelText = nil;
            hud.detailsLabelText = responseObject[@"success"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            hud.mode = MBProgressHUDModeText;
             hud.labelText = nil;
            hud.detailsLabelText = responseObject[@"error"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }

    } failure:^(NSError *error) {

        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"亲！网速不太理想，请稍后提交";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

- (BOOL)testInformation:(BOOL)isEqual{
    [self setDataInfo];
    //    NSArray *keyArray = @[@"Cpid",@"Name",@"Age",@"Mobile",@"Email",@"Telephone",@"Address",
    //                          @"Occupation",@"Sex",@"Autoname",@"Autopart",@"Autostyle",@"BrandId",
    //                          @"SeriesId",@"ModelId",@"Engine_Number",@"Carriage_Number",@"AutoSign",
    //                          @"Buyautotime",@"Questiontime",@"Buyname",@"Disname",@"mileage",
    //                          @"Disid",@"Image",@"Question",@"Content",@"C_Tslx",@"C_Tsbw",@"C_Tsfw",
    //                          @"User_ID",@"origin",@"again"];
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Name"]] == NO) {
        [LHController alert:@"名字不能为空"];
        return NO;
    }
    if ([_dataDictionary[@"Age"] integerValue] < 10){
        [LHController alert:@"年龄小于10岁"];
        return NO;

    }
    if ([_dataDictionary[@"Sex"] length] == 0){
        [LHController alert:@"请选择性别"];
        return NO;
    }

    if ([LHController judegmentSpaceChar:_dataDictionary[@"Mobile"]] == NO){
        [LHController alert:@"手机号码不能为空"];
        return NO;

    }
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Autoname"]] == NO){
        [LHController alert:@"品牌不能为空"];
        return NO;

    }
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Autopart"]] == NO){
        [LHController alert:@"车系不能为空"];
        return NO;

    }
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Autostyle"]] == NO) {
        [LHController alert:@"车型不能为空"];
        return NO;

    }
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Engine_Number"]] == NO){
        [LHController alert:@"发动机号不能为空"];
        return NO;

    }
    if ([LHController judegmentSpaceChar:_dataDictionary[@"Carriage_Number"]] == NO) {
        [LHController alert:@"车架号不能为空"];
        return NO;

    }

    NSArray *arr = [_dataDictionary[@"AutoSign"] componentsSeparatedByString:@"^"];
    if (arr.count < 2) {
        [LHController alert:@"请输入车牌号"];
        return NO;
    }
    if (![LHController judegmentCarNum:arr[1]] || ![LHController judegmentSpaceChar:arr[1]]) {
        [LHController alert:@"车牌号只能是6位以内字母和数字组成的"];
        return NO;
    }

    if ([_dataDictionary[@"Buyautotime"] length] == 0){
        [LHController alert:@"购车日期不能为空"];
        return NO;

    }
    if ([_dataDictionary[@"Questiontime"] length] == 0){
        [LHController alert:@"出现故障日期不能为空"];
        return NO;

    }
    if (![NSString isDigital:_dataDictionary[@"mileage"]]){
        [LHController alert:@"行驶里程只能为数字，请重新输入"];
        return NO;
    }

    if ([LHController judegmentSpaceChar:_dataDictionary[@"Buyname"]] == NO && [LHController judegmentSpaceChar:_dataDictionary[@"Disname"]] == NO){
        [LHController alert:@"经销商名称不能为空"];
        return NO;
    }

    if ([_dataDictionary[@"C_Tsbw"] length] == 0 && [_dataDictionary[@"C_Tsfw"] length] == 0){
        [LHController alert:@"请选择投诉类型"];
        return NO;
    }

    if([LHController judegmentSpaceChar:_dataDictionary[@"Question"]] == NO){
        [LHController alert:@"问题描述不能为空"];
        return NO;

    }
    if (![LHController judegmentChar:_dataDictionary[@"Question"]]){
        [LHController alert:@"问题描述只能包含汉字、数字、字母、标点符号"];
        return NO;
    }
    if ([_dataDictionary[@"Question"] length] > 24) {
        [LHController alert:@"问题描述不能大于24个汉字"];
        return NO;
    }

    if ([LHController judegmentSpaceChar:_dataDictionary[@"Content"]] == NO){
        [LHController alert:@"投诉详情不能为空"];
        return NO;
    }

    if (isEqual == NO) {
        [LHController alert:@"验证码不正确"];
        return NO;

    }

    return YES;
}

- (void)setDataInfo{
      if ([_Cpid integerValue] > 0) {
         _dataDictionary[@"Cpid"] = _Cpid;
    }else{
        _dataDictionary[@"Cpid"] = @"0";

    }
    _dataDictionary[@"User_ID"] = [CZWManager manager].userID;
    _dataDictionary[@"origin"] = appOrigin;
    if (_again) {
        _dataDictionary[@"again"] = @"again";
    }

    for (int i = 0; i < _dataArray.count; i ++) {
        ComplainSectionModel *sectionModel = _dataArray[i];
        if (i == 0 || i == 1) {
            for (ComplainModel *model in sectionModel.rowModels) {
                _dataDictionary[model.key] = model.value;
            }
        }else if (i == 2) {
            for (int j = 0; j < sectionModel.rowModels.count; j ++) {

                if (j == 0) {
                    ComplainBrandModel *brandModel = sectionModel.rowModels[j];
                    _dataDictionary[brandModel.brandIdKey] = brandModel.BrandId;
                    _dataDictionary[brandModel.brandNameKey] = brandModel.brandName;
                    _dataDictionary[brandModel.seriesIdKey] = brandModel.SeriesId;
                    _dataDictionary[brandModel.seriesNameKey] = brandModel.seriesName;
                    _dataDictionary[brandModel.modelIdKey] = brandModel.ModelId;
                    _dataDictionary[brandModel.modelNameKey] = brandModel.modelName;

                }else if (j > 0 && j <= 6){

                    ComplainModel *model = sectionModel.rowModels[j];
                    _dataDictionary[model.key] = model.value;
                }else if (j == 7){
                    ComplainBusinessModel *businessModel = sectionModel.rowModels[j];
                    if (businessModel.custom == NO) {
                        _dataDictionary[businessModel.businessIdKey] = businessModel.businessId;
                        _dataDictionary[businessModel.businessKey] = businessModel.businessValue;
                    }else{
                        _dataDictionary[businessModel.businessCustomKey] = businessModel.businessValue;
                    }
                }
            }
        }else if (i == 3) {
            for (int j = 0; j < sectionModel.rowModels.count; j ++) {
                if (j == 0) {
                    ComplainTypeModel *typeModel = sectionModel.rowModels[j];
                    _dataDictionary[typeModel.key] = typeModel.type;
                    _dataDictionary[typeModel.qualityKey] = typeModel.qualityValue;
                    _dataDictionary[typeModel.servekey] = typeModel.serveValue;

                }else{
                    ComplainModel *model = sectionModel.rowModels[j];
                    self.dataDictionary[model.key] = model.value;
                }
            }
        }
        
    }
}




#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ComplainSectionModel *sectionModel = _dataArray[section];
    return sectionModel.rowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplainSectionModel *sectionModel = _dataArray[indexPath.section];
    id rowModel = sectionModel.rowModels[indexPath.row];

    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //选择车型
            BrandTableViewCell *brandCell = [tableView dequeueReusableCellWithIdentifier:@"brandCell"];
            if (!brandCell) {
                brandCell = [[BrandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brandCell"];
            }
            brandCell.delegate = self;
            brandCell.parentViewController = self;
            brandCell.brandModel = rowModel;
            return brandCell;

        }else if (indexPath.row == 3) {
            //车牌号
            ComplainLicenseplateCell *licenseplateCell = [tableView dequeueReusableCellWithIdentifier:@"licenseplateCell"];
            if (!licenseplateCell) {
                licenseplateCell = [[ComplainLicenseplateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"licenseplateCell"];
            }
            licenseplateCell.parentViewController = self;
            licenseplateCell.model = rowModel;
            return licenseplateCell;

        }else if (indexPath.row == 7){
            //经销商
            ComplainBusinessCell *businessCell = [tableView dequeueReusableCellWithIdentifier:@"businessCell"];
            if (!businessCell) {
                businessCell = [[ComplainBusinessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"businessCell"];
            }
            businessCell.delegate = self;
            businessCell.parentViewController = self;
            businessCell.businessModel = rowModel;
            self.businessModel = rowModel;
            return businessCell;

        }else if (indexPath.row == 8){
            //图片选择
            ComplainImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            if (!imageCell) {
                imageCell = [[ComplainImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageCell"];
            }
            imageCell.parentVC = self;
            imageCell.delegate = self;
            imageCell.imageModel = rowModel;
            return imageCell;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            ComplainTypeCell *typeCell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
            if (!typeCell) {
                typeCell = [[ComplainTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
            }
            typeCell.delegate = self;
            typeCell.parentViewController = self;
            typeCell.typeModel = rowModel;
            return typeCell;
        }else{

            ComplainContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"contentCell"];
            if (!contentCell) {
                contentCell = [[ComplainContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contentCell"];
            }
            contentCell.model = rowModel;
            return contentCell;
        }
    }

    ComplainTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
    if (!commonCell) {
        commonCell = [[ComplainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commonCell"];
    }
    commonCell.parentViewController = self;
    commonCell.model = rowModel;
    commonCell.sectionModel = sectionModel;
    return commonCell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ComplainSectionModel *sectionModel = _dataArray[indexPath.section];
    NSObject *rowModel = sectionModel.rowModels[indexPath.row];
    if ([rowModel isKindOfClass:[ComplainModel class]]) {
        return ((ComplainModel *)rowModel).cellHeight;

    }else if ([rowModel isKindOfClass:[ComplainTypeModel class]]) {
        return ((ComplainTypeModel *)rowModel).cellHeight;

    }else if ([rowModel isKindOfClass:[ComplainBrandModel class]]) {
        return ((ComplainBrandModel *)rowModel).cellHeight;

    }else if ([rowModel isKindOfClass:[ComplainImageModel class]]) {
        return ((ComplainImageModel *)rowModel).cellHeight;

    }else if ([rowModel isKindOfClass:[ComplainBusinessModel class]]) {
        return ((ComplainBusinessModel *)rowModel).cellHeight;

    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    ComplainSectionModel *sectionModel = _dataArray[section];
    return sectionModel.viewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ComplainSectionModel *sectionModel = _dataArray[section];
    if (section == 1) {
        ComplainTwoSectionHeaderView *twoHeaderView = [[ComplainTwoSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        twoHeaderView.model = sectionModel;
        return twoHeaderView;
    }

    ComplainSectionHeaderView *headerView = [[ComplainSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    headerView.model = sectionModel;
    return headerView;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB_color(240, 240, 240, 1);
    return view;
}

#pragma mark - ComplainImageCellDelegate
- (void)updateCellheight{
    [_tableView reloadData];
}

//ComplainTypeCellDelegate
- (void)updateLayout{
   [_tableView reloadData];
}

///ComplainBusinessCellDelegate
- (void)updateCellHeight{
    [_tableView reloadData];
}

///BrandTableViewCellDelegate
- (void)updateBrandModel:(ComplainBrandModel *)brandModel{
    self.businessModel.seriesId = brandModel.SeriesId;
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
