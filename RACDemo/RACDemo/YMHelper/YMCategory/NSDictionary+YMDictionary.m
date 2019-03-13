//
//  NSDictionary+YMDictionary.m
//  HJStoreB
//
//  Created by lym on 2018/5/28.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NSDictionary+YMDictionary.h"

@implementation NSDictionary (YMDictionary)

- (NSDictionary *)deleteAllNullValue {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

- (NSString *)toJSONString {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&parseError];

    if (parseError) {
        NSLog(@"参数错误");
        return @"";
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end

@implementation NSMutableDictionary (YMDictionary)

- (NSMutableDictionary *)deleteAllNullValue {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in self.allKeys) {
        if ([[self objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[self objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

@end
