//
//  YMTabBarController.m
//  youkexueC
//
//  Created by 刘彦铭 on 2016/6/19.
//  Copyright © 2016年 liuyanming. All rights reserved.
//

#import "YMTabBarController.h"
#import "YMNavigationController.h"
#import "UIImage+YMImg.h"

@interface YMTabBarController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation YMTabBarController

+ (void)initialize
{
    if (self == [self class]) {
        // 设置tabBar选中颜色
        [[UITabBar appearance] setTintColor:[UIColor blueColor]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (YMNavigationController *)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage  {

    childVc.title = title;

    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:title
                                                       image:[UIImage imageNamed:image]
                                               selectedImage:[UIImage imageWithOriginalName:selectedImage]];
    childVc.tabBarItem = item;
    
    YMNavigationController *nav = [[YMNavigationController alloc] initWithRootViewController:childVc];
    
    return nav;
}




@end
