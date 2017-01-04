//
//  MyCarViewController.m
//  auto
//
//  Created by bangong on 15/7/23.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "MyCarViewController.h"
#import "MyCarCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MyCarModel.h"
#import "CZWCardChooseViewController.h"

#import "MyCardChooseViewController.h"

@interface MyCarViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITableView *_tabelView;
    UIImagePickerController *myPicker;
}
@property (nonatomic,strong) NSArray *dataArray;

@end


@implementation MyCarViewController


#pragma mark - 下载用户数据
-(void)loadCar{

    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUser],[CZWManager manager].userID];
  [HttpRequest GET:url success:^(id responseObject) {
      if (responseObject) {

          for (int i = 0; i < _dataArray.count; i ++) {
              NSArray *arr = _dataArray[i];

                  for (int j = 0; j < arr.count; j ++) {
                      MyCarModel *model = arr[j];
                      model.value = responseObject[model.valueKey];
                      if (i == 1 && j == 2) {
                          if (!([model.value isEqualToString:@"男"] && ![model.value isEqualToString:@"女"])) {
                              model.value = [model.value integerValue] == 1?@"男":@"女";
                          }
                      }
                  }
          }
           [[CZWManager manager] updateIconUrl:responseObject[@"img"]];
          [_tabelView reloadData];

      }

  } failure:^(NSError *error) {
      
  }];
}

-(void)createDataArray{

    _dataArray = @[
                     @[
                         [MyCarModel initWithName:@"头像" value:@"" valueKey:@"img" submitKey:@"" placeholder:@""]
                         ],
                     @[
                         [MyCarModel initWithName:@"用户名" value:@"" valueKey:@"uname" submitKey:@"" placeholder:@""],
                         [MyCarModel initWithName:@"真实姓名" value:@"" valueKey:@"rname" submitKey:@"realname" placeholder:@"请输入您的真实姓名"],
                         [MyCarModel initWithName:@"性别" value:@"" valueKey:@"sex" submitKey:@"gender" placeholder:@"请选择您的性别"],
                         [MyCarModel initWithName:@"生日" value:@"" valueKey:@"birth" submitKey:@"birth" placeholder:@"请选择您的生日"]
                         ],
                     @[
                         [MyCarModel initWithName:@"手机号" value:@"" valueKey:@"mobile" submitKey:@"mobile" placeholder:@"请输入您的手机号码"],
                         [MyCarModel initWithName:@"电子邮箱" value:@"" valueKey:@"email" submitKey:@"email" placeholder:@"请输入您的电子邮箱"],
                         [MyCarModel initWithName:@"固定电话" value:@"" valueKey:@"phone" submitKey:@"telephone" placeholder:@"请输入您的固定电话"],
                         [MyCarModel initWithName:@"QQ" value:@"" valueKey:@"qq" submitKey:@"qq" placeholder:@"请输入您的QQ"]
                         ],
                     @[
                         [MyCarModel initWithName:@"爱车" value:@"" valueKey:@"modelName" submitKey:@"" placeholder:@"请选择您的车型"],
                         [MyCarModel initWithName:@"地区" value:@"" valueKey:@"city" submitKey:@"" placeholder:@"请选择您所在地区"]
                         ]
                     ];

    MyCarModel *model = _dataArray[1][0];
    model.isEnable = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人信息";

    [self createTableView];
    [self createDataArray];
    [_tabelView reloadData];
    
    [self loadCar];
}


#pragma mark - item
-(void)createTableView{

    _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tabelView];
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
        MyCarIconCell *iconCell = [tableView dequeueReusableCellWithIdentifier:@"iconCell"];
        if (!iconCell) {
            iconCell = [[MyCarIconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iconCell"];
        }
        iconCell.model = _dataArray[indexPath.section][indexPath.row];

        return iconCell;
    }

        MyCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
        if (!cell) {
            cell = [[MyCarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        }

        MyCarModel *model = _dataArray[indexPath.section][indexPath.row];

    cell.model = model;
    return cell;
}



#pragma mark - UItableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) return 90;

    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCarModel *model = _dataArray[indexPath.section][indexPath.row];
    if (model.isEnable == NO) {
        return;
    }

    if (indexPath.section == 0) {
        [self imageClick];
       return;

    }else if (indexPath.section == 3){

        MyCardChooseViewController *vc = [[MyCardChooseViewController alloc] initWithStyle:UITableViewStylePlain];
        if (indexPath.row == 0) {
            vc.isShowSection = YES;
            vc.isIndex = YES;
            vc.type = MyCardChooseTypeBrand;
        }else if (indexPath.row == 1){
            
            vc.type = MyCardChooseTypeProvince;
        }
        vc.endChoose = ^(NSString *title){
            model.value = title;
            [_tabelView reloadData];
        };

        [self.navigationController pushViewController:vc animated:YES];

        return;
    }

    cardChooseType type = cardChooseTypeName;
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            type = cardChooseTypeName;
        }else if (indexPath.row == 2){
            type = cardChooseTypeSex;
        }else if (indexPath.row == 3){
            type = cardChooseTypeBirth;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            type = cardChooseTypePhoneNumber;
        }
        else if (indexPath.row == 1) {
            type = cardChooseTypeEmail;
        }else if (indexPath.row == 2){
            type = cardChooseTypeTelephone;
        }else if (indexPath.row == 3){
            type = cardChooseTypeQQ;
        }
    }

    CZWCardChooseViewController *choose = [[CZWCardChooseViewController alloc] init];
    choose.choose = type;
    choose.model = model;
    //__weak __typeof(self)weakSelf = self;
    [choose success:^(NSString *updateKey, NSString *value) {
        [_tabelView reloadData];
    }];
    [self.navigationController pushViewController:choose animated:YES];

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
        myPicker.navigationBar.tintColor = [UIColor whiteColor];
        myPicker.navigationBar.barStyle = UIBarStyleBlack;
        myPicker.navigationBar.barTintColor = colorLightBlue;
        myPicker.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:PT_FROM_PX(27)],NSForegroundColorAttributeName:[UIColor whiteColor]};
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



#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self postImage:image];
    [myPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)postImage:(UIImage *)image{

    __weak __typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:[URLFile urlStringForUploadAvatar],[CZWManager manager].userID];
    [HttpRequest POSTImage:image url:url fileName:@"icon" parameters:nil success:^(id responseObject) {
        if (responseObject[@"success"]) {
            [LHController alert:responseObject[@"success"]];
            [weakSelf loadCar];
        }else{
            [LHController alert:responseObject[@"error"]];
        }
    } failure:^(NSError *error) {
        [LHController alert:@"上传失败"];
    }];
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
