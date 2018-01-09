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

/** command */
@property (nonatomic, strong) RACCommand * command; 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self Command];
    
}


#pragma mark - RACSignal RACSubject

/// RACSignal
- (void)signal {
    
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@1];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
        }];
    }];
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
}

/// RACSubject RACReplaySubject
- (void)subject {
    // RACSubject使用步骤 
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"1"];
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    
}

///RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。
- (void)Command {
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    // 3.订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    // 5.执行命令
    [self.command execute:@1];
}

#pragma mark - RACTuple RACSequence RACTuplePack RACTupleUnpack

/// sequence
- (void)sequence {
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
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

#pragma mark -  map flattenMap filter
/*
 #pragma flattenMap 方法通过调用block（value）来创建一个新的方法，它可以灵活的定义新创建的信号。
 #pragma map方法， 将会创建一个和原来一模一样的信号，只不过新的信号传递的值变为了block（value）。

 FlatternMap和Map的区别：
 1.FlatternMap中的Block返回信号
 2.Map中的Block返回对象
 3.开发中，如果信号发出的值不是信号，映射一般使用Map
 4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap
 */
/// map 把原始值value映射成一个新值
- (void)map {
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


#pragma mark - concat reduce combineLatest


/// rac_liftSelector:withSignalsFromArray:
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

 
/// concat_then_combineLatest
- (void)concat_then_combineLatest {
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
    /// concat：按一定顺序拼接信号，当多个信号发出的时候有顺序的接受信号。 
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

/// then:用于连接两个信号，当第一个信号完成才会连接then返回的信号,使用then之前的信号会被忽略掉
- (void)then {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signalA发送完信号"];
        //发送完毕
        [subscriber sendCompleted];
        return  nil;
        
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signalB发送完信号"];
        
        return nil;
    }];
    
    RACSignal *thensignal = [signalA then:^RACSignal *{
        return signalB;
    }];
    
    [thensignal subscribeNext:^(id x) {
        NSLog(@"%@",x); // signalB发送完信号
    }];
}

/// merge：把多个信号合并为一个信号，任何一个信号有新值时就会调用
- (void)merge {
    /*
     底层实现：1.合并信号被订阅的时候就会遍历所有信号，并且发出这些信号
     2.每发出一个信号，这个信号就会被订阅
     3.也就是合并信号一被订阅，就会订阅里面所有的信号
     4.只要有一个信号发出就会被监听
     */
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signalA发送完信号"];
        return  nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"signalB发送完信号"];
        return nil;
    }];
    
    // 合并信号，任何一个信号发送数据都能在订阅中监听到
    RACSignal *mergesignal = [signalA merge:signalB];
    
    [mergesignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

/// zipWith：把两个信号压缩成一个信号，只有当两个信号同时发出信号内容的时候，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件
- (void)zipWith {
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        //发送完毕
        //        [subscriber sendCompleted];
        return  nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"2"];
        return nil;
    }];
    //订阅中的数据和zip的顺序相关。
    RACSignal *zipWithsignal = [signalA zipWith:signalB];
    [zipWithsignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// combineLatest 将多个信号合并起来，并且拿到各个信号的最新值，必须每个信号至少都发出过内容, 才会触发合并的信号
- (void)combineLatest {
    [[RACSignal combineLatest:@[self.nameTF.rac_textSignal, self.pwdTF.rac_textSignal]] subscribeNext:^(RACTuple *x) {
        NSString *name = x.first;
        NSString *pwd = x.second;
        NSLog(@"name=%@   pwd=%@", name, pwd);
    }];
}


/**
 reduce：合并多个信号的数据，进行汇总计算，并返回需要的值
 subscribeNext ： 订阅这个返回值
 */
///reduce聚合：用于信号发出的内容是元组，把信号发出元组的值聚合成一个值。
- (void)reduce {
    @weakify(self);
    // 有多少信号组合reduceblcok中就有多少参数，每个参数就是之前信号发出的内容,参数顺序和数组中的 参数一一对应
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


#pragma mark - KVO\事件监听\通知监听
- (void)replaceFunc {
    //代替KVO
    [RACObserve(self.nameTF, text) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    // 事件监听
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮点击了");
    }];
    // RAC
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"tongzhi" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"按钮点击了发出了通知");
    }];
    // cocoa
    [self.nameTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [self.pwdTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 时间
    [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
    }];
}


#pragma mark - RAC宏
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

@end
