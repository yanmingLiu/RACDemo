//
//  NSDate+YMDate.m
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import "NSDate+YMDate.h"

@implementation NSDate (YMDate)

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


/**
 时间戳转化为时间
 */
+ (NSDate *)timestampTransformToDate:(NSString *)timestamp {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    return date;
}

/**
 时间戳转化为字符串
 */
- (NSString *)timestampTransformToString:(NSString *)timestamp {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 * 字符串转成时间戳
 **/
+ (int)dateStringTransformToTimestamp:(NSString *)dateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *date =[dateFormatter dateFromString:dateString];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *current = [NSDate date];
    int interval = [current timeIntervalSinceDate:date];
    if (interval < 0) interval = 0;
    return interval;
}

/**
 * 时间转成字符串时间
 **/
+ (NSString *)dateTransformToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
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
 * 字符串转换为Date
 **/
+ (NSDate *)dateStringTransformDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

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
    double seconds = fabs([localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate]);

    return seconds;
}


/**
 * 开始到结束的时间差 返回0天0时0分
 **/
+ (NSString *)differenceStart:(NSDate *)start end:(NSDate *)end {
    
    // 时间1
    NSDate *date1 = start;
    NSTimeZone *zone1 = [NSTimeZone systemTimeZone];
    NSInteger interval1 = [zone1 secondsFromGMTForDate:date1];
    NSDate *localDate1 = [date1 dateByAddingTimeInterval:interval1];
    
    // 时间2
    NSDate *date2 = end;
    NSTimeZone *zone2 = [NSTimeZone systemTimeZone];
    NSInteger interval2 = [zone2 secondsFromGMTForDate:date2];
    NSDate *localDate2 = [date2 dateByAddingTimeInterval:interval2];
    
    // 时间2与时间1之间的时间差（秒）
    long ms = [localDate2 timeIntervalSinceReferenceDate] - [localDate1 timeIntervalSinceReferenceDate];
    
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
    
    return str;
}

/**
 * 字符串时间转成发布状态日期
 **/
+ (NSString *)toolPublishDateWithDateString:(NSString *)dateString{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将需要转换的时间转换成 NSDate 对象
    NSDate * compareDate = [dateFormatter dateFromString:dateString];
    
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
    return result;
}

/// 比较两个日期大小
+ (int)compareStartDate:(NSString*)startDate endDate:(NSString*)endDate formatStyle:(NSInteger)formatStyle {
    
    int comparisonResult;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (formatStyle) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    NSLog(@"result==%ld",(long)result);
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            comparisonResult = 1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            comparisonResult = -1;
            break;
            //date02=date01
        case NSOrderedSame:
            comparisonResult = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", date1, date2);
            break;
    }
    return comparisonResult;
}

/// 获取到日的时间 2017-09-23
+ (NSString *)getDayWithString:(NSString *)str {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd";
    NSString *newString = [format stringFromDate:date];
    
    return newString;
}

/// 获取到时分时间 15:03
+ (NSString *)getTimerWithString:(NSString *)str {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    NSString *newString = [format stringFromDate:date];
    
    return newString;
}


/**
 获取指定时间当月第一天和最后一天 
 @param dateStr 调用格式（yyyy-MM-dd）
 @return 第一天和最后一天数组
 */
+ (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];    
    [format setDateFormat:@"yyyy-MM-dd"];    
    NSDate *newDate=[format dateFromString:dateStr];    
    double interval = 0;    
    NSDate *beginDate = nil;    
    NSDate *endDate = nil;    
    NSCalendar *calendar = [NSCalendar currentCalendar];    
    
    [calendar setFirstWeekday:2];//设定周一为周首日    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];    
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit    
    if (ok) {    
        endDate = [beginDate dateByAddingTimeInterval:interval-1];  
    }else {    
        return @[@"",@""];    
    }    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];    
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];    
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];    
    NSString *endString = [myDateFormatter stringFromDate:endDate];    
    
    return @[beginString,endString]; 
}


/**
 获取指定时间上月或者下月的日期
 @param dateStr 时间
 @param month 正数是以后n个月，负数是前n个月；
 */
+ (NSString *)getPriousorLaterDateFromDateStr:(NSString *)dateStr withMonth:(NSInteger)month {
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate *newDate=[format dateFromString:dateStr];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:newDate options:0];
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate: mDate];
    
    return firstString;
}

/**
 * 判断2个时间是否在同一天内
 **/
+ (BOOL)isEqualDayWithStartDate:(NSString*)startDate endDate:(NSString*)endDate
{
    BOOL isEqualDay = YES;
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startDate];
    NSDate *endD = [date dateFromString:endDate];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        isEqualDay = NO;
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    NSLog(@"%@",str);
    
    return isEqualDay;
}


@end
