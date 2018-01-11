//
//  MJDIYBackFooter.m
//  youkexueC
//
//  Created by 刘彦铭 on 2017/6/24.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "MJDIYBackFooter.h"

@implementation MJDIYBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    

    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
            break;
        case MJRefreshStateRefreshing:
            break;
        case MJRefreshStateNoMoreData:
            self.stateLabel.text = @"没有更多内容~";
            self.stateLabel.textColor = [UIColor blueColor];
            
            // 忽略掉底部inset
//            self.ignoredScrollViewContentInsetBottom = -MJRefreshFooterHeight;
            
            break;
        default:
            break;
    }
}

@end
