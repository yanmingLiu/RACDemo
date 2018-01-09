//
//  LoginViewModel.m
//  RACDemo
//
//  Created by lym on 2018/1/8.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        RACSignal *userNameLengthSig = [RACObserve(self, userName)
                                        map:^id(NSString *value) {
                                            if (value.length >= 3) return @(YES);
                                            return @(NO);
                                        }];
        
        RACSignal *passwordLengthSig = [RACObserve(self, password)
                                        map:^id(NSString *value) {
                                            if (value.length > 6) return @(YES);
                                            return @(NO);
                                        }];
        
        RACSignal *loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSig, passwordLengthSig] reduce:^id(NSNumber *userName, NSNumber *password){
            
            return @([userName boolValue] && [password boolValue]);
        }];
        
        _loginCommand = [[RACCommand alloc]initWithEnabled:loginBtnEnable signalBlock:^RACSignal *(id input) {
            return [self loginWithUserName:self.userName password:self.password];
        }];
    }
    return self;
}

- (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:[NSString stringWithFormat:@"User %@, password %@, login!",name, password]];
            [subscriber sendCompleted];
        });
        return nil;
    }];
}


@end
