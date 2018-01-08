//
//  LoginViewController.m
//  RACDemo
//
//  Created by lym on 2018/1/8.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;

/** viewModel */
@property (nonatomic, strong) LoginViewModel * viewModel; 


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView.hidden = YES;
    self.viewModel = [[LoginViewModel alloc]init];
    
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
         [x subscribeNext:^(NSString *x) {
             self.loadingView.hidden = YES;
             NSLog(@"%@",x);
         }];
     }];
}

@end
