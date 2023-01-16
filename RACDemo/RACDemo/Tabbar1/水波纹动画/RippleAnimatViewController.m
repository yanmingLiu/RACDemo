//
//  RippleAnimatViewController.m
//  RACDemo
//
//  Created by lym on 2019/8/22.
//

#import "RippleAnimatViewController.h"
#import "RippleAnimatView.h"

@interface RippleAnimatViewController ()

@property (nonatomic, strong) CAReplicatorLayer *replayer;

@property (nonatomic, assign) BOOL isStop;

@property (nonatomic, strong) RippleAnimatView *rv;


@end

@implementation RippleAnimatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self cirAction];
    
    RippleAnimatView *rv = [[RippleAnimatView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    rv.minRadius = 40;
    rv.maxRadius = 60;
    rv.rippleCount = 5;
    rv.rippleDuration = 1.0;
    rv.rippleColor = [UIColor clearColor];
    rv.borderWidth = 1;
    rv.borderColor = [UIColor blueColor];
    rv.backgroundColor = [UIColor grayColor];
    [self.view addSubview:rv];
    rv.center = self.view.center;
    
    [rv startAnimation];
    
    self.rv = rv;
}

- (void)cirAction
{
    CAShapeLayer *sharLayer = [CAShapeLayer layer];
    sharLayer.backgroundColor = [UIColor redColor].CGColor;
    sharLayer.bounds = CGRectMake(0, 0, 20, 20);
    sharLayer.position = CGPointMake(kScreenWidth/2, 150);
    sharLayer.cornerRadius = 10;
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform"];
    ani.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(10, 10, 1)];
    ani.duration = 2;
    
    CABasicAnimation *ani1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ani1.fromValue = @1;
    ani1.toValue = @0;
    ani1.duration = 2;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[ani,ani1];
    group.duration = 4;
    group.repeatCount = HUGE;
    [sharLayer addAnimation:group forKey:nil];
    
    CAReplicatorLayer *replayer  =[CAReplicatorLayer layer];
    [replayer addSublayer:sharLayer];
    replayer.instanceCount = 3;
    replayer.instanceDelay = 0.5;
    self.replayer = replayer;
    
    [self.view.layer addSublayer:replayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.rv startAnimation];
    
    _isStop = !_isStop;
    if (_isStop) {
        [self.replayer removeFromSuperlayer];
        self.replayer = nil;
    }else {
        [self cirAction];
    }
}

/*
@interface CAReplicatorLayer : CALayer

//指定图层重复制多少次
@property NSInteger instanceCount;

//设置为YES,图层将保持于CATransformLayer类似的性质和相同的限制
@property BOOL preservesDepth;

//复制延时，一般用在动画上
@property CFTimeInterval instanceDelay;

//3D变换
@property CATransform3D instanceTransform;

//设置多个复制图层的颜色,默认位白色
@property(nullable) CGColorRef instanceColor;

//设置每个复制图层相对上一个复制图层的红色、绿色、蓝色、透明度偏移量
@property float instanceRedOffset;
@property float instanceGreenOffset;
@property float instanceBlueOffset;
@property float instanceAlphaOffset;

@end

*/

@end
