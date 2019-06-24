//
//  AppDelegate.m
//  RACDemo
//
//  Created by 刘彦铭 on 2017/5/11.
//  Copyright © 2017年 刘彦铭. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application 
    
    [self registerAPN];

//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//
//    self.window.rootViewController = [self setupTabbar];
//
//    [self.window makeKeyAndVisible];
    return YES;
}


- (UITabBarController *)setupTabbar {

    UITabBarController *tabbar = [[UITabBarController alloc] init];

    NSArray *vcs = @[@"TableViewControllerTabbar0",@"TableViewControllerTabbar1"];

    for (int i = 0; i < vcs.count; i++) {

        NSString *str = [NSString stringWithFormat:@"%d", i];
        UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:str image:nil tag:i];

        Class cls = NSClassFromString(vcs[i]);
        UIViewController *vc = [[cls alloc] init];
        vc.tabBarItem = item;
        vc.title = str;

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [tabbar addChildViewController:nav];
    }
    return tabbar;
}


- (void)registerAPN {
    
    if (@available(iOS 10.0, *)){
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
                // 推送token到服务器
                
            }else {
                NSLog(@"%@", error.description);
            }
        }];
    }
    else {
        //iOS 10 before
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
}

//iOS 10 before
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    NSLog(@"%@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
    NSLog(@"%@", error.description);
}




@end
