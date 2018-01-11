/*
 *********************************************************************************
 *
 *
 * 本工具是对 MBProgressHUD 的扩展
 *
 * 
 *********************************************************************************
 */

#import "MBProgressHUD.h"

typedef NS_ENUM(NSUInteger, HUDStyle) {
    HUDStyleSuccess,
    HUDStyleError,
    HUDStyleWarning,
    HUDStyleInfo
};

@interface MBProgressHUD (YM)

/// 显示带文字的加载。。。
+ (MBProgressHUD *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated text:(NSString *)text;

/// 自定的HUD
+ (MBProgressHUD *)showView:(UIView *)view style:(HUDStyle)style hideAfter:(NSTimeInterval)afterSecond text:(NSString *)text;

/// 显示失败信息
+ (void)showFailureText:(NSString *)text;
/// 显示成功信息
+ (void)showSuccessText:(NSString *)text;
/// 显示信息
+ (void)showToastText:(NSString *)text;

@end
