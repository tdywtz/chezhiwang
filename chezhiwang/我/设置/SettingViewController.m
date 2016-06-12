//
//  SettingViewController.m
//  auto
//
//  Created by bangong on 15/6/10.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "SettingViewController.h"
#import "TakeViewController.h"
#import "AboutViewController.h"
#import "AgreementViewController.h"

#define SPACE 48
#define AREA @"area"
//#define B 17
#define  H 40

@interface SettingViewController ()<UIAlertViewDelegate>
{
    UIView *bgView;
    UIView *clearView;
    UIView *areaView;
    UILabel *huancun;
    
    CGFloat B;
 
}
@property (nonatomic,strong) NSArray *array;
@end

@implementation SettingViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    B = [LHController setFont];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.navigationItem.title = @"设置";
    [self createLeftItem];
    //[self createUIVeiw];
    [self createBtn];
    //[self creaBGView];
    //[self createArea];
    
    [self getText];
}

-(void)getText{
    long long a = [self fileSizeAtPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/user.db"]];
    NSInteger m =  [[SDImageCache sharedImageCache] getSize];
    CGFloat n = a*8/1024/1024 + m*8.0/1024/1024*(1000000.0/(m+1000000));
    if (n < 0) {
        n = 0;
    }
    huancun.text = [NSString stringWithFormat:@"%0.1f MB",n];
    //NSLog(@"%llu",a)
}

    //单个文件的大小
    - (long long) fileSizeAtPath:(NSString*) filePath{
        //NSLog(@"%@",filePath);
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath]){
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
        return 0;
    }



-(void)createBtn{
    NSArray *array = @[@"清除缓存",@"浏览记录",@"用户服务使用协议",@"关于我们"];
    
    for (int i = 0;  i < array.count; i ++) {
        UIButton *btn = [LHController createButtnFram:CGRectMake(0, 30+SPACE*i, WIDTH, SPACE) Target:self Action:@selector(btnClick:) Text:nil];
        btn.tag = 10+i;
        btn.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            huancun = [LHController createLabelWithFrame:CGRectMake(LEFT+90, 0, 100, btn.frame.size.height) Font:B Bold:NO TextColor:nil Text:nil];
            [btn addSubview:huancun];
        }
        
        if (i < 2 || i == 3) {
            UIView *fg = [self createWhiteFrame:CGRectMake(LEFT, btn.frame.size.height-1, WIDTH-LEFT, 1)];
            [btn addSubview:fg];
        }
        if (i == 3) {
            btn.frame = CGRectMake(0, 30+SPACE*i+30, WIDTH, SPACE);
        }
        if (i == 3) {
            UIView *viv = [[UIView alloc] initWithFrame:CGRectMake(0, 30+SPACE*i+30, WIDTH, SPACE)];
            viv.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:viv];
            
            UILabel *label = [LHController createLabelWithFrame:CGRectMake(LEFT,0 , 100, viv.frame.size.height) Font:B Bold:NO TextColor:nil Text:@"版本号"];
            [viv addSubview:label];
            
            NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
            NSString *versionNow = [info objectForKey:@"CFBundleShortVersionString"];
            UILabel *label2 = [LHController createLabelWithFrame:CGRectMake(viv.frame.size.width-100, 0, 80, viv.frame.size.height) Font:B Bold:NO TextColor:nil Text:versionNow];
            label2.textAlignment = NSTextAlignmentRight;
            [viv addSubview:label2];
            
            UIView *fv = [self createWhiteFrame:CGRectMake(LEFT, viv.frame.size.height-1, WIDTH-LEFT, 1)];
            [viv addSubview:fv];
            
            btn.frame = CGRectMake(0, 30+SPACE*i+SPACE+30, WIDTH, SPACE);
        }
         [self.view addSubview:btn];
        
        UIImageView *imageView = [LHController createImageViewWithFrame:CGRectMake(WIDTH-30, (SPACE-15)/2, 15, 15) ImageName:@"right"];
        [btn addSubview:imageView];
        
        UILabel *label = [LHController createLabelWithFrame:CGRectMake(LEFT, 0, 160, btn.frame.size.height) Font:B Bold:NO TextColor:nil Text:array[i]];
        [btn addSubview:label];

    }
}

-(UIView *)createWhiteFrame:(CGRect)frame{
    UIView *whiteView = [[UIView alloc] initWithFrame:frame];
    whiteView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    return whiteView;
}
#pragma mark -选项
-(void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 10:
        {
            [self claerAlert];
        }
            break;
            
        case 11:
        {
            TakeViewController *take = [[TakeViewController alloc] init];
            take.navigationItem.title = @"浏览记录";
 
            [self.navigationController pushViewController:take animated:YES];
        }
            break;
            
        case 12:
        {
            AgreementViewController *agreement = [[AgreementViewController alloc] init];
            [self.navigationController pushViewController:agreement animated:YES];
        }
            break;
            
        case 13:
        {
       
            AboutViewController *about = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
            break;
            
       
            
        default:
            break;
    }
}

-(void)claerAlert{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:
                       @"您确定要清除所有缓存？" delegate:self
                                       cancelButtonTitle:@"确定"
                                       otherButtonTitles:@"取消", nil];
    [al show];
}

#pragma mark - uialertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self deleteDatabse];
        [self getText];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"缓存已经清除" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [al show];
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }
}

-(void)changeClick:(UIButton *)btn{
    
    for (int i = 0; i < _array.count; i ++) {
        UIButton *button = (UIButton *)[areaView viewWithTag:100+i];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:124/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:btn.titleLabel.text forKey:AREA];
}

#pragma mark - 返回
-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(itemClick)];
}

-(void)itemClick{
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    CustomTabBarController * ct =(CustomTabBarController *) window.rootViewController;
//    ct.bgImageView.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)clearClick:(UIButton *)btn{
    bgView.hidden = YES;
    clearView.hidden = YES;
    
    if ([btn.titleLabel.text isEqualToString:@"确定"]) {

        [self deleteDatabse];
        [self getText];
        
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"缓存已经清除" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [al show];
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - 清除缓存
- (void)deleteDatabse
{
    //清除sdimage缓存
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

    // delete the old db.
    FmdbManager *DB = [FmdbManager shareManager];
    [DB dropTables];
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
