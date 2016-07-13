//
//  RevokeComplainViewController.m
//  chezhiwang
//
//  Created by bangong on 16/5/5.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "RevokeComplainViewController.h"
#import "CZWIMInputTextView.h"

#pragma mark - 选项cell
@interface RevokeComplainCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation RevokeComplainCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = colorDeepGray;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.layer.borderWidth = 1;
        self.titleLabel.layer.borderColor = colorYellow.CGColor;
        self.titleLabel.layer.cornerRadius = 4;
        self.titleLabel.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.titleLabel];
     
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

@end

#pragma mark - 文本编辑cell
@interface RevokeComplainTextViewCell : UICollectionViewCell

@property (nonatomic,strong) CZWIMInputTextView *textView;
@property (nonatomic,copy) NSString *dataKey;
@property (nonatomic,weak) RevokeComplainViewController *parentController;

@end

@implementation RevokeComplainTextViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView = [[CZWIMInputTextView alloc] initWithFrame:CGRectZero];
        self.textView.layer.cornerRadius = 4;
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.borderColor = colorYellow.CGColor;
        self.textView.layer.borderWidth = 1;
        self.textView.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.textView];
        
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)textViewChange:(NSNotification *)notification{
 
    [self.parentController.dictionary setObject:self.textView.text forKey:self.dataKey];
 
}

@end

#pragma mark -头部视图
@interface CellHederView : UICollectionReusableView

@property (nonatomic,strong) UILabel *titleLabel;

@end

@implementation CellHederView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = colorBlack;
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = colorLineGray;
        
        UIView *blueView = [[UIView alloc] init];
        blueView.backgroundColor = colorDeepBlue;
        
        [self addSubview:self.titleLabel];
        [self addSubview:grayView];
        [self addSubview:blueView];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(-5);
        }];
        
        [grayView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
        
        [blueView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.bottom.equalTo(0);
            make.width.equalTo(self.titleLabel);
            make.height.equalTo(2);
        }];
    }
    return self;
}

@end

#pragma mark - 撤销申诉

@interface RevokeComplainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *keyName;
    NSString *keyId;
    NSString *keyReason;
    NSString *keyOther;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL closeReason;

@end

@implementation RevokeComplainViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _closeReason = YES;
        _dictionary = [[NSMutableDictionary alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        keyName   = @"name";
        keyId     = @"id";
        keyReason = @"reason";
        keyOther  = @"other";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadData{
    __weak __typeof(self)weakSelf = self;
    [HttpRequest GET:[URLFile urlString_delComTypeList] success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"rel"]) {
            [_dataArray addObject:dict];
        }
       [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"申请撤诉";
    
    [self createCollectionView];

    [self.collectionView reloadData];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWillShow:(NSNotification *)notification{
    
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-height);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification{
    [self.collectionView updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
    }];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[RevokeComplainCell class] forCellWithReuseIdentifier:@"RevokeComplainCell"];
    [_collectionView registerClass:[RevokeComplainTextViewCell class] forCellWithReuseIdentifier:@"RevokeComplainTextViewCell"];
    [_collectionView registerClass:[CellHederView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CellHederView"];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - 提交数据
-(void)submitData{
    if (!self.dictionary[keyId]) {
        [LHController alert:@"请选择处理结果"];
        return;
    }else if ([self.dictionary[keyName] isEqualToString:@"其他"]){
        if ([self hasChar:self.dictionary[keyOther]]==NO){
             [LHController alert:@"请输入其他原因"];
            return;
        }

    }else if ([self hasChar:self.dictionary[keyReason]] == NO){
         [LHController alert:@"请输入撤诉理由"];
        return;
    }
       
     
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:self.cpid forKey:@"cpid"];
        [dict setObject:self.dictionary[keyId] forKey:@"type"];
        if ([self.dictionary[keyName] isEqualToString:@"其他"]) {
             [dict setObject:self.dictionary[keyOther] forKey:@"otherCase"];
        }else{
            [dict setObject:@"" forKey:@"otherCase"];

        }
        [dict setObject:self.dictionary[keyReason] forKey:@"reason"];
       [HttpRequest POST:[URLFile urlStringForCancelComplain] parameters:dict success:^(id responseObject) {
           if ([responseObject count] == 0) {
               return ;
           }
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[responseObject firstObject][@"result"]
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:nil, nil];
           [alert show];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [alert dismissWithClickedButtonIndex:0 animated:YES];
           });
           if ([[responseObject firstObject][@"result"] isEqualToString:@"撤诉成功"]) {
               if (self.success) {
                   self.success();
               }
               [self.navigationController popViewControllerAnimated:YES];
           }

       } failure:^(NSError *error) {
           
       }];
}

-(BOOL)hasChar:(NSString *)string{
    if (string == nil) {
        return NO;
    }
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
 
    return  [@(string.length) boolValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count;
    }else if (section == 1){
        if (self.closeReason) {
            return 0;
        }else{
            return 1;
        }
    }
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        RevokeComplainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RevokeComplainCell" forIndexPath:indexPath];
        NSDictionary *dict = (NSDictionary *)self.dataArray[indexPath.row];
      
        cell.titleLabel.text = dict[keyName];
        if ([cell.titleLabel.text isEqualToString:self.dictionary[keyName]]) {
            cell.titleLabel.backgroundColor = colorYellow;
            cell.titleLabel.textColor = [UIColor whiteColor];
           
        }else{
            cell.titleLabel.backgroundColor = [UIColor clearColor];
            cell.titleLabel.textColor = colorDeepGray;
        }
       
        return cell;

    }else if (indexPath.section == 1){
        RevokeComplainTextViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RevokeComplainTextViewCell" forIndexPath:indexPath];
        cell.textView.placeHolder = @"请输入其他原因";
        cell.dataKey = keyOther;
        cell.textView.text = self.dictionary[keyOther];
        cell.parentController = self;
        return cell;

    }else if(indexPath.section == 2){
        RevokeComplainTextViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RevokeComplainTextViewCell" forIndexPath:indexPath];
        cell.textView.placeHolder = @"";
        cell.dataKey = keyReason;
        cell.textView.text = self.dictionary[keyReason];
        cell.parentController = self;
        return cell;
    }
  
    RevokeComplainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RevokeComplainCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"提交";
    cell.titleLabel.backgroundColor = colorYellow;
    cell.titleLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{


    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 1 || indexPath.section == 3){
            return nil;
        }
         CellHederView *reusableview  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CellHederView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            reusableview.titleLabel.text = @"处理结果";
          
        }else if (indexPath.section == 2){
            reusableview.titleLabel.text = @"撤诉理由";
        }
       
        return reusableview;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *string = self.dataArray[indexPath.row][keyName];
        if ([string isEqualToString:@"其他"]) {
            self.closeReason = NO;
        }else{
            self.closeReason = YES;
        }
        RevokeComplainCell *cell = (RevokeComplainCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self.dictionary setObject:cell.titleLabel.text forKey:keyName];
        [self.dictionary setObject:self.dataArray[indexPath.row][keyId] forKey:keyId];
        
        [self.collectionView reloadData];
    }else if (indexPath.section == 3){
    
        [self submitData];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return CGSizeMake(self.view.frame.size.width/2-15, 40);
    }else if (indexPath.section == 1){
         return CGSizeMake(self.view.frame.size.width-20, 80);
    }else if (indexPath.section == 2){
         return CGSizeMake(self.view.frame.size.width-20, 120);
    }else{
         return CGSizeMake(self.view.frame.size.width-20, 40);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0 || section == 2) {
        return UIEdgeInsetsMake(20, 10, 10, 10);
    }else if (section == 1){
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }else{
        return UIEdgeInsetsMake(40, 10, 40, 10);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 3) {
        return CGSizeZero;
    }
    return CGSizeMake(CGRectGetWidth(self.view.frame), 60);
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
