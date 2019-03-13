//
//  NSObject+YMAdd.m
//  HJStoreS
//
//  Created by lym on 2018/12/25.
//  Copyright © 2018 lym. All rights reserved.
//

#import "NSObject+YMAdd.h"

@implementation NSObject (YMAdd)

+ (NSArray *)ym_modelArrayWithJsons:(id)jsons {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in jsons) {
        id model = [[self class] yy_modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}


@end
