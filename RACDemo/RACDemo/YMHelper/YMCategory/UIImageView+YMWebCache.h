//
//  UIImageView+YMWebCache.h
//  YMTextView
//
//  Created by yons on 15/2/13.
//  Copyright © 2015年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YMWebCache)

/**
 圆形imgeView + SDWebImg
 */
- (void)setCircleimageViewWithURL:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage;

/**
 带边框的圆形imgeView + SDWebImg
 */
- (void)setCircleimageViewWithURL:(NSString *)imageUrl placeholderImage:(NSString *)placeholderImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
