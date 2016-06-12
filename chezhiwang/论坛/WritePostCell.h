//
//  WritePostCell.h
//  demo
//
//  Created by bangong on 15/11/6.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AssetsLibrary/AssetsLibrary.h>

@ class WritePostCell;
typedef void(^deleteCell)(UIImage *cellAsset, WritePostCell *myCell);
typedef void(^returnContent)(NSString *content, UIImage *image, WritePostCell *myCell);

@interface WritePostCell : UITableViewCell

@property (nonatomic,strong) UIImage *asset;
@property (nonatomic,copy) NSString *describe;
@property (nonatomic,copy) deleteCell block;
@property (nonatomic,copy) returnContent contentBlock;

-(void)deleteCell:(deleteCell)block;
-(void)returnConent:(returnContent)block;
@end
