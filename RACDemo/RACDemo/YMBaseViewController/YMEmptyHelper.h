//
//  YMEmptyHelper.h
//  RACDemo
//
//  Created by lym on 2019/2/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 空白页
typedef NS_ENUM(NSUInteger, YMEmptyHelperStyle) {
    YMEmptyHelperStyleLoading,
    YMEmptyHelperStyleNotNetwork,
    YMEmptyHelperStyleNotDatas,
    YMEmptyHelperStyleSuccess,
};

@interface YMEmptyHelper : NSObject


/// 空白页显示图片
+ (UIImage *)imageForEmptyDataSet:(YMEmptyHelperStyle)style;

/// 空白页显示详细描述
+ (NSAttributedString *)descriptionForEmptyDataSet:(YMEmptyHelperStyle)style;

/// 空白页按钮
+ (NSAttributedString *)buttonTitleForEmptyDataSet:(YMEmptyHelperStyle)style;

/// 空白页加载动画
+ (CAAnimation *)imageAnimation;

@end

NS_ASSUME_NONNULL_END
