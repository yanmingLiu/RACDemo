//
//  UIColor+Hex.h
//  post
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 mac. All rights reserved.
//

/**
 *  十六进制转成UIColor
 *
 *  @param R
 *  @param G
 *  @param B
 *
 *  @return 
 */

#import <UIKit/UIKit.h>

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]


@interface UIColor (Hex)

+ (instancetype)colorWithHexString:(NSString *)hexString;
+ (instancetype)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue;
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

- (NSString *)hexString;

@end
