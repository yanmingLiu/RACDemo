//
//  CircleProgressView.m
//  RACDemo
//
//  Created by lym on 2020/5/18.
//

#import "CircleProgressView.h"

@interface CircleProgressView ()


@property(nonatomic, strong) CAShapeLayer *progressLayer;
@property(nonatomic, strong) CAShapeLayer *trackLayer;
@property(nonatomic, strong) CALayer *gradientLayer;

@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = 4;
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _lineWidth = 4;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGPoint arcCenter = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    CGFloat radius = self.frame.size.width/2;
    
    // 圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                        radius:radius
                                                    startAngle:M_PI_2
                                                      endAngle:M_PI*2+M_PI_2
                                                     clockwise:YES];
    // 轨道
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.path = path.CGPath;
    trackLayer.fillColor = [UIColor clearColor].CGColor;//图形填充色
    trackLayer.strokeColor =  [UIColor clearColor].CGColor;//边线颜色
    trackLayer.lineWidth = self.lineWidth;
    [self.layer addSublayer:trackLayer];
    _trackLayer = trackLayer;
    
    // 渐变图层
    CALayer * gradientLayer = [CALayer layer];
    [self.layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
    
    // 左边渐变
    CAGradientLayer *leftLayer =  [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(-_lineWidth, -_lineWidth, self.frame.size.width/2+_lineWidth*2, self.frame.size.height+_lineWidth*2);
    [leftLayer setColors:[NSArray arrayWithObjects:
                          (id)[[UIColor colorWithHexString:@"#FF6C03"] CGColor],
                          (id)[[UIColor colorWithHexString:@"#FF9B03"] CGColor], nil]];
    
    [leftLayer setLocations:@[@0.0,@1.0]];
    [leftLayer setStartPoint:CGPointMake(0.5, 1)];
    [leftLayer setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:leftLayer];
    
    // 右边边渐变
    CAGradientLayer * rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.frame.size.width/2-_lineWidth, -_lineWidth, self.frame.size.width/2+_lineWidth*2, self.frame.size.height+_lineWidth*2);
    [rightLayer setColors:[NSArray arrayWithObjects:
                           (id)[[UIColor colorWithHexString:@"#FF9B03"] CGColor],
                           (id)[[UIColor colorWithHexString:@"#FF6C03"] CGColor], nil]];

    [rightLayer setLocations:@[@0.0,@1.0]];
    [rightLayer setStartPoint:CGPointMake(0.5, 0)];
    [rightLayer setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:rightLayer];
    
    // 进度layer
    _progressLayer = [CAShapeLayer layer];
    [self.layer addSublayer:_progressLayer];
    _progressLayer.path = path.CGPath;
    _progressLayer.strokeColor = [UIColor blueColor].CGColor;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.strokeEnd = _progress;

    //设置遮盖层
    _gradientLayer.mask = _progressLayer;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self setupUI];
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;
    
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *c in colors) {
        [cgColors addObject:(id)c.CGColor];
    }
    
    CAGradientLayer *leftLayer = _gradientLayer.sublayers.firstObject;
    CAGradientLayer *rightLayer = _gradientLayer.sublayers.lastObject;
    [leftLayer setColors:cgColors.copy];
    [rightLayer setColors:cgColors.reverseObjectEnumerator.allObjects.copy];
}


-(void)setProgress:(CGFloat)progress {

    [self startAnimationWithProgress:progress];
}

-(void)startAnimationWithProgress:(CGFloat)progress {
	//增加动画
	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.duration = 1.5;
	pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	pathAnimation.toValue = [NSNumber numberWithFloat:progress];
	pathAnimation.autoreverses = NO;

	pathAnimation.fillMode = kCAFillModeForwards;
	pathAnimation.removedOnCompletion = NO;
	pathAnimation.repeatCount = 1;
	[_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end
