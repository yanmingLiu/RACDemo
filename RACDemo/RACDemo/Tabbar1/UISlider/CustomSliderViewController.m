//
//  CustomSliderViewController.m
//  RACDemo
//
//  Created by lym on 2020/10/14.
//

#import "CustomSliderViewController.h"
#import "CustomSlider.h"

@interface CustomSliderViewController ()

@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation CustomSliderViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:47/255.0 green:46/255.0 blue:73/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:valueLabel];
    self.valueLabel = valueLabel;

    [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(40);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];

    
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:CGRectMake(40, 120, self.view.bounds.size.width-80, 30)];
    [slider setThumbImage:[UIImage imageNamed:@"cr_slider_thumb"] forState:UIControlStateNormal];
    slider.minimumValue = 0;
    slider.maximumValue = 100;
    slider.minimumTrackTintColor = [UIColor orangeColor];
    slider.maximumTrackTintColor = [UIColor lightGrayColor];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(sliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:slider];
}


- (void)sliderValueChanged:(UISlider *)slider {
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
}

- (void)sliderTouchUpInside:(UISlider *)slider {
    NSLog(@"sliderTouchUpInside");
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
