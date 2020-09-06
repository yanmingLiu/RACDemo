//
//  InputBoxView.h
//  Password
//
//  Created by lym on 2020/9/6.
//  Copyright © 2020 Devil. All rights reserved.
//

/// 密码输入
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TextDidChangeblock)(NSString * _Nullable text, BOOL isFinished);

@interface InputBoxView : UIView

/// 默认 NO
@property (nonatomic, assign) BOOL ifNeedSecurity;
/// 默认 UIKeyboardTypeNumberPad
@property (nonatomic, assign) UIKeyboardType keyBoardType;
/// 背景色
@property (nonatomic, strong) UIColor * _Nullable boxBgColor;
/// 字体
@property (nonatomic, strong) UIFont *boxFont;
/// 文字颜色
@property (nonatomic, strong) UIColor *boxTextColor;
/// 默认 4
@property (nonatomic, assign) CGFloat boxSpace;
/// 默认 4
@property (nonatomic, assign) CGFloat boxRadius;
/// 默认 0
@property (nonatomic, assign) CGFloat boxBorderWidth;
/// 默认 nil
@property (nonatomic, strong) UIColor *boxBorderColor;

@property (copy, nonatomic) TextDidChangeblock _Nullable textDidChangeblock;

- (instancetype)initWithCodeLength:(NSInteger)codeLength;

- (void)closeKeyborad;

- (void)showKeyborad;

- (void)clearAll;

@end

NS_ASSUME_NONNULL_END
