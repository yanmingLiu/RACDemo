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

    
    [self baseRac];
    
//    [self subscribeNext];
//    [self combineLatest];
    [self reduce];
//
//    self.user = [[User alloc] init];
//    [self MVVM_UI_model];
    
//    [self controlEvents];
    
    [self dicTomodel];
}

#pragma mark - 单独信号

- (void)subscribeNext {
    [self.nameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - RACTuple 组合信号

// RACTuple : 元祖，通过1，2，3，4，5取值
- (void)combineLatest {
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
        
        NSLog(@"%@ -- %@", name, password);
        // 需要转换成 NSNumber：@(), 才能当做id 传递。
        return @(name.length > 0 && password.length >= 6);
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        BOOL isShow = [x boolValue];
        if (isShow) {
            self.button.backgroundColor = [UIColor redColor];
        } else {
            self.button.backgroundColor = [UIColor blueColor];
        }
    }];
}

#pragma mark - KVO
- (void)kvo {
    //代替KVO
    [RACObserve(self.nameTF, text) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
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


# pragma mark - 事件监听、
- (void)controlEvents {
    // 事件监听
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮点击了");
    }];
}

#pragma mark - 通知监听
- (void)ObserverNoti {
    // aplle
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observerNoti_Apple) name:@"tongzhi" object:nil];
    
    // RAC
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"tongzhi" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"按钮点击了发出了通知");
    }];
}

- (void)observerNoti_Apple {
    
}


#pragma mark - RACSequence和RACTuple简单使用

// 1.遍历数组
- (void)enumArr {
    NSArray *numbers = @[@1,@2,@3,@4];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}


// 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
- (void)enumDic {
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
}
// 3.字典转模型
- (void)dicTomodel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        NSLog(@"%@", value);
        return [User userWithDic:value];
        
    }] array];
    
    NSLog(@"%@", flags);
}


#pragma mark - // 6.处理多个请求，都返回结果的时候，统一做处理.
- (void)moreRequest {
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];

}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - 基本信号监听

- (void)baseRac {
    User *user = [[User alloc] init];
    // 订阅信号
    [[user loadData] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@", error);
    } completed:^{
        NSLog(@"完成");
    }];
}

@end
