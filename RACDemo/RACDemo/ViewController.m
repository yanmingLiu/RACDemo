//
//  ViewController.m
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "ViewController.h"
#import "ReactiveObjC.h"
#import "User.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) User *user;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self subscribeNext];
//    [self combineLatest];
    [self reduce];
    
//    self.user = [[User alloc] init];
//    [self MVVM_UI_model];
    
//    [self controlEvents];
}

#pragma mark - 单独信号
/**
 // 1.单独信号
 */
- (void)subscribeNext {
    [self.nameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - RACTuple 组合信号
/**
 // 2.组合信号
 */
- (void)combineLatest {
    
    // RACTuple : 元祖，通过1，2，3，4，5取值
    [[RACSignal combineLatest:@[self.nameTF.rac_textSignal, self.pwdTF.rac_textSignal]] subscribeNext:^(RACTuple *x) {
        NSString *name = x.first;
        NSString *pwd = x.second;
        NSLog(@"name=%@   pwd=%@", name, pwd);
    }];
}

#pragma mark - reduce : 合并多个信号的数据，进行汇总计算
/**
 // 3.组合信号 
    reduce：合并多个信号的数据，进行汇总计算，并返回需要的值
    subscribeNext ： 订阅这个返回值
 */
- (void)reduce {
    @weakify(self);
    [[RACSignal combineLatest:@[self.nameTF.rac_textSignal, self.pwdTF.rac_textSignal] reduce:^id(NSString *name, NSString *password) {
        // 需要转换成 NSNumber：@(), 才能当做id 传递。
        return @(name.length > 0 && password.length >= 6);
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        BOOL isShow = [x boolValue];
        if (isShow) {
            self.button.backgroundColor = [UIColor redColor];
        } else {
            self.button.backgroundColor = [UIColor whiteColor];
        }
    }];
}

#pragma mark - KVO
- (void)kvo {
    //代替KVO
//    [RACObserve(scrollView, contentOffset) subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//        
//    }];
}

#pragma mark - MVVM
/**
 // 1.模型 (KVO 数据) ->  UI （控件  text属性）
 */
- (void)MVVM_model_UI {
    
    // a) name (NSString) -> text (NSString)
    RAC(self.nameTF, text) = RACObserve(self.user, name);
    
    // b) 纯数字的密码 pwd (NSNumber) -> text (NSSting)
    /*
    注意： 如果使用基本数据类型绑定UI，需要使用map函数，通过block对value的值转换之后才能绑定
     */
    RAC(self.pwdTF, text) = [RACObserve(self.user, pwd) map:^id (id  value) {
        return [value description];
    }];
}


// 2.UI （控件  text属性）-> 模型 (KVO 数据)
// 在RAC中出现 self _ 百分百循环引用
// 解决办法使用 外部： @weakify(self); 内部： @strongify(self);

- (void)MVVM_UI_model {
    @weakify(self)
    [[RACSignal combineLatest:@[self.nameTF.rac_textSignal, self.pwdTF.rac_textSignal]] subscribeNext:^(RACTuple *x) {
        @strongify(self)
        self.user.name = x.first;
        self.user.pwd = [x.second integerValue];
        
        NSLog(@"%@---%zd",self.user.name, self.user.pwd);
    }];
}


# pragma mark - 事件监听、通知监听
- (void)controlEvents {
    
    // 事件监听
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮点击了");
        
    }];
}

- (void)ObserverNoti {
    
    // 通知监听
    // aplle
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerNoti_Apple) name:@"tongzhi" object:nil];
    
    // RAC
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"tongzhi" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"按钮点击了发出了通知");
    }];
}

- (void)observerNoti_Apple {
    
}

@end
