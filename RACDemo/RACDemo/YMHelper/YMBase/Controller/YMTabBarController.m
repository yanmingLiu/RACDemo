//
//  YMTabBarController.m
//  youkexueC
//
//  Created by 刘彦铭 on 2017/6/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMTabBarController.h"
#import "TabbarModel.h"

@interface YMTabBarController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation YMTabBarController

+ (void)initialize
{
    if (self == [self class]) {
        // 设置tabBar选中颜色
        [[UITabBar appearance] setTintColor:[UIColor orangeColor]];

        [[UITabBar appearance] setTranslucent:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupChildViewController:[TabbarModel tabbarItems]];

//    [self addNotification];
}


- (void)setupChildViewController:(NSArray *)models {

    for (TabbarModel *model in models) {

        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:model.title
                                                           image:[UIImage imageNamed:model.image]
                                                   selectedImage:[UIImage imageNamed:model.selectedImage]];

        Class cls = NSClassFromString(model.viewController);
        UIViewController *vc = [[cls alloc] init];
        vc.tabBarItem = item;
        vc.title = model.title;
        YMNavigationController *nav = [[YMNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    }
}

/*
- (void)addNotification {
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLoginSuccessNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_main_async_safe(^{
            @strongify(self);
            [self refreshMessageCount];
        });
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kMessageRefreshNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_main_async_safe(^{
            @strongify(self);
            [self refreshMessageCount];
        });
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kRefreshItemCountNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_main_async_safe(^{
            @strongify(self);
            [self refreshMessageCount];
        });
    }];
}

- (void)refreshMessageCount {
    NSInteger unreadCount = 5;
    
    // 消息数
    UITabBarItem *msgItem = [self.tabBar.items objectAtIndex:1];
    if (unreadCount > 0)
    {
        msgItem.badgeValue = [@(unreadCount) stringValue];
    }
    else
    {
        msgItem.badgeValue = nil;
    }
}
*/



@end

