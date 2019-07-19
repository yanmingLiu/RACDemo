//
//  CViewModel.m
//  RACDemo
//
//  Created by lym on 2018/1/30.
//

#import "CViewModel.h"

@implementation CViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self iniViewModel];
    }
    return self;
}

- (void)iniViewModel {
    _executeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"_execute---%@", input]];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    self.executingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[NSString stringWithFormat:@"_executing"]];
                [subscriber sendCompleted];
            });
            
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    _switchToLatestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:[NSString stringWithFormat:@"_switchToLatest---%@", input]];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                
            }];
        }];
    }];
    
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendError:[NSError errorWithDomain:@"sss" code:1003 userInfo:@{@"key" : @"失败"}]];
        });
        return nil;
    }];
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:[NSString stringWithFormat:@"请求s2"]];
            [subscriber sendCompleted];
        });
        return nil;
    }];
    
    
    _concatCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [s1 concat:s2];
    }];
}

- (RACSignal *)s1 {
    
    if (1) {
        
        return [RACSignal return:@(YES)];  
    }
    
    return [RACSignal return:@(NO)];
}

- (RACSignal *)verify {
    
    if (1) {
      
       return [RACSignal return:@(YES)];  
    }
    
    return [RACSignal return:@(NO)];
}

@end
