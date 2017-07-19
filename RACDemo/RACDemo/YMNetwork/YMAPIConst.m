//
//  YMAPIConst.m
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMAPIConst.h"

@implementation YMAPIConst


#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"http://api.develop.ykx100.com/v1/";

#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";

#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";

#endif

#pragma mark - 详细接口地址

//公有接口-七牛公有上传Token
NSString * const url_uptoken_qnPublic = @"com/uptoken/public";

/*-------------------------------------------------*/

//关键词
NSString * const url_home_keywords = @"custom/keywords";
//分类
NSString * const url_home_series = @"custom/series";
//推荐品牌
NSString * const url_home_brands = @"custom/home/brands";
//推荐班课
NSString * const url_home_courses = @"custom/courses";
//城市
NSString * const url_home_area = @"custom/cities";
//班课类别
NSString * const url_courses_categorys = @"custom/category-options";
//关键字搜索
NSString * const url_custom_statistics = @"custom/statistics?word=";
//搜索区域
NSString * const url_custom_area = @"custom/area-options";


//品牌列表
NSString * const url_custom_brands = @"custom/brands";

//登录获取验证码
NSString * const url_login_code = @"custom/code/login/";
//登录
NSString * const url_login = @"custom/login?";
//登出
NSString * const url_login_out = @"custom/logout";


//关注班课列表
NSString * const url_myCare_course = @"custom/my/course-follows";
//关注品牌列表
NSString * const url_myCare_brand = @"custom/my/brand-follows";
//取消\关注 班课
NSString * const url_careOrCancel_myCare_course = @"custom/my/course/";
//取消\关注 品牌
NSString * const url_careOrCancel_myCare_brand = @"custom/my/brand/";

//获取个人资料
NSString * const url_get_myProfile = @"custom/my/profile";
//更新个人资料
NSString * const url_update_myProfile = @"custom/my/profile";



@end
