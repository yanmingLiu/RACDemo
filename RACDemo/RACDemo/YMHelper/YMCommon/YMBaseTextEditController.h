//
//  YMBaseTextEditController.h
//  ykxB
//
//  Created by lym on 2017/8/22.
//  Copyright © 2017年 liuyanming. All rights reserved.
//  有高度的

#import <UIKit/UIKit.h>
#import "YMTextView.h"


@interface YMBaseTextEditController : UIViewController

@property (nonatomic, strong) YMTextView *textView;

@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, copy) NSString * navTitle;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, copy) NSString * text;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, assign) NSInteger maxTextNum;

@property (nonatomic, copy) void(^editBlock)(NSString *text);

/// 保存
- (void)rightItemAction;

@end
