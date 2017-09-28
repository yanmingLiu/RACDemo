//
//  YMCacheHelper.h
//  ykxB
//
//  Created by lym on 2017/8/4.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMLoginModel.h"
#import "YMAgencyModel.h"
#import "YMPowerModel.h"


@interface YMCacheHelper : NSObject

+ (instancetype)sharedCacheHelper;

@property (nonatomic, copy) YMLoginModel *loginModel;

// 当前选中品牌
@property (nonatomic, strong) YMAgencyModel *selectedAgencyModel;

// 权限
@property (nonatomic, strong) YMPowerModel *cachePowerModel;


@end

