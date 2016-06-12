//
//  Header.h
//  chezhiwang
//
//  Created by bangong on 15/11/5.
//  Copyright © 2015年 车质网. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define RGB_color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define colorBlack RGB_color(51,51,51,1)//标题浅黑
#define colorDeepGray RGB_color(102,102,102,1)//深灰
#define colorLightGray RGB_color(153,153,153,1)//浅灰
#define colorLightBlue RGB_color(6,143,206,1)//浅蓝
#define colorDeepBlue RGB_color(0,125,184,1)//深蓝
#define colorLineGray RGB_color(229,229,229,1)//线条灰
#define colorYellow RGB_color(255,147,4,1)//文字黄
#define colorOrangeRed RGB_color(255,84,0,1)//橙红色
//论坛类型
typedef enum {
    forumClassifyBrand,//品牌论坛
    forumClassifyColumn//栏目论坛
}forumClassify;

//跳转还是返回
typedef enum {
    classifyNextPush,
    classifyNextPop
}classifyNext;


#endif /* Header_h */
