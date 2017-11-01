//
//  NSString+YMString.m
//  CategoryDemo
//
//  Created by liuyanming on 17/2/28.
//  Copyright © 2017年 yons. All rights reserved.
//

#import "NSString+YMString.h"
#import "sys/sysctl.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YMString)

+ (NSString *)positiveFormat:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }
    if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###.00;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}


+ (NSString *)positiveFormatWithOutDot:(NSString *)text{
    if(!text || [text floatValue] == 0){
        return @"0";
    }
    if ( text.floatValue > -1000 && text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.f",text.floatValue];
    };
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@",###;"];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
}

/**
 调整数字最后两位数字的大小
 
 @param string 要修改的字符串
 @param size   修改字体大小
 */
+ (NSMutableAttributedString *)addFontAttribute:(NSString*)string withSize:(CGFloat) size number:(NSInteger)number{
    
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc]initWithString:string];
    [aString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size]range:NSMakeRange(string.length-number,number)];
    return aString;
}

/**
 * MD5
 **/
+ (NSString*)md5String:(NSString*)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - 验证
/**
 * 验证6-16位密码,字母、数字、特殊符号(@_#&)两两组合
 **/
+ (BOOL)toolValidatePassword:(NSString *)password
{
    NSString *passWordRegex = @"^((?=.*\\d)(?=.*[a-zA-Z])|(?=.*\\d)(?=.*[_@#!])|(?=.*[_@#!])(?=.*[a-zA-Z]))[\\da-zA-Z_@#!]{6,16}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:password];
}

/**
 * 验证数字
 **/
+ (BOOL)toolValidateNumber:(NSString *)number
{
    NSString *passWordRegex = @"^[0-9]*$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:number];
}

/**
 * 验证邮箱
 **/
+ (BOOL)toolValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 * 验证手机号
 **/
+ (BOOL)toolValidatePhone:(NSString *)phone
{
    
    NSString * tel = @"^[1][3-8]\\d{9}$";
    NSPredicate *phonepredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    return [phonepredicate evaluateWithObject:phone];
}

/**
 * 验证身份证号
 **/
+ (BOOL)toolValidateIDCard:(NSString *)idCard
{
    NSString * reg = @"^(\\d{6})(18|19|20)?(\\d{2})([01]\\d)([0123]\\d)(\\d{3})(\\d|X|x)?$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [predicate evaluateWithObject:idCard];
}

/**
 格式化手机号 131****1234
 */
+ (NSString *)formatPhoneNum:(NSString *)phoneNum {
    if (phoneNum.length != 11) {
        return @"";
    }
    NSString *numberString = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberString;
}


+ (NSString *)securityCodeWithPhone:(NSString *)phone code:(NSString *)code {
    
    if (phone.length != 11 && code.length != 4) {
        return @"";
    }
    
    NSString *temp = nil;
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    NSMutableArray *arr3 = [NSMutableArray array];
    NSMutableArray *arr4 = [NSMutableArray array];
    
    for(int i =0; i < [phone length]; i++)
    {
        temp = [phone substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"第%d个字是:%@",i,temp);
        if (i<3) {
            [arr1 addObject:temp];
        }
        else if (i>=3 && i<6) {
            [arr2 addObject:temp];
        }else if (i>=6 && i<9)  {
            [arr3 addObject:temp];
        }else {
            [arr4 addObject:temp];
        }
    }
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    // 倒叙数组
    arr1 = (NSMutableArray *)[[arr1 reverseObjectEnumerator] allObjects];
    arr2 = (NSMutableArray *)[[arr2 reverseObjectEnumerator] allObjects];
    arr3 = (NSMutableArray *)[[arr3 reverseObjectEnumerator] allObjects];
    arr4 = (NSMutableArray *)[[arr4 reverseObjectEnumerator] allObjects];
    
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    NSString *tempCode = @"";
    for(int i = 0; i < [code length]; i++)
    {
        tempCode = [code substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"第%d个字是:%@",i,tempCode);
        if (i == 0) {
            [arr1 addObject:tempCode];
        }
        else if (i == 1) {
            [arr2 addObject:tempCode];
        }else if (i == 2)  {
            [arr3 addObject:tempCode];
        }else {
            [arr4 addObject:tempCode];
        }
    }
    //NSLog(@"%@--%@--%@--%@", arr1,arr2,arr3,arr4);
    
    // 数组转字符串
    NSString *str1 = [arr1 componentsJoinedByString:@""];
    NSString *str2 = [arr2 componentsJoinedByString:@""];
    NSString *str3 = [arr3 componentsJoinedByString:@""];
    NSString *str4 = [arr4 componentsJoinedByString:@""];
    
    NSString *str5 = [[[str1 stringByAppendingString:str2] stringByAppendingString:str3] stringByAppendingString:str4];
    
    NSString *str6 = [@"1" stringByAppendingString:str5];
    
    //NSLog(@"%@", resultStr);
    
    // 计算
    NSInteger one = [str6 integerValue];
    NSInteger two = pow([code integerValue], 2); // code平方
    NSInteger three = one - two;
    
    //NSLog(@"%ld", three);
    NSString *resultStr = [NSString stringWithFormat:@"%ld", three];
    //NSLog(@"%@", resultStr);
    
    return resultStr;
}


/**
 验证电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /*
    固定电话+手机号码正则表达式
    区号+座机号码+分机号码：regexp="^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$"
    
    手机(中国移动手机号码)：regexp="^((/(/d{3}/))|(/d{3}/-))?13[456789]/d{8}|15[89]/d{8}"
    
    所有手机号码：regexp="^((/(/d{3}/))|(/d{3}/-))?13[0-9]/d{8}|15[89]/d{8}"(新添加了158,159两个号段)
     
    ((/d{11})|^((/d{7,8})|(/d{4}|/d{3})-(/d{7,8})|(/d{4}|/d{3})-(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1})|(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1}))$)
    
     */
    
    NSString * tel = @"^(0?(13[0-9]|15[012356789]|17[013678]|18[0-9]|14[57])[0-9]{8})|(400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?$";
//    NSString * tel = @"((/d{11})|^((/d{7,8})|(/d{4}|/d{3})-(/d{7,8})|(/d{4}|/d{3})-(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1})|(/d{7,8})-(/d{4}|/d{3}|/d{2}|/d{1}))$)";
    NSPredicate *phonepredicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    return [phonepredicate evaluateWithObject:mobileNum];
}

#pragma mark - data
//获取当地时间
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
    
/**
 * iso时间转成字符串时间
 **/
+ (NSString *)toolDateFormatterWithISODateString:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *date = [dateFormatter dateFromString:timeString];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY.MM.dd"];
    NSString *iso8601String = [format stringFromDate:date];
    return iso8601String;
}

/**
 * 字符串时间转成发布状态日期
 **/
+ (NSString *)toolPublishDateWithDateString:(NSString *)dateString{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * nowDate = [NSDate date];
    //将需要转换的时间转换成 NSDate 对象
    NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
    //取当前时间和转换时间两个日期对象的时间间隔
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    //把间隔的秒数折算成天数和小时数：
    NSString *dateStr = @"";
    
    if (time <= 60) {  //1分钟以内的
        dateStr = @"刚刚";
    }else if(time <= 60*60){  //一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
    }
    else if(time <= 60*60*24){   //在两天内的
        [dateFormatter setDateFormat:@"YYYY.MM.dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //在同一天
            //            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            int hour = time/60/60;
            dateStr = [NSString stringWithFormat:@"%d小时前",hour];
            
        }else{
            ////  昨天
            //            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            dateStr = [NSString stringWithFormat:@"昨天"];
        }
    }
    else {
        
        [dateFormatter setDateFormat:@"YYYY"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            //在同一年
            [dateFormatter setDateFormat:@"YYYY.MM.dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
        else{
            dateStr = [NSString stringWithFormat:@"%@", @"很久以前"];
            
        }
    }
    
    return dateStr;
}

/**
 * 字符串转成时间戳
 **/
+ (int)toolDateIntervalWithDateString:(NSString *)rfc3339DateTimeString{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *date =[dateFormatter dateFromString:rfc3339DateTimeString];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *current = [NSDate date];
    int interval = [current timeIntervalSinceDate:date];
    if (interval < 0) interval = 0;
    return interval;
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

/// 开始到结束的时间差
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
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
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return str;
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
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
    
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    }else {
        return @[@"",@""];
    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *firstString = [myDateFormatter stringFromDate: firstDate];
    NSString *lastString = [myDateFormatter stringFromDate: lastDate];
    return @[firstString, lastString];
}


/**
 获取指定时间上月或者下月的日期
 
 @param dateStr 时间
 @param month 正数是以后n个月，负数是前n个月；
 */
+ (NSString *)getPriousorLaterDateFromDateStr:(NSString *)dateStr withMonth:(int)month {
    
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






@end
