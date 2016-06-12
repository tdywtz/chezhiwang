//
//  EditCell.m
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "EditImageCell.h"

@implementation EditImageCell
{
    UIImageView *imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.backgroundColor = [UIColor blackColor];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.contentView addSubview:imageView];
    }
    return self;
}

-(void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = nil;
        _image = image;
    }
    imageView.image = _image;
}

- (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
