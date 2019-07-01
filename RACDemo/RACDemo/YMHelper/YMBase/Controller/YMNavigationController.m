//
//  YMNavigationController.m
//  YMNavigation
//
//  Created by 刘彦铭 on 2016/6/19.
//  Copyright © 2016年 liuyanming. All rights reserved.
//

#import "YMNavigationController.h"
#import "UIImage+YMImg.h"

@interface YMNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>


@end

@implementation YMNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *bar = [UINavigationBar appearance];

    bar.translucent = NO;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];

    bar.titleTextAttributes = dic;
    bar.barTintColor = [UIColor orangeColor];

    [bar setBackgroundImage:[UIImage new] forBarMetrics:(UIBarMetricsDefault)];
    [bar setShadowImage:[UIImage new]];

    NSDictionary *barButtonAppearanceDict = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        // 二级页面隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮
        UIImage *img = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = leftItem;

        self.interactivePopGestureRecognizer.delegate = (id)self;
    }
    NSLog(@"当前控制器 == %@", NSStringFromClass(viewController.class));
    [super pushViewController:viewController animated:animated];
}

///处理右滑返回手势自定义失效 -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

#pragma mark UINavigationControllerDelegate

- (void)back {
    [self popViewControllerAnimated:YES];
}



@end
