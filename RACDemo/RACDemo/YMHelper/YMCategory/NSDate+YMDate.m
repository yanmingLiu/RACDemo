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
+ (NSString *)dateTransformToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:YMDateFormtyMdHms];
    return [dateFormatter stringFromDate:date];
}

/**
 * 字符串转换为Date 自定义format
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

/**
 * 字符串转换为Date
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString {
    return [self dateStringTransformDate:dateString format:YMDateFormtyMdHms];
}


/**
 时间戳转化为字符串 自定义格式
 */
+ (NSString *)timestampTransformToString:(NSString *)timestamp format:(NSString *)format {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


/**
 时间戳转化为时间
 */
+ (NSDate *)timestampTransformToDate:(NSString *)timestamp format:(NSString *)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    return date;
}



// MARK: - Calculation --------------------------------------


/**
 *传入时间与当前时间的差值 - 返回秒
 */
+ (double)differenceSecondByEndDate:(NSDate *)endDate {
    return [self differenceSecondBetweenStartDate:[NSDate date] endDate:endDate];
}

/**
 *两个时间的差值 - 返回秒
 */
+ (double)differenceSecondBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    // 时间1
    NSDate *date1 = startDate;
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:date1];
    NSDate *localDate1 = [date1 dateByAddingTimeInterval:interval1];

    // 时间2
    NSDate *date2 = endDate;
    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];

    // 时间2与时间1之间的时间差（秒）
    double seconds = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    NSLog(@"时间1与时间2之间的时间差 = %f", seconds);
    return seconds;
}

+ (double)differenceSecondBetweenStartStr:(NSString *)startStr endStr:(NSString *)endStr {
    NSDate *date1 = [self dateStringTransformDate:startStr];
    NSDate *date2 = [self dateStringTransformDate:endStr];
    return [self differenceSecondBetweenStartDate:date1 endDate:date2];
}

/**
 * 开始到结束的时间差 @"%d天%d小时%d分%d秒"
 **/
+ (NSString *)differenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    return [self differenceStart:[self dateStringTransformDate:startTime] end:[self dateStringTransformDate:endTime]];
}

/**
 * 开始到结束的时间差 传入NSDate
 **/
+ (NSString *)differenceStart:(NSDate *)start end:(NSDate *)end {

    // 时间2与时间1之间的时间差（秒）
    long ms = [self differenceSecondBetweenStartDate:start endDate:end];

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
+ (int)compareStartDate:(NSString*)startDate endDate:(NSString*)endDate formatStyle:(NSInteger)formatStyle {
    if (formatStyle) {
        return [self compareDate1:startDate date2:endDate format:YMDateFormtyMdHms];
    }
    return [self compareDate1:startDate date2:endDate format:YMDateFormtyMd];
}

+ (int)compareDate1:(NSString *)date1 date2:(NSString *)date2 format:(NSString *)format {
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];

    NSDate *d1 = [[NSDate alloc] init];
    NSDate *d2 = [[NSDate alloc] init];
    d1 = [formatter dateFromString:date1];
    d2 = [formatter dateFromString:date2];
    NSComparisonResult result = [date1 compare:date2];
    /*
     NSOrderedAscending的意思是：左边的操作对象小于右边的对象。
     NSOrderedDescending的意思是：左边的操作对象大于右边的对象
     */
    switch (result)
    {
        //d1 < d2
        case NSOrderedAscending:
        comparisonResult = 1;
        NSLog(@"date1 = %@, < date2 = %@ , %d", date1, date2, comparisonResult);
        break;
        //d1 > d2
        case NSOrderedDescending:
        comparisonResult = -1;
        NSLog(@"date1 = %@, > date2 = %@ , %d", date1, date2, comparisonResult);
        break;
        //d1 = d2
        case NSOrderedSame:
        comparisonResult = 0;
        NSLog(@"date1 = %@, == date2 = %@ , %d", date1, date2, comparisonResult);
        break;
        default:
        break;
    }
    return comparisonResult;
}


/**
 *  计算指定时间与当前的时间差
 *
 *  @param compareDate 某一指定时间
 *
 *  @return 多少(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    int temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%d小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d年前",temp];
    }
    return  result;
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
    return [self dateTransformToString:[NSDate date]];
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
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

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
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";

    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];

    return [dateStr isEqualToString:nowStr];
}

@end
