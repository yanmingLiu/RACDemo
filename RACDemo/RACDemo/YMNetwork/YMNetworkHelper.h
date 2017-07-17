//
//  YMNetworkHelper.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetwork.h"
#import "YMInterfacedConst.h"

@interface YMNetworkHelper : NSObject

/// 获取关键字
+ (NSURLSessionTask *)getKeywordsSuccess:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure;



@end
