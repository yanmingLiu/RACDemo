//
//  CustomSliderViewController.m
//  RACDemo
//
//  Created by lym on 2020/10/14.
//

#import "CustomSliderViewController.h"
#import "CustomSlider.h"

@interface CustomSliderViewController ()

@end

@implementation CustomSliderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:CGRectMake(40, 120, self.view.bounds.size.width-80, 10)];
    
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    
    [self.view addSubview:slider];
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
