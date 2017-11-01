//
//  YMAPIConst.h
//  youkexueC
//
//  Created by lym on 2017/7/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMAPIConst : NSObject

/** 接口前缀*/
extern NSString *const kApiPrefix;

// 高德地图key
extern NSString *const AMapAPIKey;

#pragma mark - 详细接口地址

//公有接口-七牛公有上传Token
extern NSString * const url_uptoken_qnPublic ;
extern NSString * const url_uptoken_qnPrivate ;

//用户协议
extern NSString * const url_user_protocol;

// markDown
extern NSString * const url_markDown;

/// 图片后缀
extern NSString *const imageSuffix;
extern NSString *const imageSuffix_200;
extern NSString *const imageSuffix_100;
extern NSString *const imageSuffix_50;

/*-----------------------------------------------*/

// 验证码 - 注册 String serverrul="v1/agency/code/reg/"+phone;
extern NSString * const url_getCode_reg;

// 验证码 -  找回密码  http://tapi.youkexue.com/v1/com/code?phone=18300000001&type=bfind
extern NSString * const url_getCode_find;

// 验证码 -  修改密码
extern NSString * const url_getCode_reset;

// 注册
extern NSString * const url_register;

// 登录
extern NSString * const url_login;

// 退出登录
extern NSString * const url_loginOut;

//修改密码
extern NSString * const url_changePwd;

// 忘记密码
extern NSString * const url_findPwd;

// 获取验证码 --- Java
extern NSString * const url_getCode;


/*-------------------------------------------------*/

// 创建机构agency/create
extern NSString * const url_createAgency;

// 帐号下的机构列表
extern NSString * const url_agencyLists;

// 查找机构
extern NSString * const url_agencyFind;

// 加入机构
extern NSString * const url_agencyJion;

// 创建机构
extern NSString * const url_agencyCreate;

// 获取品牌机构基本信息
extern NSString * const url_agencyBaseInfo;

// 填写品牌基本信息
extern NSString * const url_agencyBaseInfoAdd;

// 获取品牌经营类目信息
extern NSString * const url_agencyBusinessCate;

// 分类select列表 班课类目
extern NSString * const url_course_categorys;

// 新增品牌经营类目
extern NSString * const url_addAgency_categorys;

// 删除经营类目
extern NSString * const url_deleteAgency_category;

// 我的-个人资料
extern NSString * const url_userInfo;

// 运营-实名信息登记
extern NSString * const url_RealNameCer;

// 切换品牌
extern NSString * const url_switchAgency;

// 运营-实名登记状态信息查看
extern NSString * const url_previewRealNameInfo;

// 运营-实名登记信息查看
extern NSString * const url_previewRealNameInfo_detail;

// 运营-撤回实名登记
extern NSString * const url_revokeRealNameCer;

// 运营-员工管理-角色列表
extern NSString * const url_roleList;

// 运营-员工管理-添加机构私有角色
extern NSString * const url_addRole;

// 运营-员工管理-获取角色信息
extern NSString * const url_getRoleInfo;

// 运营-员工管理-权限模板
extern NSString * const url_staffPowers;

// 运营-员工管理-编辑机构私有角色
extern NSString * const url_editRole;

// 运营-员工管理-列表接口
extern NSString * const url_getStaffList;

// 运营-员工管理-删除
extern NSString * const url_deleteStaff;

// 运营-员工管理-编辑
extern NSString * const url_editStaff;

// 运营-员工管理-新增
extern NSString * const url_addStaff;

// 运营-员工管理-详情
extern NSString * const url_getStaffDetail;

// 校区列表
extern NSString * const url_campuses;

// 删除列表
extern NSString * const url_deleteCampus;

// 可建校区数量
extern NSString * const url_campusCount;

// 新建校区
extern NSString * const url_addCampuses;

// 校区详情
extern NSString * const url_campusesDetails;

// 校区数
extern NSString * const url_campuses_count;

// 运营-员工管理-删除机构私有角色
extern NSString * const url_deleteRole;

// 运营-员工管理-权限模板
extern NSString * const url_powers;

// 运营-员工管理-申请人列表
extern NSString * const url_getApplicants;

// 运营-员工管理-申请人-通过审核
extern NSString * const url_passApplicant;

// 运营-员工管理-申请人-拒绝
extern NSString * const url_refuseApplicant;

// 删除列表
extern NSString * const url_deleteSchool;

// 编辑校区
extern NSString * const url_editSchool;

// 校区详情 agency/operation/campus/view/campus/{id}
extern NSString * const url_schooolDetails;

// 可建校区-班课数量
extern NSString * const url_maxSchoolClassCount;

// 教学-班课管理-分类列表
extern NSString * const url_classCate ;

// 教学-班课管理-新建班课
extern NSString * const url_classNew;

// 教学-班课管理-班课列表
extern NSString * const url_getClassList;

// 教学-班课管理-教师列表
extern NSString * const url_getClassTeachersList;

// 工作台
extern NSString * const url_workbench;

//删除班课
extern NSString * const url_course_delete;

// 教学-班课管理-编辑班课
extern NSString * const url_editClass;

// 获取品牌机构扩展信息
extern NSString * const url_brandExt;

// 退出机构
extern NSString * const url_outAgency;

// 品牌文化--获取品牌介绍
extern NSString * const url_brand_intro;

// 品牌文化--获取校长寄语
extern NSString * const url_president_message;

// 品牌文化--获取品牌特色
extern NSString * const url_brand_features;

// 团队介绍--删除内容
extern NSString * const url_teamInfo_delete;

// 团队介绍--内容修改
extern NSString * const url_teamInfo_edit;

// 团队介绍--内容添加
extern NSString * const url_teamInfo_add;

// 品牌文化--添加校长寄语
extern NSString * const url_president_messageAdd;

// 品牌文化--添加品牌特色
extern NSString * const url_brandFeatures_add;

// 品牌文化-编辑品牌文化
extern NSString * const url_brandFeatures_edit;

// 品牌文化--查看品牌文化
extern NSString * const url_brandFeatures_look;

// 品牌文化--新增品牌文化
extern NSString * const url_brandCulture_add;

// 品牌文化--添加品牌介绍
extern NSString * const url_brandIntro_add;

// 团队介绍--获取内容列表  3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
extern NSString * const url_teamInfo_list;

// 团队介绍--删除内容 3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
extern NSString * const url_delete_teamInfo;

// 校区列表--管理班课 agency/operation/campus/view/campus/"+curriculumId+"/courses
extern NSString * const url_school_managerClass;



/*------------------------------java-api----------------------------------------*/

// 教学-班课管理-教室列表接口
extern NSString * const url_classrromList;

// 教学-班课管理-校区列表接口
extern NSString * const url_classrrom_config;

// 教学-教室管理-删除教室接口
extern NSString * const url_classrrom_delete;

// 教学-班课管理-校区列表接口
extern NSString * const url_classrrom_schoolList;

// 教学-教室管理-新建教室接口
extern NSString * const url_classrrom_add;

// 教学-教室管理-保存修改后的教室接口
extern NSString * const url_classrrom_edit;

// 教学-课次管理-课次列表接口
extern NSString * const url_getScheduleList;

// 教学-课次管理-新建课次接口
extern NSString * const url_schedule_add;

// 教学-课次管理-删除课次接口
extern NSString * const url_schedule_delete;

// 教学-课次管理-课次详情接口
extern NSString * const url_schedule_detail;

// 教学-课次管理-保存修改后的课次接口
extern NSString * const url_schedule_update;

// 官网管理-班课列表接口
extern NSString * const url_hotClasses;

// 官网管理-更新班课是否热门接口
extern NSString * const url_hotClasses_set;

// 官网管理-官网图标展示接口
extern NSString * const url_getWebImgList;

// 官网管理-点击图标展示内容接口
extern NSString * const url_getWebDetail;

// 删除校区相册 article/deleteImg
extern NSString * const url_deleteAlbum;

// 官网管理-新建文章接口
extern NSString * const url_addArticle;

// 官网管理-保存编辑后的相册接口
extern NSString * const url_updateAlbum;

// 点击相册编辑接口
extern NSString * const url_albumDetail;

// 官网管理-保存修改后的文章接口
extern NSString * const url_updateArticle;

// 官网管理-管理照片接口
extern NSString * const url_managerImage;

// 官网管理-新增照片
extern NSString * const url_addImage;

// 官网管理-保存编辑后的照片接口
extern NSString * const url_updateImage;

// 官网管理-删除文章接口
extern NSString * const url_deleteArticle;

// 获取教师是否热门列表
extern NSString * const url_hotTeacherList;

// 新增或更新品牌文化
extern NSString * const url_saveOrUpdateBrand;

// 品牌信息修改接口 - java新增
extern NSString * const url_agencyUpdate;

// 审核订单列表
extern NSString * const url_getCheckOrderList;

// 更新审核订单状态
extern NSString * const url_updateOrderChaeckStatus;

// 商标管理列表
extern NSString * const url_getBrandList;

// 新增商标
extern NSString * const url_addBrand;

// 修改/变更商标
extern NSString * const url_updateBrand;

// 撤回商标
extern NSString * const url_withdrawBrand;

// 删除商标
extern NSString * const url_deleteBrand;

// 运营-员工管理-履历荣誉列表（新）
extern NSString * const url_staffinfos;

// 运营-员工管理-删除履历荣誉（新）
extern NSString * const url_deleteStaffinfos;

// 运营-员工管理-新增履历（新）
extern NSString * const url_addStaffResumes;

// 运营-员工管理-修改履历（新）
extern NSString * const url_editStaffResumes;







@end
