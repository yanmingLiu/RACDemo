//
//  LoginViewModel.h
//  RACDemo
//
//  Created by lym on 2018/1/8.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong, readonly) RACCommand *loginCommand;


@end
