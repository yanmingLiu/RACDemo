//
//  YMNetwork.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//


#import "YMNetwork.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YMNetworkCache.h"


#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

NSString * const kLoading = @"正在加载...";
NSString * const kLoadError = @"加载失败";
NSString * const kNetError = @"连接服务器失败!";
NSString * const kSuccessful = @"加载成功";
NSString * const kNoMoreData = @"没有更多数据了";

@implementation YMNetwork

static BOOL _isOpenLog = YES;   // 是否已开启日志打印
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_manager;

+ (void)openLog {
    _isOpenLog = YES;
}

+ (void)closeLog {
    _isOpenLog = NO;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 网络请求

/**
 无缓存
 */
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method URL:(NSString *)urlStr parameters:(id)params success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure {

    return [self requestWithMethod:method URL:urlStr parameters:params responseCache:nil success:success failure:failure];
}

/**
 有缓存
 */
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method URL:(NSString *)urlStr parameters:(id)params responseCache:(YMHttpRequestCache)responseCache success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure {
    
    //读取缓存
    responseCache!=nil ? responseCache([YMNetworkCache httpCacheForURL:urlStr parameters:params]) : nil;
    NSLog(@"\n--------------------->>> responseCache : %@\n", [YMNetworkCache httpCacheForURL:urlStr parameters:params]);
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSLog(@"\n--------------------->>> urlString : %@\n", urlStr);
    NSLog(@"\n--------------------->>> body---> : %@\n", params);
    NSLog(@"\n--------------------->>> head---> : %@\n", _manager.requestSerializer.HTTPRequestHeaders);
    
    // 请求成功回调
    void(^responseSuccess)() = ^(NSURLSessionDataTask * task, id responseObject) {
        if (_isOpenLog) {
            NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
        }
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
        //对数据进行异步缓存
        responseCache!=nil ? [YMNetworkCache setHttpCache:responseObject URL:urlStr parameters:params] : nil;
        
    };
    // 请求失败回调
    void(^responseFailure)() = ^(NSURLSessionDataTask * task, NSError * error) {
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    };
    
    switch (method) {
        case YMKRequestMethodGET:
        {
            NSURLSessionTask *sessionTask = [_manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                responseSuccess(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseFailure(task, error);
            }];
            // 添加sessionTask到数组
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
            
        case YMKRequestMethodPOST:
        {
            NSURLSessionTask *sessionTask = [_manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                responseSuccess(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseFailure(task, error);
            }];
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
        case YMKRequestMethodHEAD:
        {
            NSURLSessionTask *sessionTask = [_manager HEAD:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
        case YMKRequestMethodPUT:
        {
            NSURLSessionTask *sessionTask = [_manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                responseSuccess(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseFailure(task, error);
            }];
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
        case YMKRequestMethodDELETE:
        {
            NSURLSessionTask *sessionTask = [_manager DELETE:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                responseSuccess(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseFailure(task, error);
            }];
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
        case YMKRequestMethodPATCH:
        {
            NSURLSessionTask *sessionTask = [_manager PATCH:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                responseSuccess(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                responseFailure(task, error);
            }];
            sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
            return sessionTask;
        }
    }
    return [[NSURLSessionTask alloc] init];
}



#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(YMHttpProgress)progress
                                  success:(YMHttpRequestSuccess)success
                                  failure:(YMHttpRequestFailed)failure {
    NSURLSessionTask *sessionTask = [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (_isOpenLog) {
//            NSLog(@"responseObject = %@",[self jsonToString:responseObject]);
            NSLog(@"%@", responseObject);
        }
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_isOpenLog) {NSLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(YMHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(YMHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data {
    if(data == nil) { return nil; }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}



#pragma mark - 初始化AFHTTPSessionManager相关属性

/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer.timeoutInterval = 10.f;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
//    [_manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//    [_manager.requestSerializer setValue:@"text/html;charset=UTF-8,application/json" forHTTPHeaderField:@"Accept"];
//    [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    
    
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (void)setRequestSerializer:(YMRequestSerializer)requestSerializer {
    _manager.requestSerializer = requestSerializer==YMRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(YMResponseSerializer)responseSerializer {
    _manager.responseSerializer = responseSerializer==YMResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_manager setSecurityPolicy:securityPolicy];
}

#pragma mark - 开始监听网络

/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

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
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                NSLog(@"WIFI");
                break;
        }
    }];
    [mgr startMonitoring];
}

@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (YMArray)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (YMDictionary)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif

