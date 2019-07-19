//
//  UIImage+Group.h
//  GroupChatIcon
//
//  Created by lym on 2019/7/19.
//  Copyright © 2019 KH. All rights reserved.
//
// 类似微信群头像处理

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Group)

+ (UIImage *)groupIconWithURLArray:(NSArray *)URLArray finalSize:(CGSize)finalSize padding:(CGFloat)padding bgColor:(UIColor *)bgColor;

+ (UIImage *)groupIconWithImageArray:(NSArray *)imageArray finalSize:(CGSize)finalSize padding:(CGFloat)padding bgColor:(UIColor *)bgColor;


@end

NS_ASSUME_NONNULL_END
