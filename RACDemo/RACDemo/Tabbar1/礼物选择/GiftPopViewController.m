//
//  GiftPopViewController.m
//  RACDemo
//
//  Created by lym on 2020/12/4.
//

#import "GiftPopViewController.h"
#import "GiftViewController.h"

@interface GiftPopViewController ()

@end

@implementation GiftPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeContactAdd)];
    [self.view addSubview:btn];
    btn.center = self.view.center;
    
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
    GiftViewController *vc = [[GiftViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
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
