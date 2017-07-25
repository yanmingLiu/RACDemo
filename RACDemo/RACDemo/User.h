//
//  User.h
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReactiveObjC.h"

@interface User : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *pwdStr;

@property (nonatomic, assign) NSInteger pwd;

- (RACSignal *)loadData;

+ (User *)userWithDic:(NSDictionary *)dic;

@end
