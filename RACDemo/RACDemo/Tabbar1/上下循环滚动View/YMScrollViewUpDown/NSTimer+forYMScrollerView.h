//
//  NSTimer+forYMScrollerView.h
//  上下循环滚动View
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (forYMScrollerView)


// 暂停
- (void)pause;
// 重新开始
- (void)restart;
// 延迟一定时间启动
- (void)restartAfterTimeInterval:(NSTimeInterval)interval;


@end
