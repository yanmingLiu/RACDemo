//
//  YMNetworkingTool.m
//  demo
//
//  Created by 刘彦铭 on 2015/5/16.
//  Copyright © 2015年 YouKeXue. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YMUploadParam.h"
#import "Header.h"

typedef NS_ENUM(NSUInteger, NetworkRequestType) {
    NetworkRequestType_GET,
    NetworkRequestType_POST,
};



@interface YMNetworkingTool : NSObject

singleton_interface(YMNetworkingTool)

@property (nonatomic,strong) AFHTTPSessionManager * manager;

@property(nonatomic,assign) BOOL networkError;

//https request
- (void)requestWithType:(NetworkRequestType)type URL:(NSString *)urlStr header:(NSDictionary *)headDic parameters:(NSDictionary *)params  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 上传图片
- (void)uploadingWithURL:(NSString *)urlStr header:(NSDictionary *)headDic parameters:(NSDictionary *)params pictureKey:(NSString *)pictureKey files:(NSArray *)imageArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end

