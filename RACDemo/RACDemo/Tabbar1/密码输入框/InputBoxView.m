//
//  InputBoxView.m
//  Password
//
//  Created by lym on 2020/9/6.
//  Copyright © 2020 Devil. All rights reserved.
//

#import "InputBoxView.h"

#define LableTag 100

@interface InputBoxView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *pswTF;

@property (nonatomic, assign) NSInteger codeLength;

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation InputBoxView

- (UITextField *)pswTF {
    if (!_pswTF) {
        _pswTF = [[UITextField alloc] init];
        _pswTF.delegate = self;
        _pswTF.keyboardType = UIKeyboardTypeNumberPad;
        [_pswTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pswTF;
}

- (NSMutableArray *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (instancetype)initWithCodeLength:(NSInteger)codeLength {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.codeLength = codeLength;
        self.ifNeedSecurity = NO;
        self.boxBgColor = [UIColor clearColor];
        self.boxFont = [UIFont systemFontOfSize:16];
        self.boxTextColor = [UIColor blackColor];
        self.boxSpace = 4;
        self.boxRadius = 4;
        self.boxBorderWidth = 0;
        self.boxBorderColor = [UIColor clearColor];
        self.keyBoardType = UIKeyboardTypeNumberPad;

        [self initUI];

        [self setupLayout];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyborad)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 设置UI
- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;

    [self addSubview:self.pswTF];

    for (int i = 0; i < self.codeLength; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = LableTag + i;
        label.clipsToBounds = YES;
        [self addSubview:label];
        [self.labels addObject:label];
    }
}

- (void)setupLayout {
    // 实现masonry水平固定间隔方法
    [self.labels mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:self.boxSpace leadSpacing:0 tailSpacing:0];
    // 设置array的垂直方向的约束
    [self.labels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];
}

- (void)refreshUI {
    for (UILabel *label in self.labels) {
        label.font = self.boxFont;
        label.backgroundColor = self.boxBgColor;
        label.textColor = self.boxTextColor;
        label.layer.cornerRadius = self.boxRadius;
        label.layer.borderWidth = self.boxBorderWidth;
        label.layer.borderColor = self.boxBorderColor.CGColor;
    }
}

#pragma mark - 监视textField值
- (void)valueChange:(UITextField *)textField {
    NSString *text = textField.text;
    if (text.length <= self.codeLength) {
        for (int i = 0; i < self.codeLength; i++) {
            UILabel *label = (UILabel *)[self viewWithTag:LableTag + i];
            if (i < text.length) {
                label.text = self.ifNeedSecurity ? @"●" : [text substringWithRange:NSMakeRange(i, 1)];
            } else {
                label.text = @"";
            }
        }
    } else {
        textField.text = [text substringWithRange:NSMakeRange(0, self.codeLength)];
    }

    if (self.textDidChangeblock) {
        self.textDidChangeblock(text, textField.text.length == self.codeLength);
    }
}

- (void)showKeyborad {
    [self.pswTF becomeFirstResponder];
}

- (void)closeKeyborad {
    [self.pswTF resignFirstResponder];
}

- (void)clearAll {
    self.pswTF.text = @"";
}

- (void)setIfNeedSecurity:(BOOL)ifNeedSecurity {
    _ifNeedSecurity = ifNeedSecurity;
    [self refreshUI];
}

- (void)setBoxFont:(UIFont *)boxFont {
    _boxFont = boxFont;
    [self layoutSubviews];
}

- (void)setKeyBoardType:(UIKeyboardType)keyBoardType {
    _keyBoardType = keyBoardType;
    self.pswTF.keyboardType = keyBoardType;
}

- (void)setBoxBgColor:(UIColor *)boxBgColor {
    _boxBgColor = boxBgColor;
    [self refreshUI];
}

- (void)setBoxTextColor:(UIColor *)boxTextColor {
    _boxTextColor = boxTextColor;
    [self refreshUI];
}

- (void)setBoxSpace:(CGFloat)boxSpace {
    _boxSpace = boxSpace;
    [self refreshUI];
}

- (void)setBoxRadius:(CGFloat)boxRadius {
    _boxRadius = boxRadius;
    [self refreshUI];
}

- (void)setBoxBorderWidth:(CGFloat)boxBorderWidth {
    _boxBorderWidth = boxBorderWidth;
    [self refreshUI];
}

- (void)setBoxBorderColor:(UIColor *)boxBorderColor {
    _boxBorderColor = boxBorderColor;
    [self refreshUI];
}

@end
