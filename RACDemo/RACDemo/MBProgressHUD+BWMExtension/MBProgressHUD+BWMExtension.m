//
//  MBProgressHUD+BWMExtension.m
//  Example
//
//  Created by 伟明 毕 on 15/7/20.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "MBProgressHUD+BWMExtension.h"

NSString * const kBWMMBProgressHUDMsgLoading = @"正在加载...";
NSString * const kBWMMBProgressHUDMsgLoadError = @"加载失败";
NSString * const kBWMMBProgressHUDMsgLoadSuccessful = @"加载成功";
NSString * const kBWMMBProgressHUDMsgNoMoreData = @"没有更多数据了";
NSTimeInterval kBWMMBProgressHUDHideTimeInterval = 1.2f;

static CGFloat FONT_SIZE = 14.0f;
static CGFloat OPACITY = 0.85;

static NSInteger MBHiddenTime = 1.5;

#define Keywindow  [UIApplication sharedApplication].keyWindow

@implementation MBProgressHUD (BWMExtension)

+ (MBProgressHUD *)bwm_showHUDAddedTo:(UIView *)view title:(NSString *)title animated:(BOOL)animated {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.text = title;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    return HUD;
}

+ (MBProgressHUD *)bwm_showHUDAddedTo:(UIView *)view title:(NSString *)title {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.text = title;
    return HUD;
}

- (void)bwm_hideWithTitle:(NSString *)title hideAfter:(NSTimeInterval)afterSecond {
    if (title) {
        self.detailsLabel.text = title;
        self.mode = MBProgressHUDModeText;
    }
    [self hideAnimated:YES afterDelay:afterSecond];
}

- (void)bwm_hideAfter:(NSTimeInterval)afterSecond {
    [self hideAnimated:YES afterDelay:afterSecond];
}

- (void)bwm_hideWithTitle:(NSString *)title
                hideAfter:(NSTimeInterval)afterSecond
                  msgType:(BWMMBProgressHUDMsgType)msgType {
    self.detailsLabel.text = title;
    self.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.mode = MBProgressHUDModeCustomView;
    self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[self class ]p_imageNamedWithMsgType:msgType]]];
    [self hideAnimated:YES afterDelay:afterSecond];
}

+ (MBProgressHUD *)bwm_showTitle:(NSString *)title toView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.text = title;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [HUD hideAnimated:YES afterDelay:afterSecond];
    return HUD;
}

+ (MBProgressHUD *)bwm_showTitle:(NSString *)title
                      toView:(UIView *)view
                   hideAfter:(NSTimeInterval)afterSecond
                     msgType:(BWMMBProgressHUDMsgType)msgType {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    NSString *imageNamed = [self p_imageNamedWithMsgType:msgType];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
    HUD.detailsLabel.text = title;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [HUD hideAnimated:YES afterDelay:afterSecond];
    return HUD;
}

+ (NSString *)p_imageNamedWithMsgType:(BWMMBProgressHUDMsgType)msgType {
    NSString *imageNamed = nil;
    if (msgType == BWMMBProgressHUDMsgTypeSuccessful) {
        imageNamed = @"MBExtension.bundle/hud_success";
    } else if (msgType == BWMMBProgressHUDMsgTypeError) {
        imageNamed = @"MBExtension.bundle/hud_error";
    } else if (msgType == BWMMBProgressHUDMsgTypeWarning) {
        imageNamed = @"MBExtension.bundle/hud_warning";
    } else if (msgType == BWMMBProgressHUDMsgTypeInfo) {
        imageNamed = @"MBExtension.bundle/hud_info";
    }
    return imageNamed;
}

+ (MBProgressHUD *)bwm_showDeterminateHUDTo:(UIView *)view {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    HUD.animationType = MBProgressHUDAnimationZoom;
    HUD.detailsLabel.text = kBWMMBProgressHUDMsgLoading;
    HUD.label.font = [UIFont systemFontOfSize:FONT_SIZE];
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    return HUD;
}

+ (void)bwm_setHideTimeInterval:(NSTimeInterval)second fontSize:(CGFloat)fontSize opacity:(CGFloat)opacity {
    kBWMMBProgressHUDHideTimeInterval = second;
    FONT_SIZE = fontSize;
    OPACITY = opacity;
}

+ (void)showFailureText:(NSString *)text {
    [self bwm_showTitle:text toView:Keywindow hideAfter:MBHiddenTime msgType:BWMMBProgressHUDMsgTypeError];
}

+ (void)showSuccessText:(NSString *)text {
    [self bwm_showTitle:text toView:Keywindow hideAfter:MBHiddenTime msgType:BWMMBProgressHUDMsgTypeSuccessful];
}

+ (void)showToastText:(NSString *)text {
    [self bwm_showTitle:text toView:Keywindow hideAfter:MBHiddenTime];
}




@end
