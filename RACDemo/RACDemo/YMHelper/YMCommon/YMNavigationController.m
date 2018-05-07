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

@property (nonatomic, strong) id popDelegate;

@end

@implementation YMNavigationController

+ (void)initialize {
    [super initialize];
    // 处理向上偏移64
    //[[UINavigationBar appearance] setTranslucent:NO];
    //去掉导航条返回键带的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { 
        // 二级页面隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        // 自定义返回按钮
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithOriginalName:@"nav_return"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItem = leftItem;
        
        self.interactivePopGestureRecognizer.delegate = (id)self;
    }
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
