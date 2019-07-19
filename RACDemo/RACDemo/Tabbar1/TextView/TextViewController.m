//
//  TextViewController.m
//  RACDemo
//
//  Created by lym on 2018/6/21.
//

#import "TextViewController.h"
#import "YMTextView.h"

@interface TextViewController ()
@property (weak, nonatomic) IBOutlet YMTextView *tv;

@end

@implementation TextViewController

- (instancetype)init {
    return ViewControllerFromSB(@"Main", @"TextViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    _tv.textAlignment = NSTextAlignmentRight;
    _tv.text = nil;
    _tv.placeholder = @"请输入";
    _tv.placeholderTextColor = [UIColor lightGrayColor];
    _tv.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
