//
//  YMClearCacheTool.h
//  Industrialbuilder
//
//  Created by lym on 2019/6/26.
//  Copyright © 2019 braspringc. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface YMClearCacheTool : NSObject

/**
 获取缓存大小

 @return M = result/1024/1024
 */
+ (CGFloat)getCacheSize;

/**
 清除缓存

 @param callback 回调
 */
+ (void)cleanCacheFinish:(void(^)(void))callback;

@end

NS_ASSUME_NONNULL_END
