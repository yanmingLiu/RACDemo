//
//  YMNetworkingTool.m
//  demo
//
//  Created by 刘彦铭 on 2015/5/16.
//  Copyright © 2015年 YouKeXue. All rights reserved.
//

#import "YMNetworkingTool.h"

NSString * const kLoading = @"正在加载...";
NSString * const kLoadError = @"加载失败";
NSString * const kNetError = @"网络连接失败!";
NSString * const kSuccessful = @"加载成功";
NSString * const kNoMoreData = @"没有更多数据了";

#define CODE @"code"

@implementation YMNetworkingTool

singleton_implementation(YMNetworkingTool)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];

        self.manager.requestSerializer.timeoutInterval = 10;
        [self.manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [self.manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml",@"text/plain",nil];
        
        // https证书问题
        self.manager.securityPolicy.allowInvalidCertificates = YES;
        self.manager.securityPolicy.validatesDomainName = NO;
        
        //self.manager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        [self startMonitoring];
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
                self.networkError = YES;
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
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showHUDAddedTo:window animated:YES];
    void(^noNetworkBlock)() = ^() {
        [MBProgressHUD hideAllHUDsForView:window animated:NO];
        [MBProgressHUD bwm_showTitle:kNetError toView:window hideAfter:HUDHideTime msgType:BWMMBProgressHUDMsgTypeError];
    };
    
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

    
    __weak typeof(self) weakself = self;
    
    if (type == NetworkRequestType_GET) {
        
        [weakself.manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",responseObject);
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                noNetworkBlock();
            }
        }];
    }
    else if (type == NetworkRequestType_POST) {
        [weakself.manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",jsonStr);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                noNetworkBlock();
            }
        }];
    }
    else if (type == NetworkRequestType_PATCH) {
        [weakself.manager PATCH:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                noNetworkBlock();
            }
        }];
    }
    else if (type == NetworkRequestType_PUT) {
        [weakself.manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                noNetworkBlock();
            }
        }];
    }
    else if (type == NetworkRequestType_DELETE) {
        [weakself.manager DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",responseObject);
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                noNetworkBlock();
            }
        }];
    }
    
    [self.manager.operationQueue cancelAllOperations];
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

        NSLog(@"★★★★★★★★★★网络接口接收Json格式:%@",responseObject);
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}

@end
