//
//  NSString+YMString.h
//  CategoryDemo
//
//  Created by liuyanming on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

#import <Foundation/Foundation.h>
// MD5加密
#import <CommonCrypto/CommonDigest.h>

@interface NSString (YMString)

/**
 给金钱添加千分符和.00
 @return 10,002.00
 */
+ (NSString *)positiveFormat:(NSString *)text;

/**
 调整数字最后两位数字的大小
 */
+ (NSString *)positiveFormatWithOutDot:(NSString *)text;
+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string withSize:(CGFloat) size number:(NSInteger)number;

/**
 // MD5加密
 */
+ (NSString*)md5String:(NSString*)str;

#pragma mark - 验证
/**
 * 验证6-16位密码,字母、数字、特殊符号两两组合
 **/
+ (BOOL)toolValidatePassword:(NSString *)password;

/**
 * 验证数字
 **/
+ (BOOL)toolValidateNumber:(NSString *)number;

/**
 * 验证邮箱
 **/
+ (BOOL)toolValidateEmail:(NSString *)email;

/**
 * 验证手机号
 **/
+ (BOOL)toolValidatePhone:(NSString *)phone;

/**
 * 验证身份证号
 **/
+ (BOOL)toolValidateIDCard:(NSString *)idCard;

/**
 通过手机号和验证码按算法生成签名 11位手机号 4位code
 */
+ (NSString *)securityCodeWithPhone:(NSString *)phone code:(NSString *)code;

/**
 验证电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


/**
 格式化手机号 131****1234
 */
+ (NSString *)formatPhoneNum:(NSString *)phoneNum;

#pragma mark - Date
/**
 * 获取时间
 **/
+(NSString *)getCurrentTime;

/**
 * iso时间转成字符串时间
 **/
+ (NSString *)toolDateFormatterWithISODateString:(NSString *)timeString;

/**
 * 字符串时间转成发布状态日期
 **/
+ (NSString *)toolPublishDateWithDateString:(NSString *)dateString;

/**
 * 字符串转成时间戳
 **/
+ (int)toolDateIntervalWithDateString:(NSString *)rfc3339DateTimeString;


/// 比较两个日期大小 formatStyle---> 1: @"yyyy-MM-dd HH:mm:ss"  0 : @"yyyy-MM-dd"
+ (int)compareStartDate:(NSString*)startDate endDate:(NSString*)endDate formatStyle:(NSInteger)formatStyle;

/// 开始到结束的时间差
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/// 获取到日的时间 2017-09-23
+ (NSString *)getDayWithString:(NSString *)str;

/// 获取到时分时间 15:03
+ (NSString *)getTimerWithString:(NSString *)str;

/**
 获取指定时间当月第一天和最后一天 
 
 @param dateStr 调用格式（yyyy-MM-dd）
 @return 第一天和最后一天数组
 */
+ (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr;


/**
 获取指定时间上月或者下月的日期
 
 @param dateStr 时间
 @param month 正数是以后n个月，负数是前n个月；
 */
+ (NSString *)getPriousorLaterDateFromDateStr:(NSString *)dateStr withMonth:(NSInteger)month;


/**
 * 判断2个时间是否在同一天内
 **/
+ (BOOL)isEqualDayWithStartDate:(NSString*)startDate endDate:(NSString*)endDate;
    

/**
 获得字符串的宽高
 */
- (CGSize) sizeWithFontSize:(UIFont *)font;

@end
