//
//  YMInterfacedConst.m
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMInterfacedConst.h"

@implementation YMInterfacedConst

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



/*----------------------首页---------------------------*/

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

@end
