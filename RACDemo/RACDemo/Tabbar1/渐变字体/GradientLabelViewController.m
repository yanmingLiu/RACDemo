//
//  GradientLabelViewController.m
//  RACDemo
//
//  Created by lym on 2020/10/20.
//

#import "GradientLabelViewController.h"
#import "ASGradientLabel.h"

@interface GradientLabelViewController ()

@end

@implementation GradientLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *colors = @[(__bridge id)[UIColor redColor].CGColor,
                        (__bridge id)[UIColor greenColor].CGColor];
    
    [self addOneLineGradientLayerWithColors:colors];
    
    [self addGradientLayerWithColors:colors];
}


- (void)addOneLineGradientLayerWithColors:(NSArray *)colors {
    ASGradientLabel *label = [[ASGradientLabel alloc] initWithFrame:CGRectMake(20, 90, 0, 0)];
    label.text = @"从上到下的渐变文字从渐变文字";
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:24];
    label.colors = colors;
    label.locations = @[@0 ,@1];
    label.startPoint = CGPointMake(0.5, 0);
    label.endPoint = CGPointMake(0.5, 1);

    [self.view addSubview:label];
    [label sizeToFit];

}

- (void)addGradientLayerWithColors:(NSArray *)colors
{
    UILabel* testLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 180, self.view.bounds.size.width-40, 0)];
    testLabel.text = @"我是渐变色的呀呀是渐变渐变色的呀呀是渐变色的是渐变色渐变色的呀呀是渐变色的是渐变色色的是渐变色的是渐变色的是渐变是渐变色的是渐变色的是渐变色的是渐变呀呀--layer";
    testLabel.numberOfLines = 0;
    testLabel.font = [UIFont systemFontOfSize:23];
    [testLabel sizeToFit];
    
    [self.view addSubview:testLabel];
//    testLabel.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.7);
    
    // 创建渐变层
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = testLabel.frame;
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = testLabel.layer;
    testLabel.frame = gradientLayer.bounds;
}


@end
