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
//    [self reduce];
//
//    self.user = [[User alloc] init];
//    [self MVVM_UI_model];
    
//    [self controlEvents];
    
//    [self dicTomodel];
    
//    [self filter];
    
    [self flattenMap];
    
//    [self enumArr];
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
/*
#pragma flattenMap 方法通过调用block（value）来创建一个新的方法，它可以灵活的定义新创建的信号。
#pragma map方法， 将会创建一个和原来一模一样的信号，只不过新的信号传递的值变为了block（value）。
#pragma map创建一个新的信号，信号的value是block(value)，也就是说，如果block(value)是一个信号，那么就是信号的value仍然是信号。如果是flattenMap则会继续调用这个信号的value，作为新的信号的value。
*/
/// map 把原始值value映射成一个新值
- (void)dicTomodel {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
        
        NSLog(@"%@", value);
        return [User userWithDic:value];
        
    }] array];
    NSLog(@"%@", flags);
    
    /****************例子*****************************/
    
    NSArray *arr = @[@1,@2,@3,@4,@5];
    RACSequence *seq = [arr rac_sequence];
    NSArray *resultArr = [[seq map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] + 1);
    }] array];
    NSLog(@"%@", resultArr);
}
/// flattenMap
- (void)flattenMap {
    /*
     [1,2]
     [3,4]
     
     = [1,2,3,4]
     */
    
    RACSequence *s1 = [@[@1,@2,@3] rac_sequence];
    RACSequence *s2 = [@[@4,@5,@6] rac_sequence];

    RACSequence *s3 = [[@[s1, s2] rac_sequence] flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
        return [value filter:^BOOL(id  _Nullable value) {
            return [value integerValue] % 2 == 0; 
        }];
    }];
    
    NSLog(@"%@", [s3 array]);
}

///filter:过滤- 控制事件流 
- (void)filter {
    NSArray *arr = @[@1,@2,@3,@4,@5];
    RACSequence *seq = [arr rac_sequence];
    
    NSArray *resultArr = [[seq filter:^BOOL(id  _Nullable value) {
        return [value integerValue] % 2 == 1;
    }] array];
    
    NSLog(@"%@", resultArr);
    
    
    NSArray *resultArr1 = [[[[arr rac_sequence] map:^id _Nullable(id  _Nullable value) {
        return @([value integerValue] - 1);
    }] filter:^BOOL(id  _Nullable value) {
        return @([value integerValue] > 3);
    }] array];
     NSLog(@"%@", resultArr1);
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
- (void)updateUIWithR1:(id)data r2:(id)data1 {
    NSLog(@"更新UI%@  %@",data,data1);
}

#pragma mark - network 顺序执行 同步执行 

- (void)network {
    RACSignal *s1 = [self session];
    RACSignal *s2 = [self session];
    RACSignal *s3 = [self session];
    
    /// 串行 - 顺序执行 then 只会返回s3的结果
    [[[s1 then:^RACSignal * _Nonnull{
        return s2;
    }] then:^RACSignal * _Nonnull{
        return s3;
    }] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    /// concat 订阅的话 s1,s2,s3的结果都会返回 
    [[[s1 concat:s2] concat:s3] subscribeNext:^(id  _Nullable x) {
        
    }];
    
    
    /// 同时执行，统一订阅
    [[RACSignal combineLatest:@[s1,s2,s3]] subscribeNext:^(RACTuple * _Nullable x) {
        
    }];
}

- (RACSignal *)session {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"请求错误");
                [subscriber sendError:error];
            }else {
                NSError *e;
                NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
                if (e) {
                    NSLog(@"解析失败");
                }else {
                    NSLog(@"%@", jsonDic);
                    [subscriber sendNext:jsonDic];
                    [subscriber sendCompleted];
                }
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
}

#pragma mark - KVO\事件监听\通知监听
- (void)kvo {
    //代替KVO
    [RACObserve(self.nameTF, text) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)controlEvents {
    // 事件监听
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮点击了");
    }];
}

- (void)ObserverNoti {
    // RAC
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"tongzhi" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"按钮点击了发出了通知");
    }];
}

#pragma mark - 基本信号监听

/// 基本监听
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
