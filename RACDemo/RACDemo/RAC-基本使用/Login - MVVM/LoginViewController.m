//
//  LoginViewController.m
//  RACDemo
//
//  Created by lym on 2018/1/8.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "NSString+YMAdd.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

/** viewModel */
@property (nonatomic, strong) LoginViewModel * viewModel; 


@end

@implementation LoginViewController


- (instancetype)init
{
    return ViewControllerFromSB(@"Main", @"LoginViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView.hidden = YES;
    self.viewModel = [[LoginViewModel alloc]init];
    
    if (@"1".length == 0) {
        NSLog(@"空");
    }else {
        NSLog(@"不空");
    }
    
   
    [self bindViewModel];
}

- (void)bindViewModel {
    @weakify(self)
    
    RAC(self.viewModel, userName) = self.nameTextField.rac_textSignal;
    
    RAC(self.viewModel, password) = self.pwdTextField.rac_textSignal;
    
    self.loginBtn.rac_command = self.viewModel.loginCommand;
    
    [[self.viewModel.loginCommand executionSignals]
     subscribeNext:^(RACSignal *x) {
         @strongify(self)
         self.loadingView.hidden = NO;
         [self.loadingView startAnimating];
         [x subscribeNext:^(NSString *x) {
             self.loadingView.hidden = YES;
             [self.loadingView stopAnimating];
             NSLog(@"%@",x);
         }];
     }];

    
}

@end
