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
    
    ASGradientLabel *label = [[ASGradientLabel alloc] initWithFrame:CGRectMake(20, 120, 0, 0)];
    label.text = @"从上到下的渐变文字";
    label.font = [UIFont boldSystemFontOfSize:24];
    label.colors = @[(__bridge id)[UIColor redColor].CGColor,
                     (__bridge id)[UIColor orangeColor].CGColor];
    label.locations = @[@0 ,@1];
    label.startPoint = CGPointMake(0.5, 0);
    label.endPoint = CGPointMake(0.5, 1);

    [self.view addSubview:label];
    [label sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
