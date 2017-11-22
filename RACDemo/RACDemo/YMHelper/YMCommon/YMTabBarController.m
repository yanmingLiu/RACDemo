//
//  YMTabBarController.m
//  youkexueC
//
//  Created by 刘彦铭 on 2017/6/19.
//  Copyright © 2017年 liuyanming. All rights reserved.
//

#import "YMTabBarController.h"
#import "YMNavigationController.h"
//#import "YMMineController.h"
//#import "YMOperationController.h"
//#import "YMWorkbenchViewController.h"
//#import "YMCustomCenterController.h"

@interface YMTabBarController ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation YMTabBarController

singleton_implementation(YMTabBarController)
//
//+ (void)initialize
//{
//    if (self == [self class]) {
//        // 设置tabBar选中颜色
//        [[UITabBar appearance] setTintColor:main_greenColor];
//    }
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    
////    YMHomeController *home = ViewControllerFromSB(SB_Home, SB_ID_Home);
//    YMWorkbenchViewController *home = ViewControllerFromSB(@"Workbench", @"YMWorkbenchViewController");
//    YMNavigationController *homeNav = [self addChildVc:home title:@"首页" image:@"tab_1_default" selectedImage:@"tab_1_hover"];
//    
////    YMBaseController *brand = [[YMBaseController alloc] init];
////    [self addChildVc:brand title:@"教育品牌" image:@"tab_2_default" selectedImage:@"tab_2_hover" index:1];
//    
//    YMOperationController *contact = ViewControllerFromSB(SB_Operation, SB_ID_Operation);
//    YMNavigationController *contactNav = [self addChildVc:contact title:@"教学运营" image:@"tab_3_default" selectedImage:@"tab_3_hover"];
//    
//    YMCustomCenterController *cunstom = [[YMCustomCenterController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
//    YMNavigationController *cunstomNav = [self addChildVc:cunstom title:@"定制中心" image:@"tab_5_default" selectedImage:@"tab_5_hover"];
//    
//    YMMineController *profile = ViewControllerFromSB(SB_Mine, SB_ID_Mine);
//    profile.navigationItem.title = @"";
//    YMNavigationController *profileNav = [self addChildVc:profile title:@"我的" image:@"tab_4_default" selectedImage:@"tab_4_hover"];
//    
//    @weakify(self);
//    void(^block)() = ^() {
//        @strongify(self);
//        
//        YMLoginModel *loginModel = [YMCacheHelper sharedCacheHelper].loginModel;
//        YMPowerModel *powerModel = [YMCacheHelper sharedCacheHelper].cachePowerModel;
//        
//        if (loginModel.is_creator && powerModel.is_autonymCert) {
//            self.viewControllers = @[homeNav,contactNav,cunstomNav,profileNav];
//        }else {
//            self.viewControllers = @[homeNav,contactNav,profileNav];
//        }
//    };
//    
//    block();
//    
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kSwitchBrandSuccessNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        block();
//    }];
//    
//    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kLoginSuccessNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
//        block();
//    }];
//    
//}
//
//- (YMNavigationController *)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage  {
//
//    childVc.title = title;
//
//    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:title
//                                                       image:[UIImage imageNamed:image]
//                                               selectedImage:[UIImage imageWithOriginalName:selectedImage]];
//    childVc.tabBarItem = item;
//    
//    YMNavigationController *nav = [[YMNavigationController alloc] initWithRootViewController:childVc];
//    
//    return nav;
//}
//



@end
