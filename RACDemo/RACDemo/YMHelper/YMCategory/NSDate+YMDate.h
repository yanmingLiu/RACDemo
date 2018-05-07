//
//  NSDate+YMDate.h
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import <Foundation/Foundation.h>

@interface NSDate (YMDate)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/**
 时间戳转化为时间
 */
+ (NSDate *)timestampTransformToDate:(NSString *)timestamp;

/**
 时间戳转化为字符串
 */
- (NSString *)timestampTransformToString:(NSString *)timestamp;

/**
 * 字符串转成时间戳
 **/
+ (int)dateStringTransformToTimestamp:(NSString *)dateString;

/**
 * 时间转成字符串
 **/
+ (NSString *)dateTransformToString:(NSDate *)date;

/**
 时间戳转化为字符串 自定义时间格式
 */
+ (NSString *)timestampTransformToString:(NSString *)timestamp format:(NSString *)format;

/**
 * 字符串转成iso时间
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString;


/**
 *传入时间与当前时间的差值 - 返回秒
 */
+ (double)differenceSecondByEndDate:(NSDate *)endDate;

/**
 *两个时间的差值 - 返回秒
 */
+ (double)differenceSecondBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 * 开始到结束的时间差 转换成 %i天%i小时%i分%i秒
 **/
+ (NSString *)differenceStart:(NSDate *)start end:(NSDate *)end;

/**
 * 字符串时间转成发布状态日期
 **/
+ (NSString *)toolPublishDateWithDateString:(NSString *)dateString;

/// 比较两个日期大小 formatStyle---> 1: @"yyyy-MM-dd HH:mm:ss"  0 : @"yyyy-MM-dd"
+ (int)compareStartDate:(NSString*)startDate endDate:(NSString*)endDate formatStyle:(NSInteger)formatStyle;

/**
 * 获取到日的时间 2017-09-23
 */
+ (NSString *)getDayWithString:(NSString *)str;

/**
 *获取到时分时间 15:03
 */
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



@end
