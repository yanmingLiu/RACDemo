//
//  YMBaseTextEditController.m
//  ykxB
//
//  Created by lym on 2017/8/22.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMBaseTextEditController.h"
#import "UIBarButtonItem+Extension.h"

@interface YMBaseTextEditController () <UITextViewDelegate>

@end

@implementation YMBaseTextEditController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    
    self.title = self.navTitle;
    _textView.text = self.text;
    
    if (!self.text.length) {
        _textView.placeholder = self.placeholder;
    }
    
    _rightItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightItemAction) title:@"保存" titleColor:[UIColor grayColor]];
    self.navigationItem.rightBarButtonItem  = _rightItem;
    
    
    NSInteger kMaxLength = self.maxTextNum;
    @weakify(self);
    [[self.textView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSString *toBeString = x;
        //if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self.textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= kMaxLength) {
                self.textView.text = [toBeString substringToIndex:kMaxLength];
                self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.textView.text.length, kMaxLength];
                [self.view endEditing:YES];
            }else{
                self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd",self.textView.text.length, kMaxLength];
            }
        }
    }];
}

- (void)rightItemAction {
    if (self.textView.text.length <= self.maxTextNum) {
        if (self.editBlock) {
            self.editBlock(self.textView.text);
            NSLog(@"返回值=====%@",self.textView.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [MBProgressHUD bwm_showTitle:@"请输入有效文字" toView:self.view hideAfter:MBHiddenTime];
    }
}

#pragma mark - setupUI

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    YMTextView *textView = [[YMTextView alloc] initWithFrame:CGRectMake(20, 20, screenWidth-40, self.view.bounds.size.height / 2)];
    textView.delegate = self;
    textView.font = FONT(15);
    textView.tintColor = [UIColor grayColor];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    textView.returnKeyType = UIReturnKeyDone;
    _textView = textView;
   
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame)+10, screenWidth-40, 22)];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.text = @"0/50";
    countLabel.textColor = [UIColor grayColor];
    countLabel.font = FONT(12);
    [self.view addSubview:countLabel];
    _countLabel = countLabel;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame)+10, screenWidth-80, 50)];
    tipsLabel.text = [NSString stringWithFormat:@"最多可以填写%zd个汉字，\n标点符号、空格也会计算在内！", self.maxTextNum];
    tipsLabel.font = FONT(12);
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    
}



@end
