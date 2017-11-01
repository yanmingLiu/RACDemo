//
//  NSDictionary+YMLog.m
//  text
//
//  Created by 刘彦铭 on 2017/5/15.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "NSDictionary+YMLog.h"

@implementation NSDictionary (YMLog)

#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale{
    
    NSString *logString;
    
    @try {
        
        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
}
#endif

@end
