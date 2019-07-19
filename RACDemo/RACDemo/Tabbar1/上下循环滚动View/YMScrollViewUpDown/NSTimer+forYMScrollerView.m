//
//  NSTimer+forYMScrollerView.m
//  上下循环滚动View
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSTimer+forYMScrollerView.h"

@implementation NSTimer (forYMScrollerView)


- (void)pause{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)restart{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

- (void)restartAfterTimeInterval:(NSTimeInterval)interval{
    
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}


@end
