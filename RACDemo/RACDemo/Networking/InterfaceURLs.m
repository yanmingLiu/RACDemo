//
//  InterfaceURLs.m
//  Tailorx
//
//  Created by   徐安超 on 16/7/13.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "InterfaceURLs.h"

@implementation InterfaceURLs

#pragma mark ------服务器地址(单一数据）------ 开发
#if 1

NSString * const youkexueAPI = @"https://api.develop.ykx100.com/v1/";
//NSString * const youkexueAPI = @"http://youkexue.app/v1/";

// 推送
//NSString * const pushKey = @"23470642";
//NSString * const pushSecret = @"4476cd7e2d57f6c239c3c1909fc02754";
#endif

#pragma mark ------服务器地址(单一数据）--- 测试
#if 0


#endif

#pragma mark ===  生产
#if 0


#endif


/*-------------------------------------------------*/
// 登录
NSString * const login = @"agency/login";
// 退出登录
NSString * const loginOut = @"agency/logout";
//修改密码-获取验证码
NSString * const changePwdCode = @"agency/code";
//获取验证码 - 忘记密码
NSString * const url_get_code = @"com/code";
//修改密码
NSString * const changePwd = @"agency/pwd";
// 登录后选择品牌 @"agency/handle/{agency_id}";
NSString * const chooseBrand = @"agency/handle/";
// 注册
NSString * const url_register = @"agency/reg";
// 找回密码
NSString * const url_find_pwd = @"agency/find";


// 个人资料
NSString * const userInfo = @"agency/me";

/*-------------------------------------------------*/

// 校区列表
NSString * const campuses = @"agency/operation/campus/view/campuses";
// 删除列表
NSString * const deleteCampus = @"agency/operation/campus/drop/campus/";
// 可建校区数量
NSString * const campusCount = @"agency/operation/campus/view/count";
// 编辑校区
NSString * const editCampuses = @"agency/operation/campus/edit/campus/";
// 新建校区
NSString * const addCampuses = @"agency/operation/campus/add/campus";
// 校区详情 agency/operation/campus/view/campus/{id}
NSString * const campusesDetails = @"agency/operation/campus/view/campus/";

/*-------------------------------------------------*/

//校区select列表
 NSString * const url_campusOptions = @"agency/teaching/course/view/campus-options";
//所有班课列表
 NSString * const url_courses = @"agency/teaching/course/view/courses";
//校区班课列表
 NSString * const url_campus_courses = @"agency/teaching/course/view/campus/";
//班课详情
 NSString * const url_course_info = @"agency/teaching/course/view/course/";
//新建班课
 NSString * const url_course_add = @"agency/teaching/course/add/course";
//编辑班课
 NSString * const url_course_edit = @"agency/teaching/course/edit/course/";
//线上报名
 NSString * const url_course_online = @"agency/teaching/course/edit/course/";
//删除班课
 NSString * const url_course_delete = @"agency/teaching/course/drop/course/";
//教师列表
 NSString * const url_course_teachers = @"agency/teaching/course/view/teachers";
//保存上课老师
 NSString * const url_course_teacher_edit = @"agency/teaching/course/edit/course/{course_id}/teachers";
//班课数
 NSString * const url_course_count = @"agency/teaching/course/view/count";
//新建班课时间规则
 NSString * const url_course_timerules_add = @"agency/teaching/course/edit/course/";
//删除上课时间规则
 NSString * const url_course_timerule_delete = @"agency/teaching/course/edit/course/{course_id}/timerule/{timerule_id}";
// 上课时间规则列表 GET /v1/agency/teaching/course/view/course/{course_id}/timerules
NSString * const url_course_timerules_list = @"agency/teaching/course/view/course/";
// 班课类目
NSString * const url_course_category = @"com/sub-category";
// 分类select列表 班课类目
NSString * const url_course_category_list = @"agency/teaching/course/view/category-options";




@end
