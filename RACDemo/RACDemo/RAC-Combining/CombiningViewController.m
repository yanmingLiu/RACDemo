//
//  CombiningViewController.m
//  RACDemo
//
//  Created by lym on 2018/2/28.
//


#import "CombiningViewController.h"
#import "ReactiveObjC.h"

@interface CombiningViewController ()

@end

// http://blog.csdn.net/Mazy_ma/article/details/77151425
@implementation CombiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"多个请求顺序执行";

    [self listRequest];
}


// MARK: - 实例：多个请求顺序执行
- (void)listRequest {
    
    RACSignal *s0 = [self isRequest];
    
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送A的数据");
        BOOL isSuccess = YES;
        if (isSuccess) {
            [subscriber sendNext:@"AAAAAA"];
            [subscriber sendCompleted];
        }else {
            [subscriber sendError:[NSError errorWithDomain:@"erro" code:504 userInfo:@{@"key" : @"1请求失败"}]];
        }
        return nil;
    }];
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送B的数据");
        [subscriber sendNext:@"BBBB"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    [[[s0 filter:^BOOL(id  _Nullable value) {
        return [value boolValue];
    }] flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [s1 then:^RACSignal * _Nonnull{
            return s2;
        }];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"成功:%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"%@",error.description);
    }] ;
    
}

- (RACSignal *)isRequest {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"先调用这");
        [subscriber sendNext:@(YES)];
        [subscriber sendCompleted];
        return nil;
    }];
}










@end
