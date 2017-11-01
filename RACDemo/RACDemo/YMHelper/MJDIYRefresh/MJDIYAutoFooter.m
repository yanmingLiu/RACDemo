//
//  MJDIYAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYAutoFooter.h"
#import "Defines.h"


@interface MJDIYAutoFooter()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@property (weak, nonatomic) UIView *bottomView;
@end

@implementation MJDIYAutoFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
//    self.mj_h = 40;
    // 忽略掉底部inset
//    self.ignoredScrollViewContentInsetBottom = -MJRefreshFooterHeight;
//    self.automaticallyHidden = YES;
    
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
}


#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
//            self.label.text = @"上拉加载更多...";
//            [self.loading stopAnimating];
            break;
        case MJRefreshStateRefreshing:
//            self.label.text = @"加载数据中...";
//            [self.loading startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.stateLabel.text = @"没有更多内容~";
//            self.label.textColor = main_greenColor;
            self.stateLabel.textColor = [UIColor blueColor];
            
//            [self.loading stopAnimating];
            break;
        default:
            break;
    }
}

@end
