//
//  ScrollTextViewController.m
//  RACDemo
//
//  Created by lym on 2020/10/20.
//

#import "ScrollTextViewController.h"
#import "ScrollTextView.h"

@interface ScrollTextViewController ()

@end

@implementation ScrollTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ScrollTextView *textView = [[ScrollTextView alloc] initWithFrame:CGRectZero text:@"缓缓飘落的枫叶像思念" tont:[UIFont boldSystemFontOfSize:24] color:[UIColor orangeColor]];
    textView.cornerRadius = 6;
    textView.backgroundColor = [UIColor lightGrayColor];
    textView.borderWidth  = 1;
    textView.borderColor = [UIColor blueColor];
    [self.view addSubview:textView];
    
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [[textView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:80] setActive:YES];
    [[textView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-80] setActive:YES];
    [[textView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:140] setActive:YES];
    [[textView.heightAnchor constraintEqualToConstant:30] setActive:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(13 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView updateText:@"木造的甲板一整遍是那金黄" font:[UIFont boldSystemFontOfSize:24] color:[UIColor redColor]];
    });
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
