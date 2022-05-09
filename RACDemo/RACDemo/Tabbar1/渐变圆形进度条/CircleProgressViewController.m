//
//  CircleProgressViewController.m
//  RACDemo
//
//  Created by lym on 2021/5/18.
//

#import "CircleProgressViewController.h"
#import "CircleProgressView.h"

@interface CircleProgressViewController ()

@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) CircleProgressView *progressView;


@end

@implementation CircleProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    countView.backgroundColor = [UIColor lightGrayColor];
//    countView.cornerRadius = 100;
//    [self.view addSubview:countView];
//    countView.center = self.view.center;
//
    CircleProgressView *v = [[CircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:v];
    v.center = self.view.center;
    // 7041E6  DB42E6
    v.colors = @[[UIColor colorWithHexString:@"#DB42E6"], [UIColor colorWithHexString:@"#7041E6"]];
    _progressView = v;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _progressView.progress = 1;
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
