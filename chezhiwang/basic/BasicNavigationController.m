//
//  BasicNavigationController.m
//  12365auto
//
//  Created by bangong on 16/3/21.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)UIView *alphaView;

@end

@implementation BasicNavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    //[self setValue:[[UINavigationBar alloc] init] forKey:@"_navigationBar"];
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
       
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        CGRect frame = self.navigationBar.frame;
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
        self.alphaView.backgroundColor = colorLightBlue;
        [self.view insertSubview:self.alphaView belowSubview:self.navigationBar];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
        // [UIImage imageNamed:@"bigShadow.png"]
   
        self.navigationBar.layer.masksToBounds = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    [self setNagitionBar];
}

-(void)setNagitionBar{
    if (SYSTEM_VERSION_GREATER_THAN(8.0)) {
        self.navigationController.hidesBarsOnTap = NO;
    }
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationBar.barTintColor = colorDeepBlue;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
}

-(void)endAlph{
    if (self.alphaView.alpha == 1.0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alphaView.alpha = 1.0;
    }];
}

-(void)bengingAlph{
    if (self.alphaView.alpha == 0.0) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alphaView.alpha = 0.0;
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
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
