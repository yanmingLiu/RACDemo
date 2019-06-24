//
//  TabbarModel.m
//  HJStoreS
//
//  Created by lym on 2018/12/25.
//  Copyright © 2018 lym. All rights reserved.
//

#import "TabbarModel.h"
#import "NSObject+YMAdd.h"


@implementation TabbarModel

+ (NSArray *)tabbarItems {

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Tabbar" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//    NSLog(@"%@", json);

    return [TabbarModel ym_modelArrayWithJsons:json];
}




@end
