//
//  YMEmptyHelper.m
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import "YMEmptyHelper.h"

@implementation YMEmptyHelper

+ (NSBundle *)ym_emptyBundle {
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        refreshBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[YMEmptyHelper class]] pathForResource:@"YMEmptyHelper" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)ym_loadImage:(NSString *)imageName {
    return [[UIImage imageWithContentsOfFile:[[self ym_emptyBundle] pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];;
}

/// 空白页显示图片
+ (UIImage *)imageForEmptyDataSet:(YMEmptyHelperStyle)style {

    switch (style) {
        case YMEmptyHelperStyleLoading:
            return [UIImage imageNamed:@"loading_imgBlue"];

        case YMEmptyHelperStyleNotDatas:
            return [UIImage imageNamed:@"not_network"];

        case YMEmptyHelperStyleNotNetwork:
            return [UIImage imageNamed:@"not_network"];

        default:
            return nil;
    }
    return nil;
}


/// 空白页显示详细描述
+ (NSAttributedString *)descriptionForEmptyDataSet:(YMEmptyHelperStyle)style {
    if (style == YMEmptyHelperStyleSuccess) {
        return nil;
    }
    NSString *text = @"";
    if (style == YMEmptyHelperStyleLoading) {
        text = @"正在加载...";
    }else if (style == YMEmptyHelperStyleNotNetwork) {
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
+ (NSAttributedString *)buttonTitleForEmptyDataSet:(YMEmptyHelperStyle)style {
    switch (style) {
        case YMEmptyHelperStyleSuccess:
        case YMEmptyHelperStyleLoading:
        case YMEmptyHelperStyleNotDatas:
            return nil;

        case YMEmptyHelperStyleNotNetwork:
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

/// 空白页加载动画
+ (CAAnimation *)imageAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;

    return animation;
}

@end
