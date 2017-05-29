//
//  InterfaceURLs.h
//  Tailorx
//
//  Created by   徐安超 on 16/7/13.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterfaceURLs : NSObject

// 服务器
extern NSString * const youkexueAPI;

/*-------------------------------------------------*/
// 推送
extern NSString * const pushKey;
extern NSString * const pushSecret;

/*-------------------------------------------------*/

// 登录
extern NSString * const login;
// 退出登录
extern NSString * const loginOut;
//修改密码-获取验证码
extern NSString * const changePwdCode;
//获取验证码 - 忘记密码
extern NSString * const url_get_code;
//修改密码
extern NSString * const changePwd;
// 登录后选择品牌
extern NSString * const chooseBrand;
// 注册
extern NSString * const url_register;
// 找回密码
extern NSString * const url_find_pwd;



// 个人资料
extern NSString * const userInfo;

/*-------------------------------------------------*/

// 校区列表
extern NSString * const campuses;
// 删除列表
extern NSString * const deleteCampus;
// 可建校区数量
extern NSString * const campusCount;
// 编辑校区
extern NSString * const editCampuses;
// 新建校区
extern NSString * const addCampuses;
// 校区详情
extern NSString * const campusesDetails;

/*-------------------------------------------------*/

//校区select列表
extern NSString * const url_campusOptions;
//所有班课列表
extern NSString * const url_courses;
//校区班课列表
extern NSString * const url_campus_courses;
//班课详情
extern NSString * const url_course_info;
//新建班课
extern NSString * const url_course_add;
//编辑班课
extern NSString * const url_course_edit;
//线上报名
extern NSString * const url_course_online;
//删除班课
extern NSString * const url_course_delete;
//教师列表
extern NSString * const url_course_teachers;
//保存上课老师
extern NSString * const url_course_teacher_edit;
//班课数
extern NSString * const url_course_count;
//新建班课时间规则
extern NSString * const url_course_timerules_add;
//删除上课时间规则
extern NSString * const url_course_timerule_delete;
// 班课类目
extern NSString * const url_course_category;
// 上课时间规则列表 GET /v1/agency/teaching/course/view/course/{course_id}/timerules
extern NSString * const url_course_timerules_list;
// 分类select列表
extern NSString * const url_course_category_list;



@end
