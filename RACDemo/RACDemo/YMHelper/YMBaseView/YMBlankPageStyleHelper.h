//
//  YMBlankPageStyle.h
//  AihujuP
//
//  Created by lym on 2019/3/7.
//  Copyright © 2019 HUJU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 空白页
typedef NS_ENUM(NSUInteger, YMBlankPageStyle) {
    YMBlankPageStyleLoading = 0,
    YMBlankPageStyleNoNetwork,
    YMBlankPageStyleNoDatas,
    YMBlankPageStyleNoServer,
    YMBlankPageStyleSuccess,
};

@interface YMBlankPageStyleHelper : NSObject


/// 空白页显示图片
+ (UIImage *)imageForEmptyDataSet:(YMBlankPageStyle)style;

/// 空白页显示详细描述
+ (NSAttributedString *)descriptionForEmptyDataSet:(YMBlankPageStyle)style;

/// 空白页按钮
+ (NSAttributedString *)buttonTitleForEmptyDataSet:(YMBlankPageStyle)style;

/// 动画
+ (CAAnimation *)imageAnimationForEmptyDataSet;

@end

NS_ASSUME_NONNULL_END
