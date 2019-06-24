//
//  User.m
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "User.h"

@implementation User

- (RACSignal *)loadData {
    // 1.创建一个信号
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        BOOL isErro = YES;
        
        if (isErro) {
            [subscriber sendError:[NSError errorWithDomain:@"错误" code:404 userInfo:@{@"msg" : @"发送了错误信息"}]];
        }else {
            [subscriber sendNext:@"发送成功的信号"];
        }
        [subscriber sendCompleted];
        
        return nil;
    }];
    

}


+ (User *)userWithDic:(NSDictionary *)dic {
    User *u = [[User alloc] init];
    u.name = [dic objectForKey:@"name"];
    u.pwdStr = [dic objectForKey:@"pwdStr"];
    
    return u;
}

@end
