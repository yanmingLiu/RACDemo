//
//  UIViewController+YMAdd.m
//  HJStoreB
//
//  Created by lym on 2018/7/26.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "UIViewController+YMAdd.h"

@implementation UIViewController (YMAdd)

/// 指定返回到哪个控制器
- (void)backToController:(NSString *)className animated:(BOOL)animated {
    NSArray *controllers = self.navigationController.viewControllers;
    NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:NSClassFromString(className)];
    }]];

    if (result > 0) {
        [self.navigationController popToViewController:[result firstObject] animated:animated];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
