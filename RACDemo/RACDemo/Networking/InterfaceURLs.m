//
//  InterfaceURLs.m
//  Tailorx
//
//  Created by   徐安超 on 16/7/13.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "InterfaceURLs.h"

@implementation InterfaceURLs

#pragma mark ------服务器地址(单一数据）------ 开发
#if 0

NSString * const youkexueAPI = @"https://api.develop.ykx100.com/";

// 推送
//NSString * const pushKey = @"23470642";
//NSString * const pushSecret = @"4476cd7e2d57f6c239c3c1909fc02754";
#endif

#pragma mark ------服务器地址(单一数据）--- 测试
#if 1

NSString * const youkexueAPI = @"https://api.develop.ykx100.com/";

// 推送
//NSString * const pushKey = @"23449668";
//NSString * const pushSecret = @"a02b87f826d58e12f4e657ed9d2cc69a";
#endif

#pragma mark ===  生产
#if 0
NSString * const youkexueAPI = @"https://api.develop.ykx100.com/";

// 推送 AppStore
//NSString * const pushKey = @"23470615";
//NSString * const pushSecret = @"4a546fda0cfbc51e88c02bde42df4239";

#endif


//*************************************************

//修改密码-获取验证码
NSString * const changePwdCode = @"v1/agency/code";




@end
