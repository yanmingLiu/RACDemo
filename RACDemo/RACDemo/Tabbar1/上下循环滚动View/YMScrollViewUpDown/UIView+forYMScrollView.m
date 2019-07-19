//
//  UIView+forYMScrollView.m
//  上下循环滚动View
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+forYMScrollView.h"

@implementation UIView (forYMScrollView)

- (UIView *)copyView{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end
