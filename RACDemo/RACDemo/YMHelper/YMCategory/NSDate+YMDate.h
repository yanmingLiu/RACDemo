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
 *  计算指定时间与当前的时间差
 *
 *  @param compareDate 某一指定时间
 *
 *  @return 多少(秒or分or天or月or年)+前(比如，3天前、10分钟前)
 */
+(NSString *)compareCurrentTime:(NSDate*) compareDate;


@end
