//
//  YMInterfacedConst.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import <Foundation/Foundation.h>

@interface YMInterfacedConst : NSObject

#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

/** 接口前缀-开发服务器*/
extern NSString *const kApiPrefix;

#pragma mark - 详细接口地址


//关键词
extern NSString * const url_home_keywords;
//九大分类
extern NSString * const url_home_series;
//推荐品牌
extern NSString * const url_home_brands;
//推荐班课
extern NSString * const url_home_courses;
//城市
extern NSString * const url_home_area;
//班课类别
extern NSString * const url_courses_categorys;
//关键字搜索
extern NSString * const url_custom_statistics;
//搜索区域
extern NSString * const url_custom_area;



























@end
