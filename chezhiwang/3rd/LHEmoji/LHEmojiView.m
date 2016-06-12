//
//  LHEmojiView.m
//  chezhiwang
//
//  Created by bangong on 15/11/9.
//  Copyright © 2015年 车质网. All rights reserved.
//

#import "LHEmojiView.h"
#import "LHEmojiButton.h"

@interface LHEmojiView ()
{
    UIScrollView *_emojiScrollView;
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) NSArray *imageNameArray;
@end
@implementation LHEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [self createScrollView];
    [self createData];
    [self shouImage];
}

-(void)createScrollView{
    _emojiScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _emojiScrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_emojiScrollView];
}

-(void)createData{
    _dataArray = [[NSMutableArray alloc] init];
    self.imageNameArray = @[@"微笑",@"难过",@"奋斗",@"左哼哼",@"撇嘴",@"酷",@"咒骂",@"右哼哼",@"色",@"冷汗",@"疑问",@"哈欠",
                            
                            @"发呆",@"抓狂",@"嘘",@"鄙视",@"得意",@"吐",@"晕",@"委屈",@"流泪",@"偷笑",@"折磨",@"快哭了",
                            
                            @"害羞",@"可爱",@"衰",@"阴险",@"闭嘴",@"白眼",@"骷髅",@"亲亲",@"睡",@"傲慢",@"敲打",@"吓",
                            
                            @"大哭",@"饥饿",@"再见",@"可怜",@"尴尬",@"困",@"冷汗",@"菜刀",@"发怒",@"惊恐",@"抠鼻",@"西瓜",
                            
                            @"调皮",@"流汗",@"鼓掌",@"啤酒",@"呲牙",@"憨笑",@"糗大了",@"惊讶",@"大兵",@"坏笑",@"乒乓",
                            
                            @"咖啡",@"月亮",@"爱情",@"便便",@"饭",@"太阳",@"瓢虫",@"飞吻",@"猪头",@"礼物",@"跳跳",@"足球",
                            
                            @"玫瑰",@"拥抱",@"发抖",@"刀",@"凋谢",@"强",@"怄火",@"炸弹",@"示爱",@"弱",@"转圈",@"闪电",
                            
                            @"爱心",@"握手",@"磕头",@"蛋糕",@"心碎",@"胜利",@"回头",@"跳绳",@"抱拳",@"勾引",@"挥手",@"激动",
                            
                            @"拳头",@"差劲",@"献吻",@"左太极",@"NO",@"爱你",@"OK",@"右太极"];
}


-(void)shouImage{
    CGFloat height = _emojiScrollView.frame.size.height/5+3;
    
    for (int i = 0; i < self.imageNameArray.count; i ++) {
        LHEmojiButton *btn = [LHEmojiButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(25+height*(i/4), 31+height*(i%4), 24, 24);
        NSString *iamgeName = [NSString stringWithFormat:@"%@.gif",self.imageNameArray[i]];
        [btn setBackgroundImage:[UIImage imageNamed:iamgeName] forState:UIControlStateNormal];
        btn.name = self.imageNameArray[i];
        [btn addTarget:self action:@selector(emojiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emojiScrollView addSubview:btn];
        if (i == self.imageNameArray.count - 1) {
            _emojiScrollView.contentSize = CGSizeMake(btn.frame.origin.x+60, 0);
        }
    }
}

-(void)emojiBtnClick:(LHEmojiButton *)btn{
    if (self.block) {
        self.block(btn.name);
    }
}

-(void)returnEmojiName:(returnEmojiNmae)block{
    self.block = block;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
