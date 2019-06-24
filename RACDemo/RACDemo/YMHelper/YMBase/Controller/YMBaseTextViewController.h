//
//  YMBaseTextViewController.h
//  ykxB
//
//  Created by lym on 2017/8/7.
//  Copyright © 2017年 liuyanming. All rights reserved.
//  textView 自动高度

#import <UIKit/UIKit.h>
#import "YMTextView.h"

@interface YMBaseTextViewController : UIViewController

@property (nonatomic, strong) YMTextView *textView;

@property (nonatomic, copy) NSString * navTitle;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@property (nonatomic, copy) NSString * text;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, copy) NSString * placeholderLabelText;

@property (nonatomic, assign) NSInteger maxTextNum;
@property (nonatomic, assign) NSInteger minTextNum;

@property (nonatomic, copy) void(^editBlock)(NSString *text);

- (void)saveAction;

@end
