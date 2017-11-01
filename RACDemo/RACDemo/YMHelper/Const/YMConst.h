//
//  YMConst.h
//  youkexueC
//
//  Created by 刘彦铭 on 2017/6/20.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kServer_msg  @"msg"
#define kServer_ret  @"ret"
#define kServer_data  @"data"

#define kSuccess_code  200

#define kServer_code_200   200
#define kServer_code_4001  4001 //权限发生改变
#define kServer_code_401   401 //被其它人员登录挤出去

#define kCode_401_msg       @"登录失效，请重新登录" 
#define kNetworkerro_msg    @"网络异常,连接服务器失败！" 

#define kGetCodeSuccessMsg  @"验证码发送成功，请查收"
#define kGetCodeErroMsg     @"验证码发送失败，请重新获取"
#define kGetCodeInputErro   @"请输入正确的验证码"

#define kCourseMaxCateTip   @"每个教育品牌默认最大经营5个一级类目，超过最大数量需要申请！"
#define kNoInputText        @"未填写"
#define kYesInputText       @"已填写"


#define SB_Mine             @"Mine"
#define SB_ID_Mine          @"YMMineController"
#define SB_Login            @"Login"
#define SB_ID_Login         @"YMLoginController"
#define SB_Operation        @"Operation"
#define SB_ID_Operation     @"YMOperationController"
#define SB_Home             @"Home"
#define SB_ID_Home          @"YMHomeController"
#define SB_UB               @"UB"
#define SB_WebSet           @"WebSet"


#define main_greenColor     RGB(8, 179, 129)
#define main_lightColor     RGB(238,238,238)
#define main_blackColor     RGB(51,51,51)
#define main_redColor       RGB(245, 88, 33)
#define main_grayColor      RGB(153, 153, 153)
#define mian_blueColor      RGB(96, 145, 255)

#define kCerButtonTitle_no       @"未登记"
#define kCerButtonTitle_ing      @"审核中"
#define kCerButtonTitle_yes      @"已登记"
#define kCerButtonTitle_decline  @"已拒绝"
#define kCerButtonTitle_return   @"已撤回"

// 相机图片
#define ImageCamera  [UIImage imageNamed:@"fillin-camera"]
#define kLogoImage  [UIImage imageNamed:@"logo"]
#define kIconImage  [UIImage imageNamed:@"personCenter_icon"]

// 选中 未选择
#define kChooseDefaultImage   [UIImage imageNamed:@"choice_defualt"]
#define kChooseSelectedImage  [UIImage imageNamed:@"choice_seleted"]


// 认证相关图片名称
#define kRightCerBgImageName    @"right_bg"
#define kErrorCerBgImageName    @"wrong_bg"
#define kWaitCerBgImageName     @"wait_bg"

#define kRightCerWhiteImageName   @"right_icon_w"
#define kErrorCerWhiteImageName   @"wrong_icon_w"
#define kWaitCerWhiteImageName    @"wait_icon_w"

#define kRightCerImageName      @"right_icon"
#define kErrorCerImageName      @"wrong_icon"
#define kWaitCerImageName       @"wait_icon"

// 输入框文字限制
#define kTextNum430             @"4-30个汉字或英文字母、数字"
#define kTextNum210             @"2-10个汉字或英文字母、数字"

// 选择相关的图片名称
#define kChooseDefualtImage  [UIImage imageNamed:@"choice_defualt"]
#define kChooseSelectedImage [UIImage imageNamed:@"choice_seleted"]



@interface YMConst : NSObject

// 通知

// 登录成功
extern NSString * const kLoginSuccessNotification;

// 修改个人资料成功通知
extern NSString * const kUpdateUserInfoSuccessNotification;

// 添加员工成功通知
extern NSString * const kaddStaffSuccessNotification;

// 添加角色成功通知
extern NSString * const kaddRoleSuccessNotification;

// 保存品牌信息成功
extern NSString * const kSaveBrandInfoSuccessNotification;

// 添加校区成功
extern NSString * const kAddSchoolSucessNotification;

// 选择班课分类后
extern NSString * const kChoosedClassCateSuccessNotification;

// 添加班课成功
extern NSString * const kAddClassSuccessNotification;

// 切换品牌成功
extern NSString * const kSwitchBrandSuccessNotification;

// 经营类目操作：添加、删除成功通知
extern NSString * const kCategotyHandleNotification;

// 登录后，如果没有品牌 提示用户
extern NSString * const kLoginedAndNotBrandTipsNotification;

// 添加类目成功
extern NSString * const kAddcategorySuccessNotification;

// 团队介绍--内容添加
extern NSString * const kAddTeamInfoSuccessNotification;

// 添加教室陈宫
extern NSString * const kAddClassroomSuccessNotification;

// 添加课次成功
extern NSString * const kAddScheduleSuccessNotification;

// 创建机构成功-跳转工作台按钮
extern NSString * const kCreatedAngecySuccessNotification;

// 设置热门班课
extern NSString * const setHotClassSuccessNotification;

// 添加相册成功
extern NSString * const addAlbumSuccessNotification;

// 添加图片成功
extern NSString * const addPhotoSuccessNotification;

// 添加明星学员成功
extern NSString * const addStartStudentSuccessNotification;

// 选择地区
extern NSString * const kChooseCityNotification;

// 商标操作通知
extern NSString * const kBrandHandelSuccessNotification;

// 购买定制功能后通知 - 跳转到我的购买记录
extern NSString * const kPayModuleSuccessNotification;


@end
