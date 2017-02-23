//
//  LHMenuController.m
//  LHProject
//
//  Created by bangong on 16/4/13.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHMenuController.h"
#import "UIImage+LH.h"
#import <Accelerate/Accelerate.h>

@interface LHMenuItem ()

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;

@end

@implementation LHMenuItem


-(instancetype)initWithTitle:(NSString *)title andImage:(UIImage *)image{
    
    if (self = [super init]) {
        _image = image;
        _title = title;
       
        [self setUp];
    }
    return self;
}

-(void)setUp{
    _itemImage = [[UIImageView alloc] init];
    [_itemImage setContentMode:UIViewContentModeScaleAspectFit];
    _itemImage.image = _image;
   
    _itemTitleLabel = [[UILabel alloc] init];
    _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    _itemTitleLabel.font = [UIFont systemFontOfSize:13];
    _itemTitleLabel.text = _title;
    
    [self addSubview:_itemImage];
    [self addSubview:_itemTitleLabel];
    
    [_itemImage makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(0);
        make.bottom.lessThanOrEqualTo(_itemTitleLabel.top).offset(-5);
    }];
    
    [_itemTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.right.equalTo(0);
    }];
}


@end

#pragma mark - ////////////////////////////////////////////////////////
@interface LHMenuController ()
{
    CGFloat changY;
    UIView *backView;
}
@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,strong) UIImage *bluffImage;
@end

@implementation LHMenuController

- (void)dealloc
{
    _items = nil; 
    _buttons = nil;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _duration = 0.3;
        _beginTime = 0.042;
        _itemSize = CGSizeMake(70, 70);
        _lineSpacing = 30;
        _queues = 5;
        NSMutableArray *marray = [NSMutableArray new];
        NSArray *titles = @[@"QQ好友",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间"];
        NSArray *iamgeNames = @[@"QQ",@"微信朋友圈",@"微信",@"新浪微博",@"QQ空间"];
        for (int i = 0; i < titles.count; i ++) {

            [marray addObject:[[LHMenuItem alloc]initWithTitle:titles[i] andImage: [UIImage imageNamed:[@"LHMenu.bundle" stringByAppendingPathComponent:iamgeNames[i]]]]];
        }
        _items = marray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnBackground)]];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];


    [self setUpView];
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showItems];

    });
}

-(void)setBluffImageWithView:(UIView *)view{

    UIImage *image = [self convertViewToImage:view];
    self.bluffImage = [self blurredImageWithRadius:35.1 iterations:2 tintColor:nil image:image];
}

- (UIImage *) snapshootView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    CGContextRef  ctx = UIGraphicsGetCurrentContext();
    [view.window.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)addVisualEffectView{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = self.view.bounds;
   
    [self.view insertSubview:effectview atIndex:0];
    
}

//点击空白处，dismiss
- (void)didTapOnBackground{
    [self hidenItems];
    __weak __typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration/3.0*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    });
}

//创建按钮
- (void)setUpView{
    backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = RGB_color(238, 238, 238, 1);
    [self.view addSubview:backView];

    CGFloat widthSpace = (self.view.frame.size.width - self.itemSize.width*self.queues)/(self.queues+1);
    for (int i = 0; i < self.items.count; i ++) {
        LHMenuItem *item = self.items[i];
   
        item.frame = CGRectMake(widthSpace+(i%self.queues)*(self.itemSize.width+widthSpace), 20+(i/self.queues)*(self.itemSize.height+self.lineSpacing), self.itemSize.width, self.itemSize.height);
        item.tag = 100+i;
        [item addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:item];
        [self.buttons addObject:item];
    }

    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitleColor:RGB_color(100, 100, 100, 1) forState:UIControlStateNormal];
    [copyButton setTitle:@"复制链接" forState:UIControlStateNormal];
    [copyButton addTarget:self action:@selector(copyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    copyButton.backgroundColor = [UIColor whiteColor];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:RGB_color(100, 100, 100, 1) forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didTapOnBackground) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.backgroundColor = [UIColor whiteColor];

    [backView addSubview:copyButton];
    [backView addSubview:cancelButton];

    LHMenuItem *item = [self.buttons lastObject];
    copyButton.lh_left = 0;
    copyButton.lh_top = item.lh_bottom+20;
    copyButton.lh_size = CGSizeMake(WIDTH, 50);

    cancelButton.lh_left = 0;
    cancelButton.lh_top = copyButton.lh_bottom+1;
    cancelButton.lh_size = copyButton.lh_size;

    backView.lh_width = WIDTH;
    backView.lh_height = cancelButton.lh_bottom;
    backView.lh_top = HEIGHT;
}


- (void)copyButtonClick{
    [self caseNumber:5];
}


-(void)caseNumber:(NSInteger)num{

}

-(void)buttonClick:(LHMenuItem *)item{
    [self didTapOnBackground];
    
}


//展示按钮
-(void)showItems{

    [UIView animateWithDuration:self.duration animations:^{
        backView.lh_bottom = HEIGHT;
    }];
//    __weak __typeof(self)weakSelf = self;
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.1f*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        for (int i = 0; i < strongSelf.buttons.count; i ++) {
//            UIButton *btn = strongSelf.buttons[i];
//        
//            CGFloat k = fabsf(i%strongSelf.queues-((strongSelf.queues-1)/2.0f));
//        
//            [UIView animateWithDuration:self.duration delay:self.beginTime*k usingSpringWithDamping:0.6 initialSpringVelocity:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
//                CGRect rect = btn.frame;
//                rect.origin.y = rect.origin.y-changY;
//                btn.frame = rect;
//            } completion:nil];
//
//        }
//    });
}

//隐藏按钮
-(void)hidenItems{
  [UIView animateWithDuration:self.duration animations:^{
      backView.lh_top = HEIGHT;
  }];
//    for (int i = 0; i < self.buttons.count; i ++) {
//
//        UIButton *btn = self.buttons[i];
//      
//        CGFloat k = fabsf(i%self.queues-((self.queues-1)/2.0f));
//
//        [UIView animateWithDuration:self.duration/3.0 delay:self.beginTime*k options:UIViewAnimationOptionLayoutSubviews animations:^{
//            CGRect rect = btn.frame;
//            rect.origin.y = rect.origin.y+changY;
//            btn.frame = rect;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
}



-(NSMutableArray *)buttons{
   
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}


-(UIImage *)convertViewToImage:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor image:(UIImage *)image

{
    
    //image must be nonzero size
    
    if (floorf(image.size.width) * floorf(image.size.height) <= 0.0f) return image;
    
    //boxsize must be an odd integer
    
    uint32_t boxSize = (uint32_t)(radius * image.scale);
    
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    
    CGImageRef imageRef = image.CGImage;
    
    vImage_Buffer buffer1, buffer2;
    
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    size_t bytes = buffer1.rowBytes * buffer1.height;
    
    buffer1.data = malloc(bytes);
    
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
        
    {
        
        //perform blur
        
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        
        void *temp = buffer1.data;
        
        buffer1.data = buffer2.data;
        
        buffer2.data = temp;
        
    }
    
    //free buffers
    
    free(buffer2.data);
    
    free(tempBuffer);
    
    //create image context from buffer
    
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
        
    {
        
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
        
    }
    
    //create image from context
    
    imageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    CGContextRelease(ctx);
    
    free(buffer1.data);
    
    return resultImage;
    
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
