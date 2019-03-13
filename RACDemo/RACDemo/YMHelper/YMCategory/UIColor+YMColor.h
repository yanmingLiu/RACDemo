//
//  UIColor+YMColor.h
//  TeacherHouAgency
//
//  Created by lym on 2018/4/1.
//  Copyright © 2018年 HShare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YMColor)

/// 设置渐变色
+ (CAGradientLayer *)gradualChangColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;


//如果hexString是8位则参数alpha失效,使用hexString包含的alpha
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/// UIColor转换成十六进制颜色值
- (NSString *)hexString;

@end
