//
//  EditViewController.m
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "EditImageViewController.h"
#import "EditImageCell.h"

@interface EditImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
   // NSInteger _index;
}
@end

@implementation EditImageViewController

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.imageArray = [[NSMutableArray alloc] init];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor  = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self createLeftItem];
    [self createRightItem];
    [self createCollcetionView];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.imageArray.count];
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        _collectionView.contentOffset = CGPointMake(WIDTH*self.index, 0);

    });
    
}

-(void)createLeftItem{
    self.navigationItem.leftBarButtonItem = [LHController createLeftItemButtonWithTarget:self Action:@selector(leftItemClick)];
}

-(void)leftItemClick{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-15) collectionViewLayout:layout];
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
    
    return CGSizeMake(WIDTH, HEIGHT-64);
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
