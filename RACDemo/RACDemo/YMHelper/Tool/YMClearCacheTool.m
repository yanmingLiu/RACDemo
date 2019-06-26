//
//  YMClearCacheTool.m
//  Industrialbuilder
//
//  Created by lym on 2019/6/26.
//  Copyright © 2019 braspringc. All rights reserved.
//

#import "YMClearCacheTool.h"

@implementation YMClearCacheTool

/**
 获取缓存大小

 @return M = result/1024/1024
 */
+ (CGFloat)getCacheSize {
    //得到缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    //首先判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        for (NSString * fileName in childFile) {
            //缓存文件绝对路径
            NSString * absolutPath = [path stringByAppendingPathComponent:fileName];
            size = size + [manager attributesOfItemAtPath:absolutPath error:nil].fileSize;
        }
    }
    NSLog(@"path = %@", path);
    NSLog(@"pathSize----%.2f",size);

//    CGFloat imgSize = (CGFloat)[SDImageCache sharedImageCache].totalDiskSize;

    CGFloat imgSize = 0;
    NSLog(@"imgSize----%.2f", imgSize);

    return size + imgSize;
}

/**
 清除缓存

 @param callback 回调
 */

+ (void)cleanCacheFinish:(void(^)(void))callback {
    //获取缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    //判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        //逐个删除缓存文件
        for (NSString *fileName in childFile) {
            NSString * absolutPat = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutPat error:nil];
        }
    }

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        if (callback) {
            callback();
        }
    }];
}


@end
