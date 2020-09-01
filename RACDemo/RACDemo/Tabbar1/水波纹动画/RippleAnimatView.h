//
//  RippleAnimatView.h
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/19.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RippleAnimatView : UIView

/// 脉冲数量 默认5
@property (nonatomic, assign) NSInteger rippleCount;
/// 脉冲时间 默认3
@property (nonatomic, assign) CGFloat   rippleDuration;
/// 脉冲颜色 
@property (nonatomic, strong) UIColor   *rippleColor;
/// 开始Radius 默认 20
@property (nonatomic, assign) CGFloat minRadius;
/// 结束Radius 默认60
@property (nonatomic, assign) CGFloat maxRadius;
/// 边框颜色
@property (nonatomic, strong) UIColor   *borderColor;
/// 边框宽度
@property (nonatomic, assign) CGFloat   borderWidth;


- (void)startAnimation;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
