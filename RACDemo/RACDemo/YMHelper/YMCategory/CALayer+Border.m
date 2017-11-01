//
//  CALayer+Border.m
//  ExBusiness
//
//  Created by guiq on 15/7/13.
//  Copyright (c) 2015年 com.guiq. All rights reserved.
//

#import "CALayer+Border.h"
#import <objc/runtime.h>

@implementation CALayer (Border)

- (UIColor *)borderColorFromUIColor {
    
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
    
}

-(void)setBorderColorFromUIColor:(UIColor *)color

{
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBorderColorFromUI:color];
}

- (void)setBorderColorFromUI:(UIColor *)color

{
    self.borderColor = color.CGColor;
}

@end
