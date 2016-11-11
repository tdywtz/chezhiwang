
//
//  MyComplainShowCell.m
//  chezhiwang
//
//  Created by bangong on 16/6/8.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "MyComplainShowCell.h"
#import "MyComplainViewController.h"
#import "MyComplainDetailsViewController.h"
#import "ComplainViewController.h"

#pragma mark - buttonView

@interface ButtonView : UIView

@property (nonatomic,copy) void(^click)(NSString *title);
@property (nonatomic,strong) NSArray *titles;

@end

@implementation ButtonView

- (void)setTitles:(NSArray *)titles{
    _titles = [titles copy];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < _titles.count; i ++) {
        UIButton *button = [LHController createButtnFram:CGRectMake(120*i, 0, 80, 30) Target:self Action:@selector(buttonClick:) Font:15 Text:_titles[i]];
        [self addSubview:button];
        if (i == _titles.count-1) {
            self.bounds = CGRectMake(0, 0, button.frame.origin.x+button.frame.size.width, button.frame.size.height);
        }
    }
}

- (void)buttonClick:(UIButton *)btn{
    
    if (self.click) {
        self.click(btn.titleLabel.text);
    }
}

@end



#pragma makr - MyComplainShowCell
@implementation MyComplainShowCell
{
    UILabel *stateLabel;
    CZWLabel *stepLabel;
    ButtonView *btnView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //创建UI
        [self makeUI];
        
    }
    return self;
}

-(void)makeUI{
    stateLabel = [[UILabel alloc] init];
    stateLabel.textColor = colorBlack;
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.numberOfLines = 0;
    
    stepLabel = [[CZWLabel alloc] init];
    stepLabel.textColor = colorDeepGray;
    stepLabel.font = [UIFont systemFontOfSize:12];
    stepLabel.paragraphSpacing = 4;
    stepLabel.numberOfLines = 0;
    
    btnView = [[ButtonView alloc] init];

    __weak __typeof(self)weakSelf = self;
    btnView.click = ^(NSString *title){
       
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([title isEqualToString:@"查看详情"]) {
            MyComplainDetailsViewController *cp = [[MyComplainDetailsViewController alloc] init];
            cp.model = weakSelf.model;
            
            //回调是否评分
//            [cp blockCommont:^(BOOL yesORno) {
//                comont = yesORno;
//            }];
            [strongSelf.parentController.navigationController pushViewController:cp animated:YES];
        }else{
            ComplainViewController *complain = [[ComplainViewController alloc] init];
            complain.siChange = YES;
            complain.Cpid = strongSelf.model.Cpid;
            if ([title isEqualToString:@"再次投诉"]) {
                complain.again = YES;
            }
            [strongSelf.parentController.navigationController pushViewController:complain animated:YES];
        }
    };

    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = colorLineGray;

    [self.contentView addSubview:stateLabel];
    [self.contentView addSubview:stepLabel];
    [self.contentView addSubview:btnView];
    [self.contentView addSubview:lineView];

    [stateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(15);
        make.right.equalTo(-10);
    }];
    
    stepLabel.preferredMaxLayoutWidth = WIDTH-20;
    [stepLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stateLabel);
        make.top.equalTo(stateLabel.bottom).offset(15);
        make.right.equalTo(-10);
    }];
    
    [btnView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(stepLabel.bottom).offset(10);
        make.bottom.equalTo(-10);
    }];

    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.height.equalTo(1);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MyComplainModel *)model{
    _model = model;
    
    
    stateLabel.text = model.common;
    
    NSString *text = nil;
    for (int i = 1; i <= 6; i ++) {
        NSString *str = [NSString stringWithFormat:@"step%d",i];
        if (model.step[str]) {
            if (text) {
                text = [NSString stringWithFormat:@"%@\n%@",text,model.step[str]];
            }else{
                text = [model.step[str] copy];
            }
            
        }else{
            break;
        }
    }
    stepLabel.text = text;
    if([model.show integerValue] == 0 && [model.stepid integerValue] == 1){
        btnView.titles = @[@"查看详情",@"修  改"];

    }else if ([model.stepid integerValue] == 5) {
        btnView.titles = @[@"查看详情",@"再次投诉"];
        
    }else{
        btnView.titles = @[@"查看详情"];
    }
    [btnView updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(btnView.bounds.size);
    }];
}

@end
