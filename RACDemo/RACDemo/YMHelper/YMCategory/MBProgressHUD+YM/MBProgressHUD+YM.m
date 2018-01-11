//
//  MBProgressHUD+YM.m
//  Example
//
//  Created by lym on 2017/11/28.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "MBProgressHUD+YM.h"

static CGFloat FontSize = 14.0f;
static CGFloat MBHiddenTime = 1.2;


@implementation MBProgressHUD (YM)

/// 显示带文字的加载。。。
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated text:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    HUD.label.font = [UIFont systemFontOfSize:FontSize];
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FontSize];
    return HUD;
}


+ (MBProgressHUD *)showView:(UIView *)view hideAfter:(NSTimeInterval)afterSecond text:(NSString *)text {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.font = [UIFont systemFontOfSize:FontSize];
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FontSize];
    [HUD hideAnimated:YES afterDelay:afterSecond];
    return HUD;
}

/// 显示一个自定的HUD
+ (MBProgressHUD *)showView:(UIView *)view style:(HUDStyle)style hideAfter:(NSTimeInterval)afterSecond text:(NSString *)text {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeCustomView;
    
    NSString *imageNamed = [self imageNamedWithStyle:style];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
    HUD.detailsLabel.text = text;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:FontSize];
    [HUD hideAnimated:YES afterDelay:afterSecond];
    return HUD;
}

+ (void)showFailureText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showView:[UIApplication sharedApplication].keyWindow style:HUDStyleError hideAfter:MBHiddenTime text:text];
    });
    
}

+ (void)showSuccessText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showView:[UIApplication sharedApplication].keyWindow style:HUDStyleSuccess hideAfter:MBHiddenTime text:text];
    });
}

+ (void)showToastText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showView:[UIApplication sharedApplication].keyWindow hideAfter:MBHiddenTime text:text];
    });
}

#pragma mark - private

+ (NSString *)imageNamedWithStyle:(HUDStyle)msgType {
    NSString *imageNamed = nil;
    if (msgType == HUDStyleSuccess) {
        imageNamed = @"MBExtension.bundle/hud_success";
    } else if (msgType == HUDStyleError) {
        imageNamed = @"MBExtension.bundle/hud_error";
    } else if (msgType == HUDStyleWarning) {
        imageNamed = @"MBExtension.bundle/hud_warning";
    } else if (msgType == HUDStyleInfo) {
        imageNamed = @"MBExtension.bundle/hud_info";
    }
    return imageNamed;
}

@end
