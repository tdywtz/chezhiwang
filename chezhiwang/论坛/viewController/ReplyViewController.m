//
//  ReplyViewController.m
//  chezhiwang
//
//  Created by bangong on 15/10/16.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "ReplyViewController.h"

@interface ReplyViewController ()<UITextViewDelegate>

@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.navigationItem.title = @"回复";

}

-(void)rightItemClick{
    [self.view endEditing:YES];
    
    if ([LHController judegmentSpaceChar:self.contentTextView.text] == NO){
        [LHController alert:@"内容不能为空"];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[CZWManager manager].userID forKey:@"uid"];
        [dict setObject:[CZWManager manager].userName forKey:@"username"];
        [dict setObject:self.contentTextView.text forKey:@"content"];
        
        if (self.replaytype == replyTypePost) {
            //回复帖子
            [dict setObject:self.Id forKey:@"tid"];
        }else{
            //回复本楼
             [dict setObject:self.Id forKey:@"pid"];
        }
        NSString *desc = [self.contentArray componentsJoinedByString:@"|"];
        [dict setObject:desc forKey:@"imgdesc"];
        [self submitData:dict];
    }
}



#pragma mark - 发布
-(void)submitData:(NSDictionary *)dict{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"正在上传"
                                                 message:nil
                                                delegate:nil
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil, nil];
    [al show];
    NSString *url;
    
    if (self.replaytype == replyTypePost) {
        url = [URLFile urlStringForReplyPost];//forum_replypost;
    }else{
        url = [URLFile urlStringForReplyFloor];//forum_replyfloor;
    }
    

     [HttpRequest POST:url parameters:dict images:self.dataArray success:^(id responseObject) {
   
         [LHController alert:@"发送成功"];
         if (self.block) {
             self.block();
         }
         [al dismissWithClickedButtonIndex:0 animated:YES];
         [self dismissViewControllerAnimated:YES completion:nil];
     } failure:^(NSError *error) {
          [al dismissWithClickedButtonIndex:0 animated:YES];
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


//回调
-(void)sucess:(sucess)block{
    self.block = block;
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
