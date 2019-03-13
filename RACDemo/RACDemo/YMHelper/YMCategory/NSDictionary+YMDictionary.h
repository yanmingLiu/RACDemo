//
//  NSDictionary+YMDictionary.h
//  HJStoreB
//
//  Created by lym on 2018/5/28.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YMDictionary)

- (NSDictionary *)deleteAllNullValue;

- (NSString *)toJSONString;

@end

@interface NSMutableDictionary (YMDictionary)

- (NSMutableDictionary *)deleteAllNullValue;

@end
