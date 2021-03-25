//
//  UIView+Guide.m
//  EGirl
//
//  Created by lym on 2021/3/22.
//  Copyright © 2021 EGirl. All rights reserved.
//

#import "UIView+Guide.h"

@implementation UIView (Guide)

- (void)hollowWithRect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius
{
    CGRect frame = self.bounds;
    // 第一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    // 透明path
    UIBezierPath *path2 = [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] bezierPathByReversingPath];

    [path appendPath:path2];
    // 绘制透明区域
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}


- (void)outLineWithlineWidth:(CGFloat)lineWidth
                 strokeColor:(UIColor *)strokeColor
                   fillColor:(UIColor *)fillColor
                cornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = strokeColor.CGColor;
    //填充的颜色
    border.fillColor = fillColor.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    //设置路径
    border.path = path.CGPath;
    border.frame = self.bounds;
    //虚线的宽度
    border.lineWidth = lineWidth;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:border];
}

@end
