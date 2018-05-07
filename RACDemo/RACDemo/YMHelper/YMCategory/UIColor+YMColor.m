//
//  UIColor+YMColor.m
//  TeacherHouAgency
//
//  Created by lym on 2018/4/1.
//  Copyright © 2018年 HShare. All rights reserved.
//

#import "UIColor+YMColor.h"

@implementation UIColor (YMColor)

+ (CAGradientLayer *)gradualChangColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}


@end
