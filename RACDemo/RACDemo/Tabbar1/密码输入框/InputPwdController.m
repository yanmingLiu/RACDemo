//
//  InputPwdController.m
//  RACDemo
//
//  Created by lym on 2020/9/12.
//

#import "InputPwdController.h"

@interface InputPwdController ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) InputBoxView *inputView;
@property (nonatomic, strong) UILabel *erroLabel;

@property (nonatomic, strong) NSString *password;

@end

@implementation InputPwdController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    __weak __typeof(&*self) weakSelf = self;

    self.inputView.textDidChangeblock = ^(NSString *_Nullable text, BOOL isFinished) {
        weakSelf.erroLabel.hidden = YES;
        if (isFinished) {
            weakSelf.password = text;
        }
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.inputView closeKeyborad];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor blackColor];
    container.cornerRadius = 8;
    container.alpha = 0;
    [self.view addSubview:container];
    self.container = container;

    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Room is encrypted";
    label.font = [UIFont systemFontOfSize:18 weight:(UIFontWeightBold)];
    [container addSubview:label];
    [label sizeToFit];

    InputBoxView *inputView = [[InputBoxView alloc] initWithCodeLength:6];
    inputView.boxFont = [UIFont boldSystemFontOfSize:24];
    inputView.boxTextColor = [UIColor whiteColor];
    inputView.boxBgColor = [UIColor systemTealColor];
    inputView.backgroundColor = [UIColor clearColor];
    [container addSubview:inputView];
    self.inputView = inputView;

    UIButton *closeBtn = [[UIButton alloc] init];
//    [closeBtn setImage:[UIImage imageNamed:@"im_noconnect_close"] forState:UIControlStateNormal];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:closeBtn];
    [closeBtn sizeToFit];

    UILabel *erroLabel = [[UILabel alloc] init];
    erroLabel.textColor = [UIColor redColor];
    erroLabel.text = @"Password is incorrect, please try again";
    erroLabel.font = [UIFont systemFontOfSize:12];
    erroLabel.numberOfLines = 2;
    erroLabel.hidden = YES;
    [container addSubview:erroLabel];
    self.erroLabel = erroLabel;

    CGFloat pageMargin = 16;

    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(40);
        make.right.equalTo(self.view).mas_offset(-40);
        make.height.mas_equalTo(container.mas_width).multipliedBy(0.6);
        make.centerY.equalTo(self.view).mas_offset(-50);
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(32);
        make.centerX.equalTo(container);
        make.height.mas_equalTo(22);
    }];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(8);
        make.right.mas_offset(-8);
    }];

    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).mas_offset(40);
        make.left.mas_offset(pageMargin);
        make.right.mas_offset(-pageMargin);
        make.height.mas_equalTo(40);
    }];

    [erroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputView);
        make.top.equalTo(inputView.mas_bottom).mas_offset(8);
    }];
}

- (void)popAnimationWithView:(UIView *)view {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.5;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

- (void)show {
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[UIWindow ym_currentViewController
     ] presentViewController:self animated:NO completion:^{
         [self popAnimationWithView:self.container];
         self.container.alpha = 1;
         [UIView animateWithDuration:0.25 animations:^{
             [self.inputView showKeyborad];
         }];
     }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.completion) {
            self.completion(false);
        }
    }];
}

@end
