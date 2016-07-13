//
//  CustomTabBar.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CustomTabBarController.h"
#import "NewsViewController.h"
#import "ComplainListViewController.h"
#import "AnswerViewController.h"
#import "ForumListViewController.h"
#import "MyViewController.h"
#import "BasicNavigationController.h"

#import "MyTabbar.h"



@interface CustomTabBarController ()<UITabBarControllerDelegate>
{
    UIView *custommoveView;
}
@end

@implementation CustomTabBarController
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    [self setValue:[[MyTabbar alloc] init] forKey:@"_tabBar"];
//    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//       
//    }
//    return self;
//   
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    NewsViewController             *news = [[NewsViewController alloc] init];
    ComplainListViewController *complain = [[ComplainListViewController alloc] init];
    AnswerViewController         *answer = [[AnswerViewController alloc] init];
    ForumListViewController       *forum = [[ForumListViewController alloc] init];
    MyViewController                 *my = [[MyViewController alloc] init];
    
    BasicNavigationController *n1 = [[BasicNavigationController alloc] initWithRootViewController:news];
    BasicNavigationController *n2 = [[BasicNavigationController alloc] initWithRootViewController:complain];
    BasicNavigationController *n3 = [[BasicNavigationController alloc] initWithRootViewController:answer];
    BasicNavigationController *n4 = [[BasicNavigationController alloc] initWithRootViewController:forum];
    BasicNavigationController *n5 = [[BasicNavigationController alloc] initWithRootViewController:my];
    
    
    
    news.title                 = @"新闻";
    complain.title             = @"投诉";
    answer.title               = @"答疑";
    n4.navigationItem.title    = @"论坛";
    my.title                   = @"我";
    self.viewControllers  = @[n1,n2,n3,n4,n5];

    [self createCustomTabBar];

    //NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler(NSException *exception));
}

//void UncaughtExceptionHandler(NSException *exception) {
//
//    　　NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
//
//    　　NSString *reason = [exception reason];//非常重要，就是崩溃的原因
//
//    　　NSString *name = [exception name];//异常类型
//
//    　　NSLog(@"exception type : %@ n crash reason : %@ n call stack info : %@", name, reason, arr);
//    
//    　　}

//处理 UITabBarItem
-(void)createCustomTabBar{
    self.tabBar.barTintColor = colorLightBlue;
    
    custommoveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width/self.viewControllers.count, self.tabBar.bounds.size.height)];
    custommoveView.backgroundColor  = colorDeepBlue;
    [self.tabBar addSubview:custommoveView];
    
    NSArray *array = @[@"新闻",@"投诉",@"答疑",@"论坛",@"我"];
    NSArray *imageArray = @[@"news",@"complain",@"answer",@"forum",@"my"];
    for (int i = 0; i  < self.tabBar.items.count; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        item = [item initWithTitle:array[i] image:[self createImageWithName:imageArray[i]] selectedImage:[self createImageWithName:imageArray[i]]];
        
        //设置item字体颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        //选中颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    }
}

-(UIImage *)createImageWithName:(NSString *)imageName
{
    //UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.imagePath,imageName]];
    UIImage *image = [UIImage imageNamed:imageName];
    //需要对图片进行特殊处理
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    CGRect frame = custommoveView.frame;
    frame.origin.x = self.tabBar.bounds.size.width/self.viewControllers.count *tabBarController.selectedIndex;
    [UIView animateWithDuration:0.1 animations:^{
        custommoveView.frame = frame;
    }];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      // 自定义tabbar时设置
   // [self.selectedViewController beginAppearanceTransition: YES animated: animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
      // 自定义tabbar时设置
    //[self.selectedViewController beginAppearanceTransition: NO animated: animated];
    [MobClick endLogPageView:@"PageOne"];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
      // 自定义tabbar时设置
    //[self.selectedViewController endAppearanceTransition];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
      // 自定义tabbar时设置
   // [self.selectedViewController endAppearanceTransition];
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
