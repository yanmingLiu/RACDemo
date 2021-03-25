//
//  UIView+Guide.h
//  EGirl
//
//  Created by lym on 2021/3/22.
//  Copyright © 2021 EGirl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Guide)
// 挖空
- (void)hollowWithRect:(CGRect)rect
          cornerRadius:(CGFloat)cornerRadius;

// 虚线边框
- (void)outLineWithlineWidth:(CGFloat)lineWidth
                 strokeColor:(UIColor *)strokeColor
                   fillColor:(UIColor *)fillColor
                cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
