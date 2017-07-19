//
//  YMAPIConst.h
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAPIConst : NSObject


#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

/** 接口前缀-开发服务器*/
extern NSString *const kApiPrefix;

#pragma mark - 详细接口地址


//公有接口-七牛公有上传Token
extern NSString * const url_uptoken_qnPublic;

/*-----------------------------------------------*/

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


//品牌列表
extern NSString * const url_custom_brands;


//登录获取验证码
extern NSString * const url_login_code;
//登录
extern NSString * const url_login;
//登出
extern NSString * const url_login_out;

//关注班课列表
extern NSString * const url_myCare_course;
//关注品牌列表
extern NSString * const url_myCare_brand;
//取消/关注 班课
extern NSString * const url_careOrCancel_myCare_course;
//取消/关注 品牌
extern NSString * const url_careOrCancel_myCare_brand;

//获取个人资料
extern NSString * const url_get_myProfile;
//更新个人资料
extern NSString * const url_update_myProfile;



@end
