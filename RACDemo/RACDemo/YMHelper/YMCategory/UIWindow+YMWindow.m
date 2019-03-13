//
//  UIWindow+YMWindow.m
//  HJStoreB
//
//  Created by lym on 2018/5/25.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "UIWindow+YMWindow.h"

@implementation UIWindow (YMWindow)

+ (UIViewController*)ym_currentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

@end
