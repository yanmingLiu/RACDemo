//
//  NSDate+YMDate.m
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import "NSDate+YMDate.h"

@implementation NSDate (YMDate)

// MARK: - Transform --------------------------------------

/**
 * 时间转成字符串
 **/
+ (NSString *)ym_dateToString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter *fm = [[YMDateFormatter shared] formatter:format];
    return [fm stringFromDate:date];
}

+ (NSString *)ym_dateToString:(NSDate *)date {
    return [self ym_dateToString:date format:YMDateFormtyMdHms];
}

/**
 * 字符串转换为Date 自定义format
 **/
+ (NSDate *)ym_stringToDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *fm = [[YMDateFormatter shared] formatter:format];
    return [fm dateFromString:dateString];
}

+ (NSDate *)ym_dateStringToDate:(NSString *)dateString {
    return [self ym_stringToDate:dateString format:YMDateFormtyMdHms];
}


/**
 时间戳转化为时间
 */
+ (NSDate *)ym_timestampToDate:(NSString *)timestamp format:(NSString *)format {
    if (timestamp.length > 10) {
        timestamp = [timestamp substringToIndex:10];
    }
    NSDateFormatter* fm = [[YMDateFormatter shared] formatterWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    [fm setDateFormat:format];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return date;
}


/**
 时间戳转化为字符串 自定义格式
 */
+ (NSString *)ym_timestampToString:(NSString *)timestamp format:(NSString *)format {
    NSDate* date = [self ym_timestampToDate:timestamp format:format];
    return [self ym_dateToString:date];
}

/**
 时间 戳转化 时间戳
 */
+ (NSString *)ym_DateToTimestamp:(NSDate *)date format:(NSString *)format {
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

// MARK: - Calculation --------------------------------------


/**
 *两个时间的差值 - 返回秒
 */
+ (double)ym_differenceDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    // 时间1
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:date1];
    NSDate *localDate1 = [date1 dateByAddingTimeInterval:interval1];

    // 时间2
    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];

    // 时间2与时间1之间的时间差（秒）
    double seconds = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    NSLog(@"时间1与时间2之间的时间差 = %f", seconds);
    return seconds;
}

+ (double)ym_differenceDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2 {
    NSDate *date1 = [self ym_dateStringToDate:dateStr1];
    NSDate *date2 = [self ym_dateStringToDate:dateStr2];
    return [self ym_differenceDate1:date1 date2:date2];
}

/**
 * 开始到结束的时间差 @"%d天%d小时%d分%d秒"
 **/
+ (NSString *)ym_countDown:(NSString *)dateStr1 endTime:(NSString *)dateStr2;
{
    // 时间2与时间1之间的时间差（秒）
    long ms = [self ym_differenceDateStr1:dateStr1 dateStr2:dateStr2];

    if (ms <= 0) {
        return @"0天0时0分";
    }

    ms = ms * 1000;

    int day = (int) (ms / (1000 * 60 * 60 * 24));
    int house = (int) (ms % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
    int minute = (int) ((ms % (1000 * 60 * 60)) / (1000 * 60));
    int second = (int) ((ms % (1000 * 60)) / 1000);

    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%ld天%ld小时%ld分",(long)day,(long)house,(long)minute];
    }else if (day==0 && house !=0) {
        str = [NSString stringWithFormat:@"%ld小时%ld分",(long)house,(long)minute];
    }else if (day==0 && house==0 && minute!=0) {
        str = [NSString stringWithFormat:@"%ld分",(long)minute];
    }else{
        str = [NSString stringWithFormat:@"%ld秒",(long)second];
    }
    NSLog(@"%@", str);
    return str;
}




/// 比较两个日期大小
+ (NSComparisonResult)ym_compareDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2
{
    NSDate *date1 = [self ym_dateStringToDate:dateStr1];
    NSDate *date2 = [self ym_dateStringToDate:dateStr2];

    NSComparisonResult result = [date1 compare:date2];
    return result;
}


/**
 *   发布时间(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *)ym_pushTime:(NSString*) pushTime {

    if (!pushTime || !pushTime.length) {
        return @"";
    }

    NSDateFormatter *fmt = [[YMDateFormatter shared] formatter:@"yyyy-MM-dd HH:mm:ss"];
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:pushTime];
    // 当前时间
    NSDate *now = [NSDate date];

    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];

    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%d小时前", (int)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%d分钟前", (int)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

// MARK: - getter ----------------------------------

/**
 * 传入时间，返回明天的时间
 **/
+ (NSDate *)getTomorrowDay:(NSDate *)adate {
    NSDate *nextDay = [NSDate dateWithTimeInterval:24*60*60 sinceDate:adate];//后一天
    return nextDay;
}

/**
 * 传入时间，返回昨天天的时间
 **/
+ (NSDate *)getYesterdayDay:(NSDate *)adate {
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:adate];//前一天
    return lastDay;
}

/**
 * 获取当前时间字符串
 **/
+ (NSString *)currentDateString {
    return [self ym_dateToString:[NSDate date]];
}



// MARK: - BOOl --------------------------------------

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];

    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[YMDateFormatter shared] formatter:@"yyyy-MM-dd"];

    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];

    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];

    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[YMDateFormatter shared] formatter:@"yyyy-MM-dd"];

    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];

    return [dateStr isEqualToString:nowStr];
}

@end
