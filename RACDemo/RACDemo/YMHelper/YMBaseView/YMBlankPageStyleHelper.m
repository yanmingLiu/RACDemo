//
//  YMBlankPageStyle.m
//  AihujuP
//
//  Created by lym on 2019/3/7.
//  Copyright © 2019 HUJU. All rights reserved.
//

#import "YMBlankPageStyleHelper.h"


@implementation YMBlankPageStyleHelper


/// 空白页显示图片
+ (UIImage *)imageForEmptyDataSet:(YMBlankPageStyle)style {
    switch (style) {
        case YMBlankPageStyleLoading:
            return [UIImage imageNamed:@"loading_imgBlue"];
        case YMBlankPageStyleNoDatas:
            return [UIImage imageNamed:@"noData"];
        case YMBlankPageStyleNoNetwork:
            return [UIImage imageNamed:@"noNetwork"];
        case YMBlankPageStyleNoServer:
            return [UIImage imageNamed:@"noServer"];

        default:
            return nil;
    }
    return nil;
}


/// 空白页显示详细描述
+ (NSAttributedString *)descriptionForEmptyDataSet:(YMBlankPageStyle)style {
    if (style == YMBlankPageStyleSuccess) {
        return nil;
    }
    NSString *text = @"";
    if (style == YMBlankPageStyleLoading) {
        text = @"正在加载...";
    }else if (style == YMBlankPageStyleNoNetwork) {
        text = @"连接服务器失败！";
    }else {
        text = @"sorry~什么也没有找到";
    }

    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor grayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


/// 空白页按钮
+ (NSAttributedString *)buttonTitleForEmptyDataSet:(YMBlankPageStyle)style {
    switch (style) {
        case YMBlankPageStyleSuccess:
        case YMBlankPageStyleLoading:
            return nil;

        case YMBlankPageStyleNoNetwork:
        case YMBlankPageStyleNoDatas:
        case YMBlankPageStyleNoServer:
        {
        NSString *text = @"请点击重试哦~";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
        // 设置所有字体大小为 #14
        [attStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.0]
                       range:NSMakeRange(0, text.length)];
        // 设置所有字体颜色为浅灰色
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:[UIColor grayColor]
                       range:NSMakeRange(0, text.length)];
        return attStr;
        }
    }
    return nil;
}



/// 动画
+ (CAAnimation *)imageAnimationForEmptyDataSet {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;

    return animation;
}

@end
