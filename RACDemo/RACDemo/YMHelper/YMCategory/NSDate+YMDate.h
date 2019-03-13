//
//  NSDate+YMDate.h
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import <Foundation/Foundation.h>

static NSString *YMDateFormtyMdHms = @"yyyy-MM-dd HH:mm:ss";
static NSString *YMDateFormtyMd = @"yyyy-MM-dd";


@interface NSDate (YMDate)


// MARK: - Transform --------------------------------------

/**
 * 时间转成字符串
 **/
+ (NSString *)dateTransformToString:(NSDate *)date;

/**
 * 字符串转换为Date 自定义format
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString format:(NSString *)format;


/**
 * 字符串转换为Date @"yyyy-MM-dd HH:mm:ss"
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString;


/**
 时间戳转化为字符串 自定义时间格式
 */
+ (NSString *)timestampTransformToString:(NSString *)timestamp format:(NSString *)format;


/**
 时间戳转化为时间 自定义时间格式
 */
+ (NSDate *)timestampTransformToDate:(NSString *)timestamp format:(NSString *)format;


// MARK: - Calculation --------------------------------------


/**
 *传入时间与当前时间的差值 - 返回秒
 */
+ (double)differenceSecondByEndDate:(NSDate *)endDate;

/**
 *两个时间的差值 - 返回秒
 */
+ (double)differenceSecondBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

/**
 *两个字符串时间的差值 - 返回秒
 */
+ (double)differenceSecondBetweenStartStr:(NSString *)startStr endStr:(NSString *)endStr;


/**
 * 开始到结束的时间差 @"%d天%d小时%d分%d秒"
 **/
+ (NSString *)differenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

/**
 * 开始到结束的时间差 @"%d天%d小时%d分%d秒"
 **/
+ (NSString *)differenceStart:(NSDate *)start end:(NSDate *)end;


/// 比较两个日期大小 formatStyle---> 1: @"yyyy-MM-dd HH:mm:ss"  0 : @"yyyy-MM-dd"
+ (int)compareStartDate:(NSString*)startDate endDate:(NSString*)endDate formatStyle:(NSInteger)formatStyle;
+ (int)compareDate1:(NSString *)date1 date2:(NSString *)date2 format:(NSString *)format;

/**
 *  计算指定时间与当前的时间差
 *
 *  @param compareDate 某一指定时间
 *
 *  @return 多少(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSDate*) compareDate;

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
