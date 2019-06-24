//
//  YMBaseTextViewController.m
//  ykxB
//
//  Created by lym on 2017/8/7.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMBaseTextViewController.h"


@interface YMBaseTextViewController () <UITextViewDelegate>


@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIView *line;

@end

@implementation YMBaseTextViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
    
    self.title = self.navTitle;
    _placeholderLabel.text = self.placeholderLabelText;
    _textView.text = self.text;
//    _textView.placeholder = self.placeholder;
    
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:(UIBarButtonItemStylePlain) target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem  = _rightItem;
}

- (void)saveAction{
    if (self.textView.text.length >= self.minTextNum && self.textView.text.length <= self.maxTextNum) {
        self.editBlock(self.textView.text);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.view makeToast:[NSString stringWithFormat:@"请输入%@", self.placeholderLabelText]];
    }
}

#pragma mark - setupUI

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    YMTextView *textView = [[YMTextView alloc] initWithFrame:CGRectMake(20, 20, screenWidth-40, 50)];
    textView.delegate = self;
    textView.font = FONT(15);
    textView.tintColor = [UIColor grayColor];
    [self.view addSubview:textView];
    _textView = textView;
        
    _line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(textView.frame)+1, screenWidth-40, 1)];
    _line.backgroundColor = RGB(8, 179, 129);
    [self.view addSubview:_line];
    
    CGRect labelF = CGRectMake(20, CGRectGetMaxY(_line.frame)+20, screenWidth-40, 20);
    _placeholderLabel = [[UILabel alloc] initWithFrame:labelF];
    _placeholderLabel.textColor = RGB(153, 153, 153);
    _placeholderLabel.font = FONT(13);
    [self.view addSubview:_placeholderLabel];
    
    @weakify(self);
    [RACObserve(textView, frame) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.line.y = CGRectGetMaxY(self.textView.frame)+1;
        self.placeholderLabel.y = CGRectGetMaxY(self.line.frame)+20; 
    }];
    
    // 输入限制
    [[textView rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        NSString *toBeString = x;
        NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > self.maxTextNum)  {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxTextNum];
                    if (rangeIndex.length == 1)  {
                        textView.text = [toBeString substringToIndex:self.maxTextNum];
                    }
                    else {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxTextNum)];
                        textView.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
        }
        else{ // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > self.maxTextNum)  {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxTextNum];
                if (rangeIndex.length == 1) {
                    textView.text = [toBeString substringToIndex:self.maxTextNum];
                }
                else  {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0,self.maxTextNum)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }];
}


#pragma mark - textView 自动高度

- (void)textViewDidChange:(UITextView *)textView  
{  
    if (textView.text.length > self.maxTextNum) {
        textView.text = [textView.text substringToIndex:self.maxTextNum];
    }
    [textView flashScrollIndicators];   // 闪动滚动条  
    
    static CGFloat maxHeight = 330.0f;  
    CGRect frame = textView.frame;  
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);  
    CGSize size = [textView sizeThatFits:constraintSize];  
    if (size.height >= maxHeight)  
    {  
        size.height = maxHeight;  
        textView.scrollEnabled = YES;   // 允许滚动  
    }  
    else  
    {  
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况  
    }  
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);  
}


@end
