//
//  KeyboardViewController.m
//  RACDemo
//
//  Created by lym on 2020/11/25.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", NSStringFromCGRect(self.view.bounds));
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    NSLog(@"注意viewDidLoad可能无法获取self.navigationController.navigationBar bar : %@", NSStringFromCGRect(bar.frame));

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"请输入...";
    [self.view addSubview:textField];
    self.textField = textField;
    
    
    // uikit
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    // RAC
//    [self addNoticeForKeyboard];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    NSLog(@"viewDidLayoutSubviews bar : %@", NSStringFromCGRect(bar.frame));

    CGFloat y = self.view.bounds.size.height - 40 - kNavigationH - kTabBarMargin;
    self.textField.frame = CGRectMake(20, y, self.view.bounds.size.width - 40,40);
}

- (void)willShowNotification:(NSNotification *)notice {
    NSDictionary *userInfo = [notice userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardBeginFrame;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    CGFloat offsetHeight = self.view.height - keyboardEndFrame.origin.y - kTabBarMargin;
    offsetHeight = offsetHeight > 0 ? offsetHeight : 0;
    
    NSLog(@"willShowNotification : %f\n, keyboardBeginFrame = %@\n,keyboardEndFrame = %@", offsetHeight,NSStringFromCGRect(keyboardBeginFrame),NSStringFromCGRect(keyboardEndFrame));
    
    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
        self.textField.y = self.view.height - 40 - kTabBarMargin;
        [self.view layoutIfNeeded];
    }];
}

- (void)willHideNotification:(NSNotification *)notice {
    NSDictionary *userInfo = [notice userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    CGFloat y = self.view.bounds.size.height - 40 - kNavigationH - kTabBarMargin;
    NSLog(@"willShowNotification : %f", y);

    [UIView animateWithDuration:animationDuration animations:^{
        [UIView setAnimationCurve:animationCurve];
        self.textField.y = y;
        [self.view layoutIfNeeded];
    }];
}



#pragma mark - RAC 写法

- (void)addNoticeForKeyboard {
    //监听弹出键盘
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable noti) {
        @strongify(self);

        NSDictionary *userInfo = [noti userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardBeginFrame;
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBeginFrame];
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

        CGFloat offsetHeight = self.view.height - keyboardEndFrame.origin.y - kTabBarMargin;
        offsetHeight = offsetHeight > 0 ? offsetHeight : 0;
        
        NSLog(@"willShowNotification : %f\n, keyboardBeginFrame = %@\n,keyboardEndFrame = %@", offsetHeight,NSStringFromCGRect(keyboardBeginFrame),NSStringFromCGRect(keyboardEndFrame));
        
        [UIView animateWithDuration:animationDuration animations:^{
            [UIView setAnimationCurve:animationCurve];
            self.textField.y = self.view.height - 40 - kTabBarMargin;
            [self.view layoutIfNeeded];
        }];

    }];

    //可以监听收回键盘
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil] subscribeNext:^(NSNotification * _Nullable noti) {
        @strongify(self);

        NSDictionary *userInfo = [noti userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        CGFloat y = self.view.bounds.size.height - 40 - kNavigationH - kTabBarMargin;
        NSLog(@"willShowNotification : %f", y);

        [UIView animateWithDuration:animationDuration animations:^{
            [UIView setAnimationCurve:animationCurve];
            self.textField.y = y;
            [self.view layoutIfNeeded];
        }];

    }];
}

@end

