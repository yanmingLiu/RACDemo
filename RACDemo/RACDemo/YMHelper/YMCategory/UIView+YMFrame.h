
#import <UIKit/UIKit.h>

@interface UIView (YMFrame)


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


@end
