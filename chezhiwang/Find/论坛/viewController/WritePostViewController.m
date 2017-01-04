//
//  WritePostViewController.m
//  demo
//
//  Created by bangong on 15/11/6.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "WritePostViewController.h"
#import "WritePostCell.h"
#import "LHAssetPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ForumClassifyTwoController.h"
#import "ForumClassifyViewController.h"
#import "LHEmojiView.h"

@interface WritePostViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UITableView *_tableView;
    UIToolbar * _toobar;
    UIImagePickerController *myPicker;
    
    UIButton *classifyButton;
    UIImageView *classifyButtonImageView;
    UILabel *contentSubLabel;
    
    LHEmojiView *emojiView;//表情键盘
}


@end

@implementation WritePostViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sid = @"";
        self.cid = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    self.contentArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"发表新帖";
    
    [self createLeftItem];
    [self createRightItem];
    [self createTableView];
    [self createTableHeaderView];
    [self createTableFootView];
    [self createToorBar];
    [self createNotification];
}

#pragma mark - 注册通知
-(void)createNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardShow:(NSNotification *)notification{
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    _toobar.frame = CGRectMake(0, HEIGHT-height-49, WIDTH, 49);
    _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-height-49);
//    UIButton *btn = (UIButton *)[_toobar viewWithTag:104];
//    btn.hidden = NO;
}

-(void)keyboardHide:(NSNotification *)notification{
     _toobar.frame = CGRectMake(0, HEIGHT-49, WIDTH, 49);
    _tableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-49);
//    UIButton *btn = (UIButton *)[_toobar viewWithTag:104];
//    btn.hidden = YES;
}

#pragma mark - leftItem
-(void)createLeftItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 40, 20);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)leftItemClick{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - rightItem
-(void)createRightItem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 40, 20);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    [self.view endEditing:YES];
    
    if (self.sid == nil || self.cid == nil) {
        [LHController alert:@"请选择论坛"];
        return;
    }
    if (_titleTextField.text.length > 30) {
        [LHController alert:@"标题不能大于30个汉字"];
    }else if (![LHController judegmentSpaceChar:_titleTextField.text]){
        [LHController alert:@"标题不能为空"];
    }
    else if ([LHController judegmentSpaceChar:_contentTextView.text] == NO){
        [LHController alert:@"内容不能为空"];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[CZWManager manager].userID forKey:@"uid"];
        [dict setObject:[CZWManager manager].userName forKey:@"username"];
        [dict setObject:_titleTextField.text forKey:@"title"];
        [dict setObject:_contentTextView.text forKey:@"content"];
        [dict setObject:self.sid forKey:@"sid"];
        [dict setObject:self.cid forKey:@"cid"];
        
        NSString *desc = [self.contentArray componentsJoinedByString:@"|"];
        [dict setObject:desc forKey:@"imgdesc"];
        [self submitData:dict];

    }
}

#pragma mark - 发布帖子
-(void)submitData:(NSDictionary *)dict{
  
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak __typeof(self)weakSelf = self;
    [HttpRequest POST:[URLFile urlStringForNewTopic] parameters:dict images:_dataArray success:^(id responseObject) {

        if (responseObject[@"success"]) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }else{
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"上传失败";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            });
        }


    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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

#pragma mark - uitableView
-(void)createTableView{
    CGRect frame  = self.view.frame;
    frame.size.height -= 49;
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

-(void)createTableHeaderView{
    if (self.cid.length == 0 && self.sid.length == 0) return;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    _tableView.tableHeaderView = view;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    bgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    [view addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(classifyClick)];
    [bgView addGestureRecognizer:tap];
    
    CGSize size =[@"请选择论坛" boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    classifyButton = [LHController createButtnFram:CGRectMake(10, 10, size.width, 20) Target:self Action:@selector(classifyClick) Text:@"请选择论坛"];
    [classifyButton setTitleColor:colorLightBlue forState:UIControlStateNormal];
    classifyButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:classifyButton];
    
    classifyButtonImageView = [LHController createImageViewWithFrame:CGRectMake(classifyButton.frame.size.width+5, 3, 14, 14) ImageName:@"news_jiantou"];
    [classifyButton addSubview:classifyButtonImageView];
    
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 50, WIDTH-20, 30)];
    _titleTextField.placeholder = @"输入标题（最多30个字）";
    _titleTextField.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    [view addSubview:_titleTextField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 84, WIDTH, 1)];
    line.backgroundColor = colorLineGray;
    [view addSubview:line];
}

#pragma mark - 选择论坛类型按钮响应方法
-(void)classifyClick{
    
    if (self.classify == forumClassifyBrand) {
        ForumClassifyTwoController *classify = [[ForumClassifyTwoController alloc] init];
        [classify returnCid:^(NSString *cid, NSString *title) {
            self.cid = cid;
            [self changeClassifyButtonTitle:title];
        }];
        [self.navigationController pushViewController:classify animated:YES];

    }else{
        ForumClassifyViewController *classify = [[ForumClassifyViewController alloc] init];
        [classify returnSid:^(NSString *sid, NSString *titile) {
            self.sid = sid;
            [self changeClassifyButtonTitle:titile];
        }];
        [self.navigationController pushViewController:classify animated:YES];
    }
}


-(void)changeClassifyButtonTitle:(NSString *)text{
     CGSize size =[text boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[LHController setFont]-3]} context:nil].size;
    [classifyButton setTitle:text forState:UIControlStateNormal];
    classifyButton.frame = CGRectMake(10, 10, size.width, 20);
    classifyButtonImageView.frame = CGRectMake(classifyButton.frame.size.width+5, 3, 14, 14);
}

//选择论坛类型
-(void)createTableFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    _tableView.tableFooterView = view;
   
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, WIDTH-20, 170)];
    _contentTextView.backgroundColor  = colorLineGray;
    _contentTextView.font = [UIFont systemFontOfSize:[LHController setFont]-2];
    _contentTextView.delegate = self;
    [view addSubview:_contentTextView];
    
    contentSubLabel = [LHController createLabelWithFrame:CGRectMake(3, 5, 140, 20) Font:[LHController setFont]-2 Bold:NO TextColor:colorDeepGray Text:@"输入内容"];
    [_contentTextView addSubview:contentSubLabel];
}

#pragma mark - createToorBar
-(void)createToorBar{
    _toobar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    [_toobar setBarStyle:UIBarStyleDefault];
 
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *imageArray = @[@"write_photo",@"write_image",@"srite_face",@"",@"write_keyboard"];
    for (int i = 0; i < 5; i  ++) {
        if (i != 3) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(2, 5, 30, 25);
           // btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 100+i;
            UIImageView *iamgeView = [LHController createImageViewWithFrame:CGRectMake(0, 0, 25, 25) ImageName:imageArray[i]];
            if (i == 4) {
                iamgeView.frame = CGRectMake(0, 0, 40, 25);
                btn.frame = CGRectMake(0, 0, 40, 25);
//                btn.hidden = YES;
            }
            iamgeView.center = CGPointMake(btn.frame.size.width/2, btn.frame.size.height/2);
            [btn addSubview:iamgeView];
           
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
            [array addObject:doneBtn];
        }else{
            [array addObject:btnSpace];
        }
    }
   [_toobar setItems:array];
    //[_textView setInputAccessoryView:topView];
    [self.view addSubview:_toobar];
}

-(void)dismissKeyBoard:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            if (myPicker == nil) {
                myPicker = [[UIImagePickerController alloc] init];
                myPicker.delegate = self;
                myPicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
                myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:myPicker animated:YES completion:nil];
            }
            break;
        }
            
        case 101:
        {
            LHAssetPickerController *picker = [[LHAssetPickerController alloc] init];
            picker.maxNumber = 20-_dataArray.count;
            [picker getAssetArray:^(NSArray *assetArray) {
                for (ALAsset *asset in assetArray) {
                    
                    [_dataArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage]];
                    [self.contentArray addObject:@""];
                }
                [_tableView reloadData];
            }];
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
            
        case 102:
        {
            btn.selected = YES;
            [_contentTextView resignFirstResponder];
            if (btn.selected) {
                if (emojiView == nil) {
                    emojiView = [[LHEmojiView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 240)];
                    [emojiView returnEmojiName:^(NSString *name) {
                     
                        NSString *text = [NSString stringWithFormat:@"%@%@",_contentTextView.text,[NSString stringWithFormat:@"[%@]",name]];
                        _contentTextView.text = text;
                    }];
                }
                _contentTextView.inputView = emojiView;
               
            }else{
                _contentTextView.inputView = nil;
            
            }
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
               [_contentTextView becomeFirstResponder];
            });
            
            break;
        }
            
        case 104:
        {
            [_contentTextView resignFirstResponder];
            _contentTextView.inputView = nil;
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [_contentTextView becomeFirstResponder];
            });
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WritePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"writePostCell"];
    if (!cell) {
        cell = [[WritePostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"writePostCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell deleteCell:^(UIImage *cellAsset, WritePostCell *myCell) {
        [_dataArray removeObject:cellAsset];
        
        NSIndexPath *path = [_tableView indexPathForCell:myCell];
        [self.contentArray removeObjectAtIndex:path.row];
        [_tableView reloadData];
    }];
    
    [cell returnConent:^(NSString *content, UIImage *image, WritePostCell *myCell) {
        NSIndexPath *path = [_tableView indexPathForCell:myCell];
        [self.contentArray insertObject:content atIndex:path.row];
        [self.contentArray removeObjectAtIndex:path.row+1];
        
    }];
    cell.describe = self.contentArray[indexPath.row];
    cell.asset = _dataArray[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark - imagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_dataArray.count < 20) {
        [_dataArray addObject:image];
        [self.contentArray addObject:@""];
    }else{
        
    }
    
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [_tableView reloadData];
  // ALAsset *aa = [[ALAsset alloc]]
   
    [myPicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if (textView.text.length == 0) {
        contentSubLabel.hidden = NO;
    }else{
        contentSubLabel.hidden = YES;
    }
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
