//
//  YMNetworkHelper.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetworkHelper.h"
#import "QiniuSDK.h"
#import "QNResolver.h"
#import "QNDnsManager.h"
#import "QNNetworkInfo.h"

@implementation YMNetworkHelper

#pragma mark - 请求的公共方法
/**
 无缓存
 */
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method URL:(NSString *)URL parameters:(NSDictionary *)parameter success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure
{
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    [YMNetwork setValue:loginModel.token forHTTPHeaderField:@"X-AUTHTOKEN"];

    // 发起请求
    return [YMNetwork requestWithMethod:method URL:URL parameters:parameter success:^(id responseObject) {
        
        if ([responseObject[kServer_ret] integerValue] == kServer_code_401) {
            // 清空缓存
            [YMCacheHelper sharedCacheHelper].loginModel = [[YMLoginModel alloc] init]; 
            [YMCacheHelper sharedCacheHelper].selectedAgencyModel = [[YMAgencyModel alloc] init];
            
            [MBProgressHUD bwm_showTitle:@"登录失效，请重新登录" toView:Keywindow hideAfter:MBHiddenTime];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MBHiddenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YMLoginController *loginVC = ViewControllerFromSB(SB_Login, SB_ID_Login);
                loginVC.isTokeErro = YES;
                YMNavigationController *loginNavc = [[YMNavigationController alloc] initWithRootViewController:loginVC];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNavc animated:YES completion:nil];            
            });
//            return ;
        }
        success(responseObject);
    } failure:^(NSError *  error) {
        failure(error);
    }];
}

/**
 有缓存
 */
+ (NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method  URL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(YMHttpRequestCache)cache success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure
{
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    [YMNetwork setValue:loginModel.token forHTTPHeaderField:@"X-AUTHTOKEN"];
    
    // 发起请求
    return [YMNetwork requestWithMethod:method URL:URL parameters:parameter responseCache:^(id   responseCache) {
        cache(responseCache);
    } success:^(id   responseObject) {
        
        if ([responseObject[kServer_ret] integerValue] == kServer_code_401) {
            // 清空缓存
            [YMCacheHelper sharedCacheHelper].loginModel = [[YMLoginModel alloc] init]; 
            [YMCacheHelper sharedCacheHelper].selectedAgencyModel = [[YMAgencyModel alloc] init];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MBHiddenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                YMLoginController *loginVC = ViewControllerFromSB(SB_Login, SB_ID_Login);
                YMNavigationController *loginNavc = [[YMNavigationController alloc] initWithRootViewController:loginVC];
                loginVC.isTokeErro = YES;
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNavc animated:YES completion:nil];
            });
//            return ;
        }
        success(responseObject);
    } failure:^(NSError *  error) {
        failure(error);
    }];
}


#pragma mark - 七牛上传
/// 上传1张图片
+ (void)uploadWithImage:(UIImage*)image updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* key))callback
{
    if (image == nil || callback == nil)
        return;
    NSData* data = UIImageJPEGRepresentation(image, 0.5);
    
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[QNResolver systemResolver]];
        QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
        builder.dns = dns;
        //是否选择  https  上传
        builder.useHttps = YES;
        builder.zone = [[QNAutoZone alloc] initWithDns:dns];
        //设置断点续传
        NSError *error;
        builder.recorder =  [QNFileRecorder fileRecorderWithFolder:@"保存目录" error:&error];
    }];
    QNUploadManager* upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    QNUploadOption* uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"percent == %.2f", percent);
    } params:nil checkCrc:NO cancellationSignal:nil];
    
    /// 上传图片
    void(^upBlock)() = ^(NSString *qnToken) {
        [upManager putData:data key:nil token:qnToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.isOK) { NSLog(@"上传完成"); }
                      key = [resp objectForKey:@"key"];
                      NSLog(@"info ===== %@", info);
                      NSLog(@"七牛返回信息resp ===== %@", resp);
                      NSLog(@"key===%@", key);
                      callback(key.length != 0, nil, key);
            
                  }  option:uploadOption];
    };
    /// 获取七牛token
    void(^getQNTokenBlock)() = ^(NSString *url) {
        [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if ([responseObject[kServer_ret] integerValue] == kSuccess_code) {
                NSString *token = responseObject[@"data"][@"token"];
                NSString *domain = responseObject[@"data"][@"domain"];
                YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
                if (updateType == QNUpdateImageTypePublic) {
                    loginModel.qiNiuPublicToken = token;
                    loginModel.qiNiuPublicDomain = domain;
                }else {
                    loginModel.qiNiuPrivateToken = token;
                    loginModel.qiNiuPrivateDomain = domain;
                }
                [YMCacheHelper sharedCacheHelper].loginModel = loginModel;
                
                // 上传
                upBlock(token);
            }
        } failure:^(NSError *error) {
            NSLog(@"获取七牛token失败");
        }]; 
    };
    
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *url;
    if (updateType == QNUpdateImageTypePublic) { // 公有
        if (loginModel.qiNiuPublicToken.length) {
            upBlock(loginModel.qiNiuPublicToken);
        }else {
            url = [kApiPrefix stringByAppendingString:url_uptoken_qnPublic];
            getQNTokenBlock(url);
        }
    }
    else { // 私有
        if (loginModel.qiNiuPrivateToken.length) {
            upBlock(loginModel.qiNiuPrivateToken);
        }else {
            url  = [kApiPrefix stringByAppendingString:url_uptoken_qnPrivate];
            getQNTokenBlock(url);
        }
    }
}

// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* keys))callback {
    __block NSUInteger currentIndex = 0;
    __block NSMutableArray *keys = [NSMutableArray array];
    for (UIImage *img in imageArray) {
        [self uploadWithImage:img updateType:updateType withCallback:^(BOOL success, NSString *msg, NSString *key) {
            if (success) {
                currentIndex += 1;
                [keys addObject:key];
                NSLog(@"%@", key);
                if (currentIndex >= imageArray.count) {
                    callback(YES, @"上传成功",[keys componentsJoinedByString:@","]);
                    return ;
                }
            }else {
                callback(NO, @"上传图片失败", key);
                return ;
            }
        }];
    }
}

/// 七牛上传token
+ (NSURLSessionTask *)getQNTokenWithType:(QNUpdateImageType)type Success:(void (^)(NSString *publicToken))success {
    NSString *url;
    if (type == QNUpdateImageTypePrivate) {
        url  = [kApiPrefix stringByAppendingString:url_uptoken_qnPrivate];
    }else {
        url = [kApiPrefix stringByAppendingString:url_uptoken_qnPublic];
    }
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == kSuccess_code) {
            NSString *token = responseObject[@"data"][@"token"];
            NSString *domain = responseObject[@"data"][@"domain"];
            
            YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
            if (type == QNUpdateImageTypePublic) {
                loginModel.qiNiuPublicToken = token;
                loginModel.qiNiuPublicDomain = domain;
            }else {
                loginModel.qiNiuPrivateToken = token;
                loginModel.qiNiuPrivateDomain = domain;
            }
            [YMCacheHelper sharedCacheHelper].loginModel = loginModel;
            success(token);
        }
    } failure:^(NSError *error) {
        NSLog(@"获取七牛token失败");
    }];    
}

#pragma mark - 业务请求

/// 获取验证码 - Java
+ (NSURLSessionTask *)getCodeWithURLStr:(NSString *)urlStr success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure {
    return [YMNetwork requestWithMethod:YMKRequestMethodGET URL:urlStr parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg); 
    }];
}

/// 获取验证码 - 注册
+ (NSURLSessionTask *)getCodeWithPhoneNum:(NSString *)phoneNum success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    
    NSString *url_suffix = [url_getCode stringByAppendingString:@"1/"];
    NSString *url = [[kApiPrefix stringByAppendingString:url_suffix] stringByAppendingString:phoneNum];
    
    return [self getCodeWithURLStr:url success:^(NSString *code) {
        success(code);
    } failure:^(NSString *erroMsg) {
        failure(kNetworkerro_msg); 
    }];
    
    // PHP
//    NSString *url = [[kApiPrefix stringByAppendingString:url_getCode_reg] stringByAppendingString:phoneNum];
//    return [YMNetwork requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
//        if ([responseObject[kServer_ret] integerValue] == 200) {
//            success(responseObject[kServer_data]);
//        }else {
//            failure(responseObject[kServer_msg]); 
//        }
//    } failure:^(NSError *error) {
//        failure(kNetworkerro_msg); 
//    }];
     
}

/// 获取验证码 - 修改密码
+ (NSURLSessionTask *)getCodeForPwdSetWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure {
    
    NSString *url_suffix = [url_getCode stringByAppendingString:@"5/"];
    NSString *url = [[kApiPrefix stringByAppendingString:url_suffix] stringByAppendingString:phoneNum];
    
    return [self getCodeWithURLStr:url success:^(NSString *code) {
        success(code);
    } failure:^(NSString *erroMsg) {
        failure(kNetworkerro_msg); 
    }];
    
    // PHP
//    NSString *url = [kApiPrefix stringByAppendingString:url_getCode_reset];
//    return [YMNetwork requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
//        if ([responseObject[kServer_ret] integerValue] == 200) {
//            success(responseObject[kServer_data]);
//        }else {
//            failure(responseObject[kServer_msg]); 
//        }
//    } failure:^(NSError *error) {
//        failure(kNetworkerro_msg); 
//    }];
     
}

/// 获取验证码 - 忘记密码
+ (NSURLSessionTask *)getCodeForPwdForgetWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure {
    
    NSString *url_suffix = [url_getCode stringByAppendingString:@"5/"];
    NSString *url = [[kApiPrefix stringByAppendingString:url_suffix] stringByAppendingString:phoneNum];
    
    return [self getCodeWithURLStr:url success:^(NSString *code) {
        success(code);
    } failure:^(NSString *erroMsg) {
        failure(kNetworkerro_msg); 
    }];
    
    // PHP
//    NSString *type = @"&type=bfind";
//    NSString *str = [phoneNum stringByAppendingString:type];
//    NSString *url = [[kApiPrefix stringByAppendingString:url_getCode_find] stringByAppendingString:str];
//    return [YMNetwork requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
//        if ([responseObject[kServer_ret] integerValue] == 200) {
//            success(responseObject[kServer_data]);
//        }else {
//            failure(responseObject[kServer_msg]); 
//        }
//    } failure:^(NSError *error) {
//        failure(kNetworkerro_msg); 
//    }];
     
}

/// 找回密码
+ (NSURLSessionTask *)findPwdWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_findPwd];
    return [YMNetwork requestWithMethod:YMKRequestMethodPATCH URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg); 
    }];
}

/// 重置密码
+ (NSURLSessionTask *)resetPwdWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_changePwd];
    return [self requestWithMethod:YMKRequestMethodPATCH URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 注册
+ (NSURLSessionTask *)registerWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_register];
    return [YMNetwork requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg); 
    }];
}

/// 登录
+ (NSURLSessionTask *)loginWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_login];
    return [YMNetworkHelper requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 退出登录
+ (NSURLSessionTask *)loginOutSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_loginOut];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            YMLoginModel *model = [[YMLoginModel alloc] init];
            [YMCacheHelper sharedCacheHelper].loginModel = model;
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 帐号下的机构列表
+ (NSURLSessionTask *)getAgencyListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyLists];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 查找机构
+ (NSURLSessionTask *)findAgencyWithKeywords:(NSString *)keywords success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyFind];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:@{@"keywords":keywords} success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 加入机构
+ (NSURLSessionTask *)jionAgencyWithAgencyId:(NSString *)agencyId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_agencyJion] stringByAppendingString:agencyId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 创建机构
+ (NSURLSessionTask *)createAgencyWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyCreate];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 获取品牌机构基本信息
+ (NSURLSessionTask *)getAgencyBaseInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *agency_id = [YMCacheHelper sharedCacheHelper].loginModel.agency_id;
    NSString *urlSuffix = [NSString stringWithFormat:@"?agency_id=%@",agency_id];
    NSString *url = [[kApiPrefix stringByAppendingString:url_agencyBaseInfo] stringByAppendingString:urlSuffix];
//    NSString *url = [kApiPrefix stringByAppendingString:url_agencyBaseInfo];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}
    
/// 填写品牌基本信息
+ (NSURLSessionTask *)addAgencyBaseInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyBaseInfoAdd];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 获取品牌经营类目信息
+ (NSURLSessionTask *)getBrandBusinessCateSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyBusinessCate];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 分类select列表 班课类目
+ (NSURLSessionTask *)getCoursCategorysWithCode:(NSString *)code success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_course_categorys] stringByAppendingString:code];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 新增品牌经营类目
+ (NSURLSessionTask *)addAgencyCategoryWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addAgency_categorys];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 删除经营类目
+ (NSURLSessionTask *)deleteAgencyCategoryWithCateId:(NSString *)cateId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_deleteAgency_category] stringByAppendingString:cateId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 我的-个人资料
+ (NSURLSessionTask *)getUserInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_userInfo] ;
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 我的—修改个人信息
+ (NSURLSessionTask *)updateUserInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_userInfo] ;
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-实名信息登记
+ (NSURLSessionTask *)updateRealNameWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_RealNameCer] ;
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 切换品牌
+ (NSURLSessionTask *)switchAgencyWithAgencyId:(NSString *)agencyId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_switchAgency] stringByAppendingString:agencyId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-实名登记状态信息查看
+ (NSURLSessionTask *)previewRealNameInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_previewRealNameInfo];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-实名登记信息查看
+ (NSURLSessionTask *)previewRealNameInfoDetailSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_previewRealNameInfo_detail];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-撤回实名登记
+ (NSURLSessionTask *)revokeRealNameWithCertId:(NSString *)certId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_revokeRealNameCer] stringByAppendingString:certId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-角色列表
+ (NSURLSessionTask *)getRoleListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_roleList];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-添加机构私有角色
+ (NSURLSessionTask *)addRoleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addRole] ;
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-获取角色信息
+ (NSURLSessionTask *)getRoleInfoWithRoleId:(NSString *)roleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_getRoleInfo] stringByAppendingString:roleId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-权限模板
+ (NSURLSessionTask *)getStaffPowersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_staffPowers];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-编辑机构私有角色
+ (NSURLSessionTask *)editRoleWithRoleId:(NSString *)roleId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    
    NSString *url = [[kApiPrefix stringByAppendingString:url_editRole] stringByAppendingString:roleId];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 运营-员工管理-列表接口
+ (NSURLSessionTask *)getStaffListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_getStaffList] ;
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 运营-员工管理-删除
+ (NSURLSessionTask *)deleteStaffWithStaffId:(NSString *)staffId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_deleteStaff] stringByAppendingString:staffId];
    return [self requestWithMethod:YMKRequestMethodDELETE URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-编辑
+ (NSURLSessionTask *)editStaffWithStaffId:(NSString *)staffId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_editStaff] stringByAppendingString:staffId];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-新增
+ (NSURLSessionTask *)addStaffWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addStaff];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-详情
+ (NSURLSessionTask *)getStaffDetailWithStaffId:(NSString *)staffId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_getStaffDetail] stringByAppendingString:staffId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 校区列表
+ (NSURLSessionTask *)getCampusListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_campuses];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 新建校区
+ (NSURLSessionTask *)addCampusWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addCampuses];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-删除机构私有角色
+ (NSURLSessionTask *)deleteRoleWithRoleId:(NSString *)roleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_deleteRole] stringByAppendingString:roleId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-权限模板
+ (NSURLSessionTask *)getPowersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_powers];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-申请人列表
+ (NSURLSessionTask *)getApplicantsSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_getApplicants];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-申请人-通过审核
+ (NSURLSessionTask *)putPassApplicantWithAccountId:(NSString *)accountId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *str = [NSString stringWithFormat:@"%@/pass", accountId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_passApplicant] stringByAppendingString:str];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-申请人-拒绝
+ (NSURLSessionTask *)putReturnApplicantWithAccountId:(NSString *)accountId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *str = [NSString stringWithFormat:@"%@/refuse", accountId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_refuseApplicant] stringByAppendingString:str];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 删除校区
+ (NSURLSessionTask *)deleteSchoolWithCampusId:(NSString *)campusId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_deleteSchool] stringByAppendingString:campusId];
    return [self requestWithMethod:YMKRequestMethodDELETE URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 校区详情
+ (NSURLSessionTask *)getSchoolDetailWithCampusId:(NSString *)campusId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_schooolDetails] stringByAppendingString:campusId];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 编辑校区
+ (NSURLSessionTask *)editSchoolWithCampusId:(NSString *)campusId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_editSchool] stringByAppendingString:campusId];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 可建校区-班课数量
+ (NSURLSessionTask *)getMaxSchoolClassCountSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_maxSchoolClassCount];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-班课管理-分类列表
+ (NSURLSessionTask *)getClassCateSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_classCate];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-班课管理-新建班课
+ (NSURLSessionTask *)newClassWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_classNew];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 教学-班课管理-班课列表
+ (NSURLSessionTask *)getClassListWithPage:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *suffix = [NSString stringWithFormat:@"per_page=10&page=%zd", page];
    NSString *url = [[kApiPrefix stringByAppendingString:url_getClassList] stringByAppendingString:suffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-班课管理-教师列表
+ (NSURLSessionTask *)getClassTeachersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_getClassTeachersList];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

// 首页数据
+ (NSURLSessionTask *)getPanelSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_workbench];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 删除班课
+ (NSURLSessionTask *)deleteCoursWithCourseId:(NSString *)course_id success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_course_delete] stringByAppendingString:course_id];
    return [self requestWithMethod:YMKRequestMethodDELETE URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-班课管理-编辑班课
+ (NSURLSessionTask *)editClassWithId:(NSString *)course_id params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_editClass] stringByAppendingString:course_id];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 获取品牌机构扩展信息
+ (NSURLSessionTask *)getBrandExtSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandExt];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 退出机构 agency/out/agency/{agency_id}
+ (NSURLSessionTask *)outAgencyWithAgency_id:(NSString *)agency_id success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_outAgency] stringByAppendingString:agency_id];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

// 品牌文化--获取品牌介绍
+ (NSURLSessionTask *)getBrandIntroSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brand_intro];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

// 品牌文化--添加品牌介绍
+ (NSURLSessionTask *)editBrandIntroWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandIntro_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--添加品牌特色
+ (NSURLSessionTask *)editBrandFeaturesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandFeatures_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--添加校长寄语
+ (NSURLSessionTask *)editPresidentMessageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandFeatures_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--获取品牌特色
+ (NSURLSessionTask *)getBrandFeaturesSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brand_features];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }]; 
}

/// 品牌文化--添加校长寄语--添加品牌介绍--添加品牌特色
+ (NSURLSessionTask *)editBrandFeaturesWithUrl:(NSString *)urlStr params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:urlStr];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--获取校长寄语
+ (NSURLSessionTask *)getPresidentMessageSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_president_message];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }]; 
}

/// 团队介绍--获取内容列表  3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
+ (NSURLSessionTask *)getCultureContentWithType:(NSString *)type success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [[kApiPrefix stringByAppendingString:url_teamInfo_list] stringByAppendingString:type];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }]; 
}

/// 团队介绍--删除内容 3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
+ (NSURLSessionTask *)deleteCultureContentWithcontentId:(NSString *)contentId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_delete_teamInfo];
    NSDictionary *param = @{@"id" : contentId.length ? contentId : @""};
    return [self requestWithMethod:YMKRequestMethodDELETE URL:url parameters:param success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 团队介绍--内容添加
+ (NSURLSessionTask *)addTeamInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_teamInfo_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 团队介绍--内容修改
+ (NSURLSessionTask *)editTeamInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_teamInfo_edit];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--新增品牌文化
+ (NSURLSessionTask *)addCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandCulture_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化--查看品牌文化
+ (NSURLSessionTask *)getCultureSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandFeatures_look];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌文化-编辑品牌文化
+ (NSURLSessionTask *)editCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_brandFeatures_edit];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 校区列表--管理班课 agency/operation/campus/view/campus/"+curriculumId+"/courses url_school_managerClass
+ (NSURLSessionTask *)getSchoolClassWithSchoolId:(NSString *)schoolId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *suffix = [NSString stringWithFormat:@"%@/courses",schoolId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_school_managerClass] stringByAppendingString:suffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/*------------------------------java-api----------------------------------------*/

/// 教学-班课管理-教室列表接口
+ (NSURLSessionTask *)getClassroomListWithType:(NSInteger)type params:(NSDictionary *)params page:(NSInteger)page ultureSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
 
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *campus_id = [params objectForKey:@"campus_id"];
    //    NSString *urlSuff = [NSString stringWithFormat:@"?agency_id=%@&campus_id=%@&staff_id=%@&page=%zd&type=%zd",@"136",@"38",@"1",page,type];
    NSString *urlSuff = [NSString stringWithFormat:@"?agency_id=%@&campus_id=%@&page=%zd&type=%zd",loginModel.agency_id,campus_id,page,type];
    NSString *url = [[kApiPrefix stringByAppendingString:url_classrromList] stringByAppendingString:urlSuff];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-班课管理-校区列表接口 - 教室配置
+ (NSURLSessionTask *)getClassroomConfigSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
 
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *agency_id = [NSString stringWithFormat:@"?agency_id=%@", loginModel.agency_id];
    
    NSString *url = [[kApiPrefix stringByAppendingString:url_classrrom_config] stringByAppendingString:agency_id];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

///  教学-教室管理-删除教室接口
+ (NSURLSessionTask *)deleteClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_classrrom_delete];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 教学-班课管理-校区列表接口
+ (NSURLSessionTask *)getClassroomSchoolListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
 
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *agency_id = [NSString stringWithFormat:@"?agency_id=%@", loginModel.agency_id];
    
    NSString *url = [[kApiPrefix stringByAppendingString:url_classrrom_schoolList] stringByAppendingString:agency_id];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-教室管理-新建教室接口
+ (NSURLSessionTask *)addClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_classrrom_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-教室管理-保存修改后的教室接口
+ (NSURLSessionTask *)editClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {

    NSString *url = [kApiPrefix stringByAppendingString:url_classrrom_edit];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

///  教学-课次管理-课次列表接口
+ (NSURLSessionTask *)getScheduleListWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_getScheduleList];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

///  教学-课次管理-新建课次接口
+ (NSURLSessionTask *)addScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_schedule_add];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-课次管理-删除课次接口
+ (NSURLSessionTask *)deleteScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_schedule_delete];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-课次管理-课次详情接口
+ (NSURLSessionTask *)getScheduleDetailWithScheduleId:(NSInteger)scheduleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *ID = [NSString stringWithFormat:@"%zd",scheduleId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_schedule_detail] stringByAppendingString:ID];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 教学-课次管理-保存修改后的课次接口
+ (NSURLSessionTask *)updateScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_schedule_update];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-班课列表接口 查询热门班课（type=1） 查询非热门班课（type=0） 条件模糊查询（班课名称，课程类别）
+ (NSURLSessionTask *)getHotClassesWithType:(NSInteger)type keywords:(NSString *)keywords success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
//    NSString *urlSuffix = [NSString stringWithFormat:@"agency_id=%zd&type=%zd&keywords=%@", 577, type, keywords]; // 本地测试
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *url = [kApiPrefix stringByAppendingString:url_hotClasses];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:loginModel.agency_id forKey:@"agency_id"];
    [params setObject:[NSString stringWithFormat:@"%zd",type] forKey:@"type"];
    [params setObject:keywords.length ? keywords : @"" forKey:@"keywords"];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


///  官网管理-更新班课是否热门接口
+ (NSURLSessionTask *)updateHotClassesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_hotClasses_set];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-官网图标展示接口
+ (NSURLSessionTask *)getWebImgListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
//    NSString *urlSuffix = [NSString stringWithFormat:@"?agency_id=%zd", 577]; //本地调试
 
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *urlSuffix = [NSString stringWithFormat:@"?agency_id=%@", loginModel.agency_id];
    NSString *url = [[kApiPrefix stringByAppendingString:url_getWebImgList] stringByAppendingString:urlSuffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-点击图标展示内容接口
+ (NSURLSessionTask *)getWebDetailWithWebIconId:(NSInteger)webIconId flag:(NSInteger)flag keywords:(NSString *)keywords page:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *urlSuffix = [NSString stringWithFormat:@"?id=%zd&flag=%zd&keywords=%@&page=%zd", webIconId, flag, keywords,page];
    NSString *url = [[kApiPrefix stringByAppendingString:url_getWebDetail] stringByAppendingString:urlSuffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-点击图标展示内容接口 -- 用于品牌文化列表
+ (NSURLSessionTask *)getWebDetailWithWebIconId:(NSInteger)webIconId flag:(NSInteger)flag success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *urlSuffix = [NSString stringWithFormat:@"?id=%zd&flag=%zd&brand=%@", webIconId, flag, @"brand"];
    NSString *url = [[kApiPrefix stringByAppendingString:url_getWebDetail] stringByAppendingString:urlSuffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 删除校区相册 article/deleteImg
+ (NSURLSessionTask *)deleteAlbumWithWebAlbumId:(NSInteger)albumId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_deleteAlbum];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:@{@"id" : [NSString stringWithFormat:@"%zd",albumId]} success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-新建文章接口
+ (NSURLSessionTask *)addArticleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addArticle];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-保存编辑后的相册接口
+ (NSURLSessionTask *)updateAlbumWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_updateAlbum];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 点击相册编辑接口
+ (NSURLSessionTask *)getAlbumDetailWithAlbumId:(NSInteger)albumId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *urlSuffix = [NSString stringWithFormat:@"%zd", albumId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_albumDetail] stringByAppendingString:urlSuffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-保存修改后的文章接口
+ (NSURLSessionTask *)updateArticleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_updateArticle];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-管理照片接口
+ (NSURLSessionTask *)getImageWithWebCateId:(NSInteger)cateId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *urlSuffix = [NSString stringWithFormat:@"%zd", cateId];
    NSString *url = [[kApiPrefix stringByAppendingString:url_managerImage] stringByAppendingString:urlSuffix];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}


/// 官网管理-新增照片
+ (NSURLSessionTask *)addImageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addImage];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-保存编辑后的照片接口
+ (NSURLSessionTask *)updateImageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_updateImage];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 官网管理-删除文章接口
+ (NSURLSessionTask *)deleteArticleWithArticleId:(NSInteger)articleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_deleteArticle];
    NSString *articleIdStr = [NSString stringWithFormat:@"%zd",articleId];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:@{@"id" : articleIdStr} success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 获取教师是否热门列表
+ (NSURLSessionTask *)getHotTeacherWithType:(NSInteger)type success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
//    NSString *urlSuffix = [NSString stringWithFormat:@"agency_id=%zd&type=%zd", 577, type];
 
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *urlSuffix = [NSString stringWithFormat:@"agency_id=%@&type=%zd", loginModel.agency_id, type];
    NSString *url = [[kApiPrefix stringByAppendingString:url_hotTeacherList] stringByAppendingString:urlSuffix];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 新增或更新品牌文化
+ (NSURLSessionTask *)saveOrUpdateBrandCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_saveOrUpdateBrand];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 品牌信息修改接口 - java新增
+ (NSURLSessionTask *)updateBrandInfoParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_agencyUpdate];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 审核订单列表 - 待审核订单 默认值=1；已审核订单 默认值=2
+ (NSURLSessionTask *)getCheckOrderListWithType:(NSInteger)type page:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *urlSuffix = [NSString stringWithFormat:@"agency_id=%@&check_status=%zd&page=%zd", loginModel.agency_id, type, page];
    NSString *url = [[kApiPrefix stringByAppendingString:url_getCheckOrderList] stringByAppendingString:urlSuffix];
    
//    NSString *url = [NSString stringWithFormat:@"http://172.20.200.13:8080/b1/order/getCheckOrderList?%@",urlSuffix];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 更新审核订单状态
+ (NSURLSessionTask *)updateOrderChaeckStatusWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    
    NSString *url = [kApiPrefix stringByAppendingString:url_updateOrderChaeckStatus];
//    NSString *url = [@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_updateOrderChaeckStatus];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 商标管理列表
+ (NSURLSessionTask *)getBrandListWithWithPage:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    NSString *urlSuffix = [NSString stringWithFormat:@"agency_id=%@&page=%zd", loginModel.agency_id, page];
    
    NSString *url = [[kApiPrefix stringByAppendingString:url_getBrandList] stringByAppendingString:urlSuffix];
//    NSString *url = [[@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_getBrandList] stringByAppendingString:urlSuffix];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 新增商标
+ (NSURLSessionTask *)addBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addBrand];
//    NSString *url = [@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_addBrand];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 修改/变更商标
+ (NSURLSessionTask *)updateBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_updateBrand];
//    NSString *url = [@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_updateBrand];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

// 撤回商标
+ (NSURLSessionTask *)withdrawBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_withdrawBrand];
//    NSString *url = [@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_withdrawBrand];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 删除商标
+ (NSURLSessionTask *)deleteBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
        NSString *url = [kApiPrefix stringByAppendingString:url_deleteBrand];
//    NSString *url = [@"http://172.20.200.13:8080/b1/" stringByAppendingString:url_deleteBrand];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-履历荣誉列表（新）agency/operation/staff/staffinfos/1?status=1   1.履历2.荣誉
+ (NSURLSessionTask *)getStaffinfosWithStaffId:(NSInteger)staffId status:(NSInteger)status success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    
    NSString *urlSuffix = [NSString stringWithFormat:@"%@%zd?status=%zd",url_staffinfos,staffId, status];
    NSString *url = [kApiPrefix stringByAppendingString:urlSuffix];
    
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:nil success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-删除履历荣誉（新）
+ (NSURLSessionTask *)deleteStaffinfosWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_deleteStaffinfos];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-新增履历（新）
+ (NSURLSessionTask *)addStaffResumesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_addStaffResumes];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

/// 运营-员工管理-修改履历（新）
+ (NSURLSessionTask *)editStaffResumesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure {
    NSString *url = [kApiPrefix stringByAppendingString:url_editStaffResumes];
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if ([responseObject[kServer_ret] integerValue] == 200) {
            success(responseObject[kServer_data]);
        }else {
            failure(responseObject[kServer_msg]); 
        }
    } failure:^(NSError *error) {
        failure(kNetworkerro_msg);
    }];
}

#pragma mark -lili-api

+ (NSURLSessionTask *)getAdvertListWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void (^)(NSString *))failure
{
    NSString *url = [kApiPrefix stringByAppendingString:@"advert/getAdvertList?"];
    YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:@{@"agency_id":loginModel.agency_id} success:^(id responseObject) {
        if (kSuccess_code == [responseObject[kServer_ret] integerValue])
        {
            if (success) success(responseObject[@"data"]);  // 传出数据
        }
        else
        {
            if (failure) failure(responseObject[kServer_msg]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(kNetworkerro_msg);
    }];
}

+ (NSURLSessionTask *)getAdvertDetailWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void (^)(NSString *))failure
{
    NSString *url = [kApiPrefix stringByAppendingString:@"advert/getAdvertDetail?"];
    return [self requestWithMethod:YMKRequestMethodGET URL:url parameters:params success:^(id responseObject) {
        if (kSuccess_code == [responseObject[kServer_ret] integerValue])
        {
            if (success) success(responseObject[@"data"]);  // 传出数据
        }
        else
        {
            if (failure) failure(responseObject[kServer_msg]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(kNetworkerro_msg);
    }];
}

+ (NSURLSessionTask *)updateAdvertDetailWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void (^)(NSString *))failure
{
    NSString *url = [kApiPrefix stringByAppendingString:@"advert/updateAdvertDetail"];
    
    return [self requestWithMethod:YMKRequestMethodPOST URL:url parameters:params success:^(id responseObject) {
        if (kSuccess_code == [responseObject[kServer_ret] integerValue])
        {
            if (success) success(responseObject[@"data"]);  // 传出数据
        }
        else
        {
            if (failure) failure(responseObject[kServer_msg]);
        }
    } failure:^(NSError *error) {
        if (failure) failure(kNetworkerro_msg);
    }];
}


/*------------------------------java-api----------------------------------------*/

@end






