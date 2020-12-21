//
//  AvatarsViewController.m
//  RACDemo
//
//  Created by lym on 2020/12/21.
//

#import "AvatarsViewController.h"
#import "AvatarsOverlapView.h"

@interface AvatarsViewController ()

@end

@implementation AvatarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AvatarsOverlapView *v = [[AvatarsOverlapView alloc] initWithAvatarSize:CGSizeMake(40, 40)];
    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:v];
    
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(20);
        make.right.equalTo(self.view).mas_offset(-20);
    }];
    
    [v fillDatas:@[@"1",@"2",@"3",@"1",@"2",@"3"]];
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
