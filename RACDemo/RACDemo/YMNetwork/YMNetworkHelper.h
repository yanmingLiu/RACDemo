//
//  YMNetworkHelper.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//

#import "YMNetwork.h"
#import "YMAPIConst.h"

typedef NS_ENUM(NSUInteger, QNUpdateImageType) {
    QNUpdateImageTypePublic,
    QNUpdateImageTypePrivate,
};

@interface YMNetworkHelper : NSObject

#pragma mark - 七牛上传

/// 上传1张图片
+ (void)uploadWithImage:(UIImage*)image updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* key))callback;

/// 上传多张图片,按队列依次上传
+ (void)uploadImages:(NSArray *)imageArray updateType:(QNUpdateImageType)updateType withCallback:(void(^)(BOOL success, NSString* msg, NSString* keys))callback;

#pragma mark -

/// 获取验证码 - Java
+ (NSURLSessionTask *)getCodeWithURLStr:(NSString *)urlStr success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure;

/// 获取验证码 - 注册
+ (NSURLSessionTask *)getCodeWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure;

/// 获取验证码 - 修改密码
+ (NSURLSessionTask *)getCodeForPwdSetWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure;

/// 获取验证码 - 忘记密码
+ (NSURLSessionTask *)getCodeForPwdForgetWithPhoneNum:(NSString *)phoneNum success:(void(^)(NSString *code))success failure:(void(^)(NSString *erroMsg))failure;

/// 找回密码
+ (NSURLSessionTask *)findPwdWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 重置密码
+ (NSURLSessionTask *)resetPwdWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 注册
+ (NSURLSessionTask *)registerWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 登录
+ (NSURLSessionTask *)loginWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 退出登录
+ (NSURLSessionTask *)loginOutSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 帐号下的机构列表 
+ (NSURLSessionTask *)getAgencyListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 查找机构
+ (NSURLSessionTask *)findAgencyWithKeywords:(NSString *)keywords success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 加入机构
+ (NSURLSessionTask *)jionAgencyWithAgencyId:(NSString *)agencyId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 创建机构
+ (NSURLSessionTask *)createAgencyWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 获取品牌机构基本信息
+ (NSURLSessionTask *)getAgencyBaseInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 填写品牌基本信息
+ (NSURLSessionTask *)addAgencyBaseInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 获取品牌经营类目信息
+ (NSURLSessionTask *)getBrandBusinessCateSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 分类select列表 班课类目
+ (NSURLSessionTask *)getCoursCategorysWithCode:(NSString *)code success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 新增品牌经营类目
+ (NSURLSessionTask *)addAgencyCategoryWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 删除经营类目
+ (NSURLSessionTask *)deleteAgencyCategoryWithCateId:(NSString *)cateId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 我的-个人资料
+ (NSURLSessionTask *)getUserInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 我的—修改个人信息
+ (NSURLSessionTask *)updateUserInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-实名信息登记
+ (NSURLSessionTask *)updateRealNameWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 切换品牌
+ (NSURLSessionTask *)switchAgencyWithAgencyId:(NSString *)agencyId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-实名登记状态信息查看
+ (NSURLSessionTask *)previewRealNameInfoSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-实名登记信息查看
+ (NSURLSessionTask *)previewRealNameInfoDetailSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-撤回实名登记
+ (NSURLSessionTask *)revokeRealNameWithCertId:(NSString *)certId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-角色列表
+ (NSURLSessionTask *)getRoleListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-添加机构私有角色
+ (NSURLSessionTask *)addRoleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-获取角色信息
+ (NSURLSessionTask *)getRoleInfoWithRoleId:(NSString *)roleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-权限模板
+ (NSURLSessionTask *)getStaffPowersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-编辑机构私有角色
+ (NSURLSessionTask *)editRoleWithRoleId:(NSString *)roleId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-列表接口
+ (NSURLSessionTask *)getStaffListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-删除
+ (NSURLSessionTask *)deleteStaffWithStaffId:(NSString *)staffId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-编辑
+ (NSURLSessionTask *)editStaffWithStaffId:(NSString *)staffId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-新增
+ (NSURLSessionTask *)addStaffWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-详情
+ (NSURLSessionTask *)getStaffDetailWithStaffId:(NSString *)staffId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 校区列表
+ (NSURLSessionTask *)getCampusListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 添加校区
+ (NSURLSessionTask *)addCampusWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-删除机构私有角色
+ (NSURLSessionTask *)deleteRoleWithRoleId:(NSString *)roleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-权限模板
+ (NSURLSessionTask *)getPowersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-申请人列表
+ (NSURLSessionTask *)getApplicantsSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-申请人-通过审核
+ (NSURLSessionTask *)putPassApplicantWithAccountId:(NSString *)accountId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-申请人-拒绝
+ (NSURLSessionTask *)putReturnApplicantWithAccountId:(NSString *)accountId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 删除校区
+ (NSURLSessionTask *)deleteSchoolWithCampusId:(NSString *)campusId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 校区详情
+ (NSURLSessionTask *)getSchoolDetailWithCampusId:(NSString *)campusId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 编辑校区
+ (NSURLSessionTask *)editSchoolWithCampusId:(NSString *)campusId params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 可建校区-班课数量
+ (NSURLSessionTask *)getMaxSchoolClassCountSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-分类列表
+ (NSURLSessionTask *)getClassCateSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-新建班课
+ (NSURLSessionTask *)newClassWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-班课列表
+ (NSURLSessionTask *)getClassListWithPage:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-教师列表
+ (NSURLSessionTask *)getClassTeachersSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 首页数据
+ (NSURLSessionTask *)getPanelSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 删除班课
+ (NSURLSessionTask *)deleteCoursWithCourseId:(NSString *)course_id success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-编辑班课
+ (NSURLSessionTask *)editClassWithId:(NSString *)course_id params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 获取品牌机构扩展信息
+ (NSURLSessionTask *)getBrandExtSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 退出机构 agency/out/agency/{agency_id}
+ (NSURLSessionTask *)outAgencyWithAgency_id:(NSString *)agency_id success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--获取品牌介绍
+ (NSURLSessionTask *)getBrandIntroSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--添加品牌介绍
+ (NSURLSessionTask *)editBrandIntroWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--添加品牌特色
+ (NSURLSessionTask *)editBrandFeaturesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--添加校长寄语
+ (NSURLSessionTask *)editPresidentMessageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--获取品牌特色
+ (NSURLSessionTask *)getBrandFeaturesSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--添加校长寄语--添加品牌介绍--添加品牌特色
+ (NSURLSessionTask *)editBrandFeaturesWithUrl:(NSString *)urlStr params:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--获取校长寄语
+ (NSURLSessionTask *)getPresidentMessageSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 团队介绍--获取内容列表  3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
+ (NSURLSessionTask *)getCultureContentWithType:(NSString *)type success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 团队介绍--删除内容 3品牌荣誉 5教学团队 6运营团队 7管理团队 8教研团队 9品牌动态 10教育资讯 11教学成果 12教研成果 13优惠活动
+ (NSURLSessionTask *)deleteCultureContentWithcontentId:(NSString *)contentId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 团队介绍--内容添加
+ (NSURLSessionTask *)addTeamInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 团队介绍--内容修改
+ (NSURLSessionTask *)editTeamInfoWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--新增品牌文化
+ (NSURLSessionTask *)addCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化--查看品牌文化
+ (NSURLSessionTask *)getCultureSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌文化-编辑品牌文化
+ (NSURLSessionTask *)editCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 校区列表--管理班课 agency/operation/campus/view/campus/"+curriculumId+"/courses url_school_managerClass
+ (NSURLSessionTask *)getSchoolClassWithSchoolId:(NSString *)schoolId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;




/*------------------------------java-api----------------------------------------*/

/// 教学-班课管理-教室列表接口 type: 1.校区管理-教室管理进入 ;2.教室管理进入
+ (NSURLSessionTask *)getClassroomListWithType:(NSInteger)type params:(NSDictionary *)params page:(NSInteger)page ultureSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理 - 教室配置
+ (NSURLSessionTask *)getClassroomConfigSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

///  教学-教室管理-删除教室接口
+ (NSURLSessionTask *)deleteClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-班课管理-校区列表接口
+ (NSURLSessionTask *)getClassroomSchoolListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-教室管理-新建教室接口
+ (NSURLSessionTask *)addClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-教室管理-保存修改后的教室接口
+ (NSURLSessionTask *)editClassroomWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

///  教学-课次管理-课次列表接口
+ (NSURLSessionTask *)getScheduleListWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

///  教学-课次管理-新建课次接口
+ (NSURLSessionTask *)addScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-课次管理-删除课次接口
+ (NSURLSessionTask *)deleteScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-课次管理-课次详情接口
+ (NSURLSessionTask *)getScheduleDetailWithScheduleId:(NSInteger)scheduleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 教学-课次管理-保存修改后的课次接口
+ (NSURLSessionTask *)updateScheduleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-班课列表接口 查询热门班课（type=1） 查询非热门班课（type=0） 条件模糊查询（班课名称，课程类别）
+ (NSURLSessionTask *)getHotClassesWithType:(NSInteger)type keywords:(NSString *)keywords success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

///  官网管理-更新班课是否热门接口
+ (NSURLSessionTask *)updateHotClassesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-官网图标展示接口
+ (NSURLSessionTask *)getWebImgListSuccess:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-点击图标展示内容接口
+ (NSURLSessionTask *)getWebDetailWithWebIconId:(NSInteger)webIconId flag:(NSInteger)flag keywords:(NSString *)keywords page:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-点击图标展示内容接口 -- 用于品牌文化列表
+ (NSURLSessionTask *)getWebDetailWithWebIconId:(NSInteger)webIconId flag:(NSInteger)flag success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 删除校区相册 article/deleteImg
+ (NSURLSessionTask *)deleteAlbumWithWebAlbumId:(NSInteger)albumId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-新建文章接口
+ (NSURLSessionTask *)addArticleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-保存编辑后的相册接口
+ (NSURLSessionTask *)updateAlbumWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 点击相册编辑接口
+ (NSURLSessionTask *)getAlbumDetailWithAlbumId:(NSInteger)albumId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-保存修改后的文章接口
+ (NSURLSessionTask *)updateArticleWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-管理照片接口
+ (NSURLSessionTask *)getImageWithWebCateId:(NSInteger)cateId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-新增照片
+ (NSURLSessionTask *)addImageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-保存编辑后的照片接口
+ (NSURLSessionTask *)updateImageWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 官网管理-删除文章接口
+ (NSURLSessionTask *)deleteArticleWithArticleId:(NSInteger)articleId success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 获取教师是否热门列表
+ (NSURLSessionTask *)getHotTeacherWithType:(NSInteger)type success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 新增或更新品牌文化
+ (NSURLSessionTask *)saveOrUpdateBrandCultureWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 品牌信息修改接口 - java新增
+ (NSURLSessionTask *)updateBrandInfoParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 审核订单列表 - 待审核订单 默认值=1；已审核订单 默认值=2
+ (NSURLSessionTask *)getCheckOrderListWithType:(NSInteger)type page:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 更新审核订单状态
+ (NSURLSessionTask *)updateOrderChaeckStatusWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 商标管理列表
+ (NSURLSessionTask *)getBrandListWithWithPage:(NSInteger)page success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 新增商标
+ (NSURLSessionTask *)addBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 修改/变更商标
+ (NSURLSessionTask *)updateBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 撤回商标
+ (NSURLSessionTask *)withdrawBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 删除商标
+ (NSURLSessionTask *)deleteBrandWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-履历荣誉列表（新）agency/operation/staff/staffinfos/1?status=1  1.履历2.荣誉
+ (NSURLSessionTask *)getStaffinfosWithStaffId:(NSInteger)staffId status:(NSInteger)status success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-删除履历荣誉（新）
+ (NSURLSessionTask *)deleteStaffinfosWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-新增履历（新）
+ (NSURLSessionTask *)addStaffResumesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 运营-员工管理-修改履历（新）
+ (NSURLSessionTask *)editStaffResumesWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;






#pragma mark - lili-api

/// 广告-获取广告列表
+ (NSURLSessionTask *)getAdvertListWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 获取广告详情
+ (NSURLSessionTask *)getAdvertDetailWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;

/// 修改广告详情
+ (NSURLSessionTask *)updateAdvertDetailWithParams:(NSDictionary *)params success:(YMHttpRequestSuccess)success failure:(void(^)(NSString *erroMsg))failure;


@end






