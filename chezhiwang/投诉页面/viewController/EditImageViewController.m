//
//  EditViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "EditImageViewController.h"

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

@interface EditImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;

}
@end

@implementation EditImageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:[UIView new]];

    [self createRightItem];
    [self createCollcetionView];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        _collectionView.contentOffset = CGPointMake(WIDTH*self.index, 0);

    });
    
}

-(void)createRightItem{
    UIButton *btn = [LHController createButtnFram:CGRectMake(0, 0, 20, 20) Target:self Action:@selector(rightItemClick) Text:nil];
    [btn setBackgroundImage:[UIImage imageNamed:@"forum_deleteImage"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)rightItemClick{
    if (self.imageArray.count == 0) {
        return;
    }
    
    [self.imageArray removeObjectAtIndex:_index];
    if (self.block) {
        self.block(_index);
    }
    [_collectionView reloadData];
    if (_collectionView.contentOffset.x > 0) {
        _collectionView.contentOffset = CGPointMake(_collectionView.contentOffset.x-WIDTH, 0);
    }
    _index = _collectionView.contentOffset.x/WIDTH;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",_index+1,self.imageArray.count];
    if (self.imageArray.count == 0) self.navigationItem.title = @"0/0";
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)createCollcetionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[EditImageCell class] forCellWithReuseIdentifier:@"collectioncell"];
}

#pragma mark - UICollectionViewDataSource/delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView//设置有多少个段
{
    return 1;
}
//每一个view就是一行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EditImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];//复用
    //NSLog(@"%@",self.assetArray);
    cell.image = self.imageArray[indexPath.row];
    return cell;
}



#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return collectionView.frame.size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = scrollView.contentOffset.x/WIDTH;
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",_index+1,self.imageArray.count];
}

-(void)deleteImage:(deleteImage)block{
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
