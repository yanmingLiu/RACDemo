//
//  NSDate+YMDate.h
//  RACDemo
//
//  Created by lym on 2017/1/28.
//

#import "YMDateFormatter.h"

@interface YMDateFormatter ()


@end

@implementation YMDateFormatter


static id _instance;

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (id)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
        _cache.countLimit = 5;
        _cache.delegate = self;

        [[NSNotificationCenter defaultCenter] addObserver:_cache selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_cache selector:@selector(removeAllObjects) name:NSCurrentLocaleDidChangeNotification  object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark NSCacheDelegate 
-(void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"cache removed : %@",obj);
}

#pragma setter

- (void)setCacheLimit:(NSUInteger)cacheLimit {
    @synchronized(self) {
        _cache.countLimit = cacheLimit;
    }
}

- (NSUInteger)cacheLimit {
    @synchronized(self) {
        return _cache.countLimit;
    }
}


#pragma mark -

- (NSDateFormatter *)formatter:(NSString *)format locale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"%@|%@", format, locale.localeIdentifier];

        NSDateFormatter *dateFormatter = [_cache objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = format;
            dateFormatter.locale = locale;
            dateFormatter.timeZone = [NSTimeZone systemTimeZone];
            [_cache setObject:dateFormatter forKey:key];
        }

        return dateFormatter;
    }
}

- (NSDateFormatter *)formatter:(NSString *)format localeID:(NSString *)localeID {
    return [self formatter:format locale:[[NSLocale alloc] initWithLocaleIdentifier:localeID]];
}

- (NSDateFormatter *)formatter:(NSString *)format {
    return [self formatter:format locale:[NSLocale currentLocale]];
}

- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle locale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"d%lu|t%lu%@", (unsigned long)dateStyle, (unsigned long)timeStyle, locale.localeIdentifier];

        NSDateFormatter *dateFormatter = [_cache objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = dateStyle;
            dateFormatter.timeStyle = timeStyle;
            dateFormatter.locale = locale;
            dateFormatter.timeZone = [NSTimeZone systemTimeZone];
            [_cache setObject:dateFormatter forKey:key];
        }

        return dateFormatter;
    }
}

- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle localeID:(NSString *)localeID {

    return [self formatterWithDateStyle:dateStyle timeStyle:timeStyle locale:[[NSLocale alloc] initWithLocaleIdentifier:localeID]];
}

- (NSDateFormatter *)formatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {

     return [self formatterWithDateStyle:dateStyle timeStyle:timeStyle locale:[NSLocale currentLocale]];
}



@end
