//
//  NSArray+YMAdd.m
//  HJStoreB
//
//  Created by lym on 2018/6/20.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "NSArray+YMAdd.h"

@implementation NSArray (YMAdd)


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
