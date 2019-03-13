//
//  UINavigationController+statusBar.m
//  HJStoreB
//
//  Created by lym on 2018/5/23.
//  Copyright © 2018年 lym. All rights reserved.
//

#import "UINavigationController+statusBar.h"

@implementation UINavigationController (statusBar)

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
