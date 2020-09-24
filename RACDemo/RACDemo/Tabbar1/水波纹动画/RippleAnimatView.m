//
//  RippleAnimatView.m
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/19.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "RippleAnimatView.h"

@interface RippleAnimatView ()<CAAnimationDelegate>

@property (nonatomic, strong) CALayer *animationLayer;

@end

@implementation RippleAnimatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _rippleCount = 5;
        _rippleDuration = 3;
        
        _minRadius = 20;
        _maxRadius = 60;
    }
    return self;
}

- (void)stopAnimation {
    [self.animationLayer removeFromSuperlayer];
    self.animationLayer = nil;
}


- (void)startAnimation {
    if (!self.animationLayer) {
        [self makeAnimationLayer];
    }
    [self.layer addSublayer:self.animationLayer];
}


- (void)makeAnimationLayer {
    CALayer *animationLayer = [CALayer layer];
    for (int i = 0; i < _rippleCount; i++) {
        CALayer *pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, _maxRadius * 2, _maxRadius * 2);
        pulsingLayer.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.width / 2);
        if (!_rippleColor) {
            _rippleColor = [UIColor colorWithWhite:1 alpha:0.7];
        }
        pulsingLayer.backgroundColor = [_rippleColor CGColor];
        pulsingLayer.cornerRadius = _maxRadius;
        pulsingLayer.borderColor = [_borderColor CGColor];
        pulsingLayer.borderWidth = _borderWidth;

        CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + i * _rippleDuration / _rippleCount;
        animationGroup.duration = _rippleDuration;
        animationGroup.repeatCount = 0;
        animationGroup.timingFunction = defaultCurve;
        animationGroup.delegate = self;

        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(_minRadius / _maxRadius);
        scaleAnimation.toValue = @1.0;

        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];

        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        
        [animationLayer addSublayer:pulsingLayer];
    }
    self.animationLayer = animationLayer;
    [self.layer insertSublayer:animationLayer atIndex:0];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self stopAnimation];
    }
}


@end
