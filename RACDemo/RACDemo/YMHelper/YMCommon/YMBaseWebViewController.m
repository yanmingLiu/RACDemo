//
//  YMBaseWebViewController.m
//  YKXB
//
//  Created by 刘彦铭 on 2017/5/27.
//  Copyright © 2017年 YouKeXue. All rights reserved.
//

#import "YMBaseWebViewController.h"


@interface YMBaseWebViewController ()
/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;

@end

@implementation YMBaseWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleText;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view addSubview:self.myWebView];
    [self.view addSubview:self.myProgressView];
    
    self.url = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:self.url];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    
}

// 记得取消监听
- (void)dealloc
{
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - WKNavigationDelegate method

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"webViewWebContentProcessDidTerminate:  当Web视图的网页内容被终止时调用。");
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"webView:didFinishNavigation:  响应渲染完成后调用该方法   webView : %@  -- navigation : %@  \n\n",webView,navigation);
    // 禁止放大缩小
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"webView:didStartProvisionalNavigation:  开始请求  \n\n");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"webView:didCommitNavigation:   响应的内容到达主页面的时候响应,刚准备开始渲染页面应用 \n\n");
}


// error
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView:didFailProvisionalNavigation:withError: 启动时加载数据发生错误就会调用这个方法。  \n\n");
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webView:didFailNavigation: 当一个正在提交的页面在跳转过程中出现错误时调用这个方法。  \n\n");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"返回响应前先会调用这个方法  并且已经能接收到响应webView:decidePolicyForNavigationResponse:decisionHandler: Response?%@  \n\n",navigationResponse.response);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}



- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"webView:didReceiveServerRedirectForProvisionalNavigation: 重定向的时候就会调用  \n\n");
}


// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"请求前会先进入这个方法  webView:decidePolicyForNavigationActiondecisionHandler: %@   \n\n  ",navigationAction.request);
    
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - event response

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.myWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.myProgressView.alpha = 1.0f;
        [self.myProgressView setProgress:newprogress animated:YES];
        if (newprogress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.myProgressView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [self.myProgressView setProgress:0 animated:NO];
                             }];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - getter and setter

- (UIProgressView *)myProgressView
{
    if (_myProgressView == nil) {
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = RGB(8, 179, 129);
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    
    return _myProgressView;
}

- (WKWebView *)myWebView
{
    if(_myWebView == nil)
    {
        //配置信息
        WKWebViewConfiguration *config=[[WKWebViewConfiguration alloc]init];
        config.preferences=[[WKPreferences alloc]init];
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = true;
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = true;

        // 通过js与webview内容交互配置
        config.userContentController=[[WKUserContentController alloc]init];
        // 添加一个名称，在JS通过这个名称发送消息
//        [config.userContentController addScriptMessageHandler:self name:@"yichu"];
        
        _myWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT) configuration:config];
        _myWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 自动高度
        _myWebView.navigationDelegate = self;
        _myWebView.opaque = NO;
        _myWebView.multipleTouchEnabled = YES;
        [_myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    
    return _myWebView;
}

@end
