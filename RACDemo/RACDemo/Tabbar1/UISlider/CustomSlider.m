//
//  CustomSlider.m
//  RACDemo
//
//  Created by lym on 2020/10/14.
//

#import "CustomSlider.h"

@implementation CustomSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds.size.height = 6;
    self.layer.cornerRadius = 2.5;
    return bounds;
}

// 改变滑块的触摸范围
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.y = rect.origin.y - 10;
    rect.size.height = rect.size.height + 20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], 5, 5);
}

@end
