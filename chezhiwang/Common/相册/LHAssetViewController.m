//
//  LHAssetViewController.m
//  imagePicker
//
//  Created by luhai on 15/7/25.
//  Copyright (c) 2015年 luhai. All rights reserved.
//

#import "LHAssetViewController.h"
#import "LHAssetViewCell.h"
#import "LHAssetPickerController.h"
#import "LHAssetPreviewController.h"

#define myHeight [UIScreen mainScreen].bounds.size.height
#define myWidth [UIScreen mainScreen].bounds.size.width

@interface LHAssetViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    LHAssetPickerController *picker;
    UICollectionView *_collectionView;
    NSMutableArray *_resultArray;

    UIButton *rigthBtn;
    
}
@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic,strong) ALAsset *aseet;

@end

@implementation LHAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [self.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    picker = (LHAssetPickerController *)self.navigationController;
    _resultArray = [[NSMutableArray alloc] init];
    
  
 
    [self createRightItem];
    [self createCollcetionView];
    [self setAssetArray];
    [self createFootView];
    
}

-(void)setRsueltArray{
   
    for (int i = 0; i < picker.selectedArray.count; i ++) {
        NSString *str1 = [NSString stringWithFormat:@"%@",picker.selectedArray[i]];
        for (int j = 0; j < self.assetArray.count; j ++) {
            ALAsset *asset = self.assetArray[j];
            NSString *str = [NSString stringWithFormat:@"%@",[asset valueForProperty:ALAssetPropertyAssetURL]];
            if ([str isEqualToString:str1]) {
                [_resultArray addObject:asset];
            }
        }
    }
}

-(void)createRightItem{
    rigthBtn = [self createButtonWithFrame:CGRectMake(0, 0, 40, 20) Target:self action:@selector(rightClick) ImageName:nil  Text:@"取消"];
    [rigthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigthBtn];
}

-(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action ImageName:(NSString *)name Text:(NSString *)text{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)rightClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)createFootView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, myHeight-40, myWidth, 40)];
    view.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    view.alpha = 0.8;
    [self.view addSubview:view];
    UIButton *btnLeft = [self createButonWithFrame:CGRectMake(10, 0, 40, 40) Text:@"预览" Color:[UIColor whiteColor] Target:self Action:@selector(footClick:)];
    [view addSubview:btnLeft];
    
    UIButton *btnRight = [self createButonWithFrame:CGRectMake(myWidth-50, 0, 40, 40) Text:@"完成" Color:[UIColor whiteColor] Target:self Action:@selector(footClick:)];
    [view addSubview:btnRight];
    [view addSubview:btnRight];
    
}

-(void)footClick:(UIButton *)btn{

    if ([btn.titleLabel.text isEqualToString:@"完成"]) {
       
        if (_resultArray.count > 0) {
            if (picker.getAsset) {
                picker.getAsset(_resultArray);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if (_resultArray.count == 0) {
            [self alertView:@"还没有选择图片"];
            return;
        }
        LHAssetPreviewController *preview = [[LHAssetPreviewController alloc] init];
        preview.assetArray = _resultArray;
        preview.resultArray = _resultArray;
        [preview getRsuelt:^(NSArray *array) {
            if (array) {
                [_resultArray setArray:array];
                [_collectionView reloadData];
            }
        }];
        
        [self .navigationController pushViewController:preview animated:YES];
    }
}

#pragma mark - 创建按钮
-(UIButton *)createButonWithFrame:(CGRect)frame Text:(NSString *)text Color:(UIColor *)color Target:(id)target Action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

-(void)createCollcetionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, myWidth, myHeight-40) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //_collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
   
    [_collectionView registerClass:[LHAssetViewCell class] forCellWithReuseIdentifier:@"mycell"];
}

-(void)setAssetArray{
    if (!self.assetArray) {
        self.assetArray = [[NSMutableArray alloc] init];
    }else{
        [self.assetArray removeAllObjects];
    }
    
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assetArray addObject:result];

        }
        else{
            [self setRsueltArray];
            [_collectionView reloadData];
        }
    }];
}


#pragma mark - UICollectionViewDataSource/delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView//设置有多少个段
{
    return 1;
}
//每一个view就是一行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    LHAssetViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mycell" forIndexPath:indexPath];//复用
   [cell getResult:^(ALAsset *result, BOOL add,NSInteger num) {
       if (add) {
           if (_resultArray.count == picker.maxNumber) {
            
               [self alertView:[NSString stringWithFormat:@"图片不能超过%ld张",picker.maxNumber]];
            
               [_collectionView reloadData];
               return;
           }
           self.aseet = self.assetArray[num];
           [_resultArray addObject:self.assetArray[num]];
       }else{
           [_resultArray removeObject:self.assetArray[num]];
       }
       [_collectionView reloadData];
   }];
    
 
    cell.isSelect = NO;
 
    for (int i = 0; i < _resultArray.count; i ++) {
        if ([_resultArray[i] isEqual:self.assetArray[indexPath.row]]) {
            cell.isSelect = YES;
            break;
        }
    }

    cell.maxNum = picker.maxNumber;
    cell.num = indexPath.row;
    cell.asset = self.assetArray[indexPath.row];
    return cell;
}

-(void)alertView:(NSString *)str{
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:str message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [al show];
    [UIView animateWithDuration:0.3 animations:^{
        [al dismissWithClickedButtonIndex:0 animated:YES];
    }];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    LHAssetPreviewController *preview = [[LHAssetPreviewController alloc] init];
//    preview.assetArray = self.assetArray;
//    preview.resultArray = _resultArray;
//    preview.index = indexPath.row;
//    
//    [preview getRsuelt:^(NSArray *array) {
//        if (array) {
//            [_resultArray setArray:array];
//            [_collectionView reloadData];
//        }
//    }];
//
//    [self .navigationController pushViewController:preview animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    return CGSizeMake(WIDTH/4-2, WIDTH/4-2);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section//设置页眉的高度
//{
//    return CGSizeMake(30, 30);//当竖着滚，横坐标没用，横着滚，纵坐标没用
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
