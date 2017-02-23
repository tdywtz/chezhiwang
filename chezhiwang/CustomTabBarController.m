//
//  CustomTabBar.m
//  chezhiwang
//
//  Created by bangong on 15/9/7.
//  Copyright (c) 2015年 车质网. All rights reserved.
//

#import "CustomTabBarController.h"

#import "BasicNavigationController.h"

#import "MyViewController.h"
#import "HomepageTableViewController.h"
#import "FindCollectionViewController.h"

@interface CustomTabBarController ()<UITabBarControllerDelegate>

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    HomepageTableViewController      *homepage = [[HomepageTableViewController  alloc] init];
    FindCollectionViewController     *find     = [FindCollectionViewController init];
    MyViewController                 *my       = [[MyViewController alloc] init];
    
    BasicNavigationController *n1 = [[BasicNavigationController alloc] initWithRootViewController:homepage];
    BasicNavigationController *n2 = [[BasicNavigationController alloc] initWithRootViewController:find];
    BasicNavigationController *n3 = [[BasicNavigationController alloc] initWithRootViewController:my];


    homepage.title   = @"首页";
    find.title       = @"发现";

    self.viewControllers  = @[n1,n2,n3];
    [self createCustomTabBar];



    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);

    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
             id class = classes[0];
            if (class) {
              //  NSLog(@"=====%s",[class ]);
            }
        }
        free(classes);
    }

}

//处理 UITabBarItem
-(void)createCustomTabBar{
    self.tabBar.barTintColor = RGB_color(254, 254, 254, 1);

    NSArray *array = @[@"首页",@"发现",@"我"];
    NSArray *grays = @[@"auto_tabbar_home_gray",@"auto_tabbar_find_gray",@"auto_tabbar_my_gray"];
    NSArray *brights = @[@"auto_tabbar_home_bright",@"auto_tabbar_find_bright",@"auto_tabbar_my_bright"];
    for (int i = 0; i  < self.tabBar.items.count; i ++) {
        
        UITabBarItem *item = self.tabBar.items[i];
        item = [item initWithTitle:array[i] image:[self createImageWithName:grays[i]] selectedImage:[self createImageWithName:brights[i]]];
      
        //设置item字体颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB_color(68, 68, 68, 1)} forState:UIControlStateNormal];
        //选中颜色
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:colorLightBlue} forState:UIControlStateSelected];
    }
}


-(UIImage *)createImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    //需要对图片进行特殊处理
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 自定义tabbar时设置
   // [self.selectedViewController beginAppearanceTransition: YES animated: animated];
    [MobClick beginLogPageView:@"PageOne"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //自定义tabbar时设置
    //[self.selectedViewController beginAppearanceTransition: NO animated: animated];
    [MobClick endLogPageView:@"PageOne"];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //自定义tabbar时设置
    //[self.selectedViewController endAppearanceTransition];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 自定义tabbar时设置
   // [self.selectedViewController endAppearanceTransition];
}


//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//    UINavigationController *nvc = (UINavigationController *)self.selectedViewController;
//    return [nvc.viewControllers.lastObject supportedInterfaceOrientations];
//}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//
//    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
//}

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
