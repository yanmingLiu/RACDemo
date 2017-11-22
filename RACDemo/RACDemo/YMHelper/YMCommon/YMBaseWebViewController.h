//
//  YMBaseWebViewController.h
//  YKXB
//
//  Created by 刘彦铭 on 2017/5/27.
//  Copyright © 2017年 YouKeXue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Defines.h"


@interface YMBaseWebViewController : UIViewController <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *myWebView;

@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) NSString *url;

@end
