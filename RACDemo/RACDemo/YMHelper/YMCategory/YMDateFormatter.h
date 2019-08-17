//
//  NSDate+YMDate.h
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMDateFormatter : NSObject<NSCacheDelegate>

@property (nonatomic, strong) NSCache * cache;

@property (nonatomic, assign) NSUInteger cacheLimit;//default is 5

+ (instancetype)shared;

- (NSDateFormatter *)formatter:(NSString *)format locale:(NSLocale *)locale;
- (NSDateFormatter *)formatter:(NSString *)format localeID:(NSString *)localeID;
- (NSDateFormatter *)formatter:(NSString *)format;

- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle locale:(NSLocale *)locale;
- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle localeID:(NSString *)localeID;
- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;



/*  NSDateFormatterStyle     dateStyle              timeStyle
 NSDateFormatterNoStyle     // 不产生任何效果
 NSDateFormatterShortStyle  // 2017/8/3           | // 下午2:51
 NSDateFormatterMediumStyle // 2017年8月3日        | 下午2:52:25
 NSDateFormatterLongStyle   // 2017年8月3日        | GMT+8 下午2:52:25
 NSDateFormatterFullStyle   // 2017年8月3日 星期四  | 中国标准时间 下午2:5
*/





@end

NS_ASSUME_NONNULL_END
