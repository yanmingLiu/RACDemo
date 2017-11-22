////
////  YMCacheHelper.m
////  ykxB
////
////  Created by lym on 2017/8/4.
////  Copyright © 2017年 liuyanming. All rights reserved.
////
//
//#import "YMCacheHelper.h"
//
//NSString *const cacheName = @"ykxBCache";
//
//// 存储登录model
//NSString *const key_loginModel = @"key_loginModel";
//
//// 当前选中品牌
//NSString *const key_selectedAgencyModel = @"key_selectedAgencyModel";
//
//// 权限
//NSString *const key_cachePowerModel = @"key_cachePowerModel";
//
//
//@interface YMCacheHelper ()
//
//@property (strong, nonatomic) YYCache *cache;
//
//@end
//
//@implementation YMCacheHelper
//
//+ (instancetype)sharedCacheHelper {
//    static YMCacheHelper *sharedCacheHelper = nil;
//    static dispatch_once_t token;
//    dispatch_once(&token,^{
//        if(sharedCacheHelper == nil){
//            sharedCacheHelper = [[YMCacheHelper alloc]init];
//        }
//    } );
//    return sharedCacheHelper;
//}
//
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        _cache = [YYCache cacheWithName:cacheName];
//        _cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
//    }
//    return self;
//}
//
///*------------------------------------------------------------------------------------*/
//
//// 存储登录model
//- (void)setLoginModel:(YMLoginModel *)loginModel {
//    [_cache setObject:loginModel forKey:key_loginModel];
//}
//- (YMLoginModel *)loginModel {
//    return (YMLoginModel *)[_cache objectForKey:key_loginModel];
//}
//
//// 选择品牌
//- (void)setSelectedAgencyModel:(YMAgencyModel *)selectedAgencyModel {
//    [_cache setObject:selectedAgencyModel forKey:key_selectedAgencyModel];
//}
//
//- (YMAgencyModel *)selectedAgencyModel {
//    return (YMAgencyModel *)[_cache objectForKey:key_selectedAgencyModel];
//}
//
//// 权限
//- (void)setCachePowerModel:(YMPowerModel *)cachePowerModel {
//    [_cache setObject:cachePowerModel forKey:key_cachePowerModel];
//}
//
//- (YMPowerModel *)cachePowerModel {
//    return (YMPowerModel *)[_cache objectForKey:key_cachePowerModel];
//}
//
//
//
//
//@end

