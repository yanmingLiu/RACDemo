//
//  YMTextView.m
//  YMTextView
//
//  Created by yons on 17/2/13.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "YMTextView.h"
#import "UIView+Frame.h"

@interface YMTextView ()

@property (nonatomic, weak) UILabel *placeHolderLabel;

@end

@implementation YMTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        
        self.placeholderColor = [UIColor lightGrayColor];
        
        self.selectedRange = NSMakeRange(0, 8);
        
    }
    
    // 监听文本框的输入
    /**
     *  Observer:谁需要监听通知
     *  name：监听的通知的名称
     *  object：监听谁发送的通知，nil:表示谁发送我都监听
     *
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:self];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 监听文本框的输入
- (void)textChange {
    // 判断下textView有木有内容
    if (self.hasText) { // 有内容
        self.hidePlaceholder = YES;
    }else{
        self.hidePlaceholder = NO;
    }
}


- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        
        [self addSubview:label];
        
        _placeHolderLabel = label;
        
    }
    
    return _placeHolderLabel;
}


#pragma mark - setter

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    self.placeHolderLabel.text = placeholder;
    // label的尺寸跟文字一样
    [self.placeHolderLabel sizeToFit];
}

- (void)setHidePlaceholder:(BOOL)hidePlaceholder
{
    _hidePlaceholder = hidePlaceholder;
    
    self.placeHolderLabel.hidden = hidePlaceholder;
    
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    self.placeHolderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeHolderLabel.font = font;
    [self.placeHolderLabel sizeToFit];
}


#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeHolderLabel.left = 5;
    self.placeHolderLabel.top = 8;
    self.placeHolderLabel.width = self.width - 2 * self.placeHolderLabel.left;
    
    //    NSLog(@"%@",self.font);
    //    self.placeHolderLabel.font = self.font;
}

@end
