//
//  YMNetworkingTool.m
//  demo
//
//  Created by 刘彦铭 on 2015/5/16.
//  Copyright © 2015年 YouKeXue. All rights reserved.
//

#import "YMNetworkingTool.h"

#define CODE @"code"

@implementation YMNetworkingTool

singleton_implementation(YMNetworkingTool)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        self.manager.requestSerializer.HTTPShouldHandleCookies = YES;
        self.manager.requestSerializer.timeoutInterval = 15;
        [self.manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [self.manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"text/plain",nil];
    }
    return self;
}

#pragma makr - 开始监听网络连接

- (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                self.networkError = NO;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                self.networkError = YES;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                self.networkError = NO;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                self.networkError = NO;
                break;
        }
    }];
    [mgr startMonitoring];
}

- (void)requestWithType:(NetworkRequestType)type URL:(NSString *)urlStr header:(NSDictionary *)headDic parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    if (!type) {
        return;
    }
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> headParameters : %@\n", self.manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\n--------------------->>> bodyParameters : %@\n", params);
    
    NSMutableString *body = [[NSMutableString alloc]init];
    for(NSString *key in [params allKeys]){
        NSString *value= [params objectForKey:key];
        [body appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    
    NSLog(@"\n\n\n[-------headDic------]:%@-%@\n\n\n",urlStr,headDic);
    if(params!=nil && [params count]>0){
        NSLog(@"\n\n\n[-------Send------]:%@?%@\n\n\n",urlStr,body);
    }else{
        NSLog(@"\n\n\n[-------Send------]:%@\n\n\n",urlStr);
    }
    
    __weak typeof(self) weakself = self;
    if (type == NetworkRequestType_GET) {
        [weakself.manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"返回的数据内容%@",responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    else if (type == NetworkRequestType_POST) {
        [weakself.manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}

- (void)uploadingWithURL:(NSString *)urlStr header:(NSDictionary *)headDic parameters:(NSDictionary *)params pictureKey:(NSString *)pictureKey files:(NSArray *)imageArray success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    if (!urlStr || urlStr.length == 0) {
        return;
    }
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    for (NSString *key in [headDic allKeys]) {
        NSString *value = [headDic objectForKey:key];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    
    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> headParameters : %@\n", self.manager.requestSerializer.HTTPRequestHeaders);
    NSLog(@"\n--------------------->>> bodyParameters : %@\n", params);
    
    NSMutableString *body = [[NSMutableString alloc]init];
    for(NSString *key in [params allKeys]){
        NSString *value= [params objectForKey:key];
        [body appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    
    __weak typeof(self) weakself = self;
    [weakself.manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageArray != nil && imageArray.count > 0) {
            for (int i = 0 ; i < imageArray.count; i++) {
                NSData *imageData = imageArray[i];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                [formData appendPartWithFileData:imageData name:pictureKey fileName:fileName mimeType:@"image/jpeg"];
            }
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回的数据内容%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
