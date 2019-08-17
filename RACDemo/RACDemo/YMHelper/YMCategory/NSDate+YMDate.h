//
//  NSDate+YMDate.h
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import <Foundation/Foundation.h>
#import "YMDateFormatter.h"

static NSString *YMDateFormtyMdHms = @"yyyy-MM-dd HH:mm:ss";
static NSString *YMDateFormtyMd = @"yyyy-MM-dd";


@interface NSDate (YMDate)


// MARK: - Transform --------------------------------------

/**
 * 时间转成字符串
 **/
+ (NSString *)ym_dateToString:(NSDate *)date format:(NSString *)format;

+ (NSString *)ym_dateToString:(NSDate *)date;

/**
 * 字符串转换为Date 自定义format
 **/
+ (NSDate *)ym_stringToDate:(NSString *)dateString format:(NSString *)format;

+ (NSDate *)ym_stringToDate:(NSString *)dateString;


/**
 时间戳转化为时间 自定义时间格式
 */
+ (NSDate *)ym_timestampToDate:(NSString *)timestamp format:(NSString *)format;

/**
 时间戳转化为字符串 自定义时间格式
 */
+ (NSString *)ym_timestampToString:(NSString *)timestamp format:(NSString *)format;

/**
 时间 戳转化 时间戳
 */
+ (NSString *)ym_dateToTimestamp:(NSDate *)date format:(NSString *)format;

// MARK: - Calculation --------------------------------------


/**
 *两个时间的差值 - 返回秒
 */
+ (double)ym_differenceDate1:(NSDate *)date1 date2:(NSDate *)date2;

/**
 *两个字符串时间的差值 - 返回秒
 */
+ (double)ym_differenceDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2;


/**
 * 开始到结束的时间差 @"%d天%d小时%d分%d秒"
 **/
+ (NSString *)ym_countDown:(NSString *)dateStr1 endTime:(NSString *)dateStr2;


/// 比较两个日期大小
+ (NSComparisonResult)ym_compareDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2;

/**
 *   发布时间(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *)ym_pushTime:(NSString*)pushTime ;

// MARK: - getter ----------------------------------


/**
 * 传入时间，返回明天的时间
 **/
+ (NSDate *)getTomorrowDay:(NSDate *)adate;

/**
 * 传入时间，返回昨天天的时间
 **/
+ (NSDate *)getYesterdayDay:(NSDate *)adate;

/**
 * 获取当前时间字符串
 **/
+ (NSString *)currentDateString;


// MARK: - BOOl --------------------------------------

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

@end
