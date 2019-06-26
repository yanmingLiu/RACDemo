//
//  UIView+YMFrame.h
//  TeacherHou
//
//  Created by lym on 2018/1/23.
//  Copyright © 2018年 HShare. All rights reserved.
//

#import <UIKit/UIKit.h>

// 基准屏幕宽度
#define kRefereWidth 375.0
// 以屏幕宽度为固定比例关系，来计算对应的值。假设：基准屏幕宽度375，floatV=10；当前屏幕宽度为750时，那么返回的值为20
#define AdaptW(floatValue) (floatValue*[[UIScreen mainScreen] bounds].size.width/kRefereWidth)

/// 动态适配
typedef NS_ENUM(NSInteger, AdaptScreenWidthType) {
    AdaptScreenWidthTypeConstraint = 1<<0, /**< 对约束的constant等比例 */
    AdaptScreenWidthTypeFontSize = 1<<1, /**< 对字体等比例 */
    AdaptScreenWidthTypeCornerRadius = 1<<2, /**< 对圆角等比例 */
    AdaptScreenWidthTypeAll = 1<<3, /**< 对现有支持的属性等比例 */
};

@interface UIView (YMAdd)


@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property(nonatomic, assign) CGFloat left;

@property(nonatomic, assign) CGFloat right;

@property(nonatomic, assign) CGFloat top;

@property(nonatomic, assign) CGFloat bottom;

@property(nonatomic, assign) CGFloat width;

@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat offsetX;

@property(nonatomic, assign) CGFloat offsetY;

@property(nonatomic, assign) CGSize size;

@property(nonatomic, assign) CGPoint origin;

@property(nonatomic, assign) CGFloat centerX;

@property(nonatomic, assign) CGFloat centerY;

@property (nonatomic,assign) CGFloat max_X;

@property (nonatomic,assign) CGFloat max_Y;

/// 设置了 IBInspectable  sb xib上就可以直接设置layer
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;

/**
 *  判断是否显示在主窗口上面
 *
 *  @return 是否
 */
- (BOOL)isShowOnWindow;

/** 父控制器 */
- (UIViewController *)parentController;

/**
 *  给view切圆角
 *  corners : 哪个角
 *  cornerRadii : 圆角size
 */
- (instancetype)cornerByRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;
/**
 *  给view所有角切圆角
 *  cornerRadii : 圆角size
 */
- (instancetype)cornerAllCornersWithCornerRadius:(CGFloat)cornerRadius;

/**
 遍历当前view对象的subviews和constraints，对目标进行等比例换算

 @param type 想要和基准屏幕等比例换算的属性类型
 @param exceptViews 需要对哪些类进行例外
 */
- (void)adaptScreenWidthWithType:(AdaptScreenWidthType)type
                     exceptViews:(NSArray<Class> *)exceptViews;


@end
