//
//  UIImage+Group.h
//  GroupChatIcon
//
//  Created by lym on 2019/7/19.
//  Copyright © 2019 KH. All rights reserved.
//
// 类似微信群头像处理

#import <UIKit/UIKit.h>
#import "NSString+YMAdd.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Group)


+ (void)groupIconWithUrls:(NSArray *)urls size:(CGSize)size padding:(CGFloat)padding bgColor:(UIColor *)bgColor defaultImg:(UIImage *)defaultImg callback:(void(^)(UIImage *image))callback;

+ (UIImage *)groupIconWithImages:(NSArray *)images size:(CGSize)size padding:(CGFloat)padding bgColor:(UIColor *)bgColor;


@end

NS_ASSUME_NONNULL_END
