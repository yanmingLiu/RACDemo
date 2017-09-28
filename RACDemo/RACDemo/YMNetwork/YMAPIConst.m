//
//  YMAPIConst.m
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMAPIConst.h"

@implementation YMAPIConst


#if TARGET_LITE == 1  // 生产环境

//NSString *const kApiPrefix = @"https://api.youkexue.com/v1/";      // php
NSString *const kApiPrefix = @"https://server.youkexue.com/b1/";  // java

// 高德地图key
NSString *const AMapAPIKey = @"0eed5b74d957df25390311fe18e4b2e4";
// markDown
NSString * const url_markDown  = @"http://server.youkexue.com/sumCtrl/showRichText";


#elif TARGET_LITE == 2  // 开发环境
/// php
//NSString *const kApiPrefix = @"http://tapi.youkexue.com/v1/";
//NSString *const kApiPrefix = @"http://rapi.youkexue.com/v1/";  

/// java
NSString * const kApiPrefix = @"https://tserver.youkexue.com/b1/";
//NSString * const kApiPrefix2 = @"https://rserver.youkexue.com/b1/";

// 本地
//NSString *const kApiPrefix = @"http://172.20.200.15:8080/b1/"; // 王雄
//NSString *const kApiPrefix = @"http://172.20.200.13:8080/b1/"; // 杜凡

// 高德地图key
NSString *const AMapAPIKey = @"b06c0926d23e86edda9c48448b2ac685";
// markDown
NSString * const url_markDown  = @"http://rserver.youkexue.com/sumCtrl/showRichText";

#endif


    
#pragma mark - 详细接口地址

//公有接口-七牛公有上传Token
NSString * const url_uptoken_qnPublic = @"com/uptoken/public";
NSString * const url_uptoken_qnPrivate = @"com/uptoken/private";

//用户协议
NSString * const url_user_protocol = @"https://file.cdn.youkexue.com/static-page/index.html";


/// 图片后缀
NSString *const imageSuffix = @"?imageView2/2/w/";
NSString *const imageSuffix_200 = @"?imageView2/2/w/200";
NSString *const imageSuffix_100 = @"?imageView2/2/w/100";
NSString *const imageSuffix_50 = @"?imageView2/2/w/50";

/*-------------------------------------------------*/

// 验证码 - 注册 String serverrul="v1/agency/code/reg/"+phone;
NSString * const url_getCode_reg = @"agency/code/reg/";

// 验证码 -  找回密码  http://tapi.youkexue.com/v1/com/code?phone=18300000001&type=bfind
NSString * const url_getCode_find = @"com/code?phone=";

// 验证码 -  修改密码
NSString * const url_getCode_reset = @"agency/code";

// 注册
NSString * const url_register = @"agency/reg";

// 登录
NSString * const url_login= @"agency/login";

// 退出登录
NSString * const url_loginOut = @"agency/logout";

//修改密码
NSString * const url_changePwd = @"agency/pwd";

// 忘记密码
NSString * const url_findPwd = @"agency/find";

//获取验证码 --- Java
NSString * const url_getCode = @"custom/code/login/";

/*-------------------------------------------------*/
// 创建机构
NSString * const url_createAgency = @"agency/create";

// 帐号下的机构列表
NSString * const url_agencyLists = @"agency/lists";

// 查找机构
NSString * const url_agencyFind = @"agency/find/agency";

// 加入机构
NSString * const url_agencyJion = @"agency/apply/agency/";

// 创建机构
NSString * const url_agencyCreate = @"agency/create";

/// 获取品牌机构基本信息
NSString * const url_agencyBaseInfo = @"agency/operation/brand/view";

// 填写品牌基本信息
NSString * const url_agencyBaseInfoAdd = @"agency/operation/brand/add";

/// 获取品牌经营类目信息
NSString * const url_agencyBusinessCate = @"agency/operation/brand/view/cate";

// 分类select列表 班课类目
NSString * const url_course_categorys = @"com/sub-category?code=";

// 新增品牌经营类目
NSString * const url_addAgency_categorys = @"agency/operation/brand/add/cate";

// 删除经营类目
NSString * const url_deleteAgency_category = @"agency/operation/brand/view/del/";

// 我的-个人资料
NSString * const url_userInfo = @"agency/my";

/// 运营-实名信息登记
NSString * const url_RealNameCer = @"agency/operation/real/add";

// 切换品牌
 NSString * const url_switchAgency = @"agency/handle/";

// 运营-实名登记状态信息查看
 NSString * const url_previewRealNameInfo = @"agency/operation/real/view";

// 运营-实名登记信息查看
 NSString * const url_previewRealNameInfo_detail = @"agency/operation/real/view/info";

// 运营-撤回实名登记
 NSString * const url_revokeRealNameCer = @"agency/operation/real/view/revoke/";

// 运营-员工管理-角色列表
 NSString * const url_roleList = @"agency/operation/staff/view/roles";

// 运营-员工管理-添加机构私有角色
 NSString * const url_addRole = @"agency/operation/staff/add/roles";

// 运营-员工管理-获取角色信息
 NSString * const url_getRoleInfo = @"agency/operation/staff/view/role/";

// 运营-员工管理-权限模板
 NSString * const url_staffPowers = @"agency/operation/staff/view/powers";

// 运营-员工管理-编辑机构私有角色
 NSString * const url_editRole = @"agency/operation/staff/edit/roles/";

// 运营-员工管理-列表接口
 NSString * const url_getStaffList = @"agency/operation/staff/view/staff";

// 运营-员工管理-删除
 NSString * const url_deleteStaff = @"agency/operation/staff/drop/staff/";

// 运营-员工管理-编辑
 NSString * const url_editStaff = @"agency/operation/staff/edit/staff/";

// 运营-员工管理-新增
 NSString * const url_addStaff = @"agency/operation/staff/add/staff";

// 运营-员工管理-详情
 NSString * const url_getStaffDetail = @"agency/operation/staff/view/staff/";

// 校区列表
NSString * const url_campuses = @"agency/operation/campus/view/campuses";

// 删除列表
NSString * const url_deleteCampus = @"agency/operation/campus/drop/campus/";

// 可建校区数量
NSString * const url_campusCount = @"agency/operation/campus/view/count";

// 新建校区
NSString * const url_addCampuses = @"agency/operation/campus/add/campus";

// 校区详情 agency/operation/campus/view/campus/{id}
NSString * const url_campusesDetails = @"agency/operation/campus/view/campus/";

// 校区数
NSString * const url_campuses_count = @"agency/operation/campus/view/count";

// 运营-员工管理-删除机构私有角色
 NSString * const url_deleteRole = @"agency/operation/staff/drop/role/";

// 运营-员工管理-权限模板
 NSString * const url_powers = @"agency/operation/staff/view/powers";

// 运营-员工管理-申请人列表
 NSString * const url_getApplicants = @"agency/operation/staff/view/applicants";

// 运营-员工管理-申请人-通过审核
 NSString * const url_passApplicant = @"agency/operation/staff/edit/applicant/";

// 运营-员工管理-申请人-拒绝
NSString * const url_refuseApplicant = @"agency/operation/staff/edit/applicant/";

// 删除列表
NSString * const url_deleteSchool = @"agency/operation/campus/drop/campus/";

// 编辑校区
NSString * const url_editSchool = @"agency/operation/campus/edit/campus/";

// 校区详情 agency/operation/campus/view/campus/{id}
NSString * const url_schooolDetails = @"agency/operation/campus/view/campus/";

// 可建校区-班课数量
NSString * const url_maxSchoolClassCount = @"agency/operation/campus/view/count";

// 教学-班课管理-分类列表
NSString * const url_classCate = @"agency/teaching/course/view/category-options";

// 教学-班课管理-新建班课
 NSString * const url_classNew = @"agency/teaching/course/add/course";

// 教学-班课管理-班课列表
 NSString * const url_getClassList = @"agency/teaching/course/view/courses?";

// 教学-班课管理-教师列表
 NSString * const url_getClassTeachersList = @"agency/teaching/course/view/teachers";

// 工作台
NSString * const url_workbench = @"agency/panel";

//删除班课
NSString * const url_course_delete = @"agency/teaching/course/drop/course/";

// 教学-班课管理-编辑班课
 NSString * const url_editClass = @"agency/teaching/course/edit/course/";

// 获取品牌机构扩展信息
 NSString * const url_brandExt = @"agency/operation/brand/view/ext";

// 退出机构 agency/out/agency/{agency_id}
 NSString * const url_outAgency = @"agency/out/agency/";

// 品牌文化--获取品牌介绍
 NSString * const url_brand_intro = @"agency/official/culture/view/brand_intro";

// 品牌文化--获取校长寄语
NSString * const url_president_message = @"agency/official/culture/view/president_message";

// 品牌文化--获取品牌特色
 NSString * const url_brand_features = @"agency/official/culture/view/brand_features";

// 团队介绍--删除内容
 NSString * const url_teamInfo_delete = @"agency/official/team/drop";

// 团队介绍--内容修改
 NSString * const url_teamInfo_edit = @"agency/official/team/edit";

// 团队介绍--内容添加
 NSString * const url_teamInfo_add = @"agency/official/team/add";

// 品牌文化--添加校长寄语
 NSString * const url_president_messageAdd = @"agency/official/culture/add/president_message";

// 品牌文化--添加品牌特色
NSString * const url_brandFeatures_add = @"agency/official/culture/add/brand_features";

// 品牌文化-编辑品牌文化
 NSString * const url_brandFeatures_edit = @"agency/official/culture/edit/culture";

// 品牌文化--查看品牌文化
 NSString * const url_brandFeatures_look = @"agency/official/culture/view/culture";

// 品牌文化--新增品牌文化
 NSString * const url_brandCulture_add = @"agency/official/culture/add/culture";

// 品牌文化--添加品牌介绍
 NSString * const url_brandIntro_add = @"agency/official/culture/add/brand_intro";

// 团队介绍--获取内容列表 3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
 NSString * const url_teamInfo_list = @"agency/official/team/view?type=";

// 团队介绍--删除内容 3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
 NSString * const url_delete_teamInfo = @"agency/official/team/drop";

// 校区列表--管理班课 agency/operation/campus/view/campus/"+curriculumId+"/courses
 NSString * const url_school_managerClass = @"agency/operation/campus/view/campus/";



/*------------------------------java-api----------------------------------------*/


// 教学-班课管理-教室列表接口
 NSString * const url_classrromList = @"classrrom/getClassRoomList";

// 教学-班课管理-校区列表接口
 NSString * const url_classrrom_config = @"classrrom/findConByAgencyId";

// 教学-教室管理-删除教室接口
 NSString * const url_classrrom_delete = @"classrrom/deleteClassRoom";

// 教学-班课管理-校区列表接口
 NSString * const url_classrrom_schoolList = @"classrrom/findCampuseByAgencyId";

// 教学-教室管理-新建教室接口
 NSString * const url_classrrom_add = @"classrrom/addClassRoom";

// 教学-教室管理-保存修改后的教室接口
 NSString * const url_classrrom_edit = @"classrrom/updateClassRoom";

// 教学-课次管理-课次列表接口
 NSString * const url_getScheduleList = @"schedule/getScheduleList";

// 教学-课次管理-新建课次接口
NSString * const url_schedule_add = @"schedule/addSchedule";

// 教学-课次管理-删除课次接口
 NSString * const url_schedule_delete = @"schedule/deleteSchdule";

// 教学-课次管理-课次详情接口
 NSString * const url_schedule_detail = @"schedule/getScheduleDetail?id=";

// 教学-课次管理-保存修改后的课次接口
 NSString * const url_schedule_update = @"schedule/updateSchedule";

// 官网管理-班课列表接口
 NSString * const url_hotClasses = @"article/getCourseList";

// 官网管理-更新班课是否热门接口
 NSString * const url_hotClasses_set = @"article/updateCourseHot";

// 官网管理-官网图标展示接口
 NSString * const url_getWebImgList = @"article/getWebImgList";

// 官网管理-点击图标展示内容接口
 NSString * const url_getWebDetail = @"article/getWebDetail";

// 删除校区相册 article/deleteImg
 NSString * const url_deleteAlbum = @"article/deleteImg";

// 官网管理-新建文章接口
NSString * const url_addArticle = @"article/addArticle";

// 官网管理-保存编辑后的相册接口
NSString * const url_updateAlbum = @"article/updatePhoto";

// 点击相册编辑接口
 NSString * const url_albumDetail = @"article/editPhoto?id=";

// 官网管理-保存修改后的文章接口
 NSString * const url_updateArticle = @"article/updateArticle";

// 官网管理-管理照片接口
 NSString * const url_managerImage = @"article/managerImg?id=";

// 官网管理-新增照片
NSString * const url_addImage = @"article/addImg";

// 官网管理-保存编辑后的照片接口
 NSString * const url_updateImage = @"article/updateImg";

// 官网管理-删除文章接口
NSString * const url_deleteArticle = @"article/deleteArticle";

// 获取教师是否热门列表
 NSString * const url_hotTeacherList = @"getHotTeacher?";

// 新增或更新品牌文化
NSString * const url_saveOrUpdateBrand = @"article/saveOrUpdateBrand";

// 品牌信息接口
NSString * const url_agencyUpdate = @"agency/update";

// 审核订单列表
 NSString * const url_getCheckOrderList = @"order/getCheckOrderList?";

// 更新审核订单状态
NSString * const url_updateOrderChaeckStatus = @"order/updateOrderChaeckStatus";

// 商标管理列表
NSString * const url_getBrandList = @"brand/getBrandList?";

// 新增商标
NSString * const url_addBrand = @"brand/addBrand";

// 修改/变更商标
NSString * const url_updateBrand = @"brand/updateBrand";

// 撤回商标
 NSString * const url_withdrawBrand = @"brand/withdrawBrand";

// 删除商标
NSString * const url_deleteBrand = @"brand/deleteBrand";

// 运营-员工管理-履历荣誉列表（新）agency/operation/staff/staffinfos/1?status=1
NSString * const url_staffinfos = @"agency/operation/staff/staffinfos/";

// 运营-员工管理-删除履历荣誉（新）
NSString * const url_deleteStaffinfos = @"agency/operation/staff/delete/staffinfos";

// 运营-员工管理-新增履历（新）
NSString * const url_addStaffResumes = @"agency/operation/staff/add/staffinfos";

// 运营-员工管理-修改履历（新）
NSString * const url_editStaffResumes = @"agency/operation/staff/edit/staffinfos";








@end
