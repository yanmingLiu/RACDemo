//
//  YMNetworkHelper.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetworkHelper.h"

@implementation YMNetworkHelper

#pragma mark - 请求的公共方法

+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method  URL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(YMHttpRequestCache)cache success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure
{
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    // 设置请求头
    [YMNetwork setValue:@"510100" forHTTPHeaderField:@"X-ADCODE"];
    [YMNetwork setValue:@"30.644104" forHTTPHeaderField:@"X-LAT"];
    [YMNetwork setValue:@"104.044449" forHTTPHeaderField:@"X-LNG"];
    // 发起请求
    return [YMNetwork requestWithMethod:method URL:URL parameters:parameter responseCache:^(id   responseCache) {
        cache(responseCache);
    } success:^(id   responseObject) {
        success(responseObject);
    } failure:^(NSError *  error) {
        failure(error);
    }];
}

/// 获取关键字
+ (NSURLSessionTask *)getKeywordsResponseCache:(YMHttpRequestCache)responseCache Success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure {
    
    NSString *url = [kApiPrefix stringByAppendingString:url_home_keywords];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:@{} responseCache:responseCache success:success failure:failure];
}




@end
