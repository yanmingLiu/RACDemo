//
//  UIViewController+YMAdd.h
//  HJStoreB
//
//  Created by lym on 2018/7/26.
//  Copyright © 2018年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YMAdd)

/// 指定返回到哪个控制器
- (void)backToController:(NSString *)className animated:(BOOL)animated;

@end
