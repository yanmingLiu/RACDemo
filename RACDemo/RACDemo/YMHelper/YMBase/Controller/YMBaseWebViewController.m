

#import "YMBaseWebViewController.h"


@interface YMBaseWebViewController () 
/** UI */
@property (nonatomic, strong) UIProgressView *myProgressView;

@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIView *stateView;

@end

@implementation YMBaseWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

// 记得取消监听
- (void)dealloc
{
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];

//    [self.myWebView.configuration.userContentController removeScriptMessageHandlerForName:@"name"]
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.titleText;

    self.view.backgroundColor = [UIColor whiteColor];

    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    [self.view addSubview:self.myWebView];

    [self.view addSubview:self.myProgressView];

    [self loadRequest];

    [self setupUI];

    [self addNotification];
}


// MARK: - setupUI

- (void)setupUI {
    UIView *stateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarH)];
    stateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stateView];
    self.stateView = stateView;

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, kStatusBarH, 44, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:backBtn];
    self.backBtn = backBtn;
}

// MARK: - actions

- (void)backBtnClick
{
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeBackBtnImageWithSuccess:(BOOL)success {

    NSString *backImage = @""; // nav_back
    if (!success) {
        backImage = @"nav_black";
    }

    [self.backBtn setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
}

// MARK: - addNotification

- (void)addNotification {

}


// MARK: - loadRequest

- (void)loadRequest {
    // cooki

    NSString * script = [NSString stringWithFormat:@"lc_user_id=%@;",@"test"];

    WKUserScript * cookieScript = [[WKUserScript alloc]initWithSource:script
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                     forMainFrameOnly:YES];

    [self.myWebView.configuration.userContentController addUserScript:cookieScript];



    NSString *url = [self.urlStr.stringByRemovingPercentEncoding stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:URL];

    NSString * cookieValue = [NSString stringWithFormat:@"lc_user_id=%@;",@"test"];
    NSLog(@"%@", cookieValue);

    [req addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    [self.myWebView loadRequest:req];
}


// MARK: - WKNavigationDelegate method

/*!
 决定是否允许或取消导航。
 如果不实现此方法，Web视图将加载请求，或者在适当的情况下将其转发到另一个应用程序。
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"%s", __func__);
}

/*!
 决定在知道导航的响应之后是否允许或取消导航
 如果不实现此方法，则Web视图将允许响应（如果Web视图可以显示）
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSLog(@"%s", __func__);
}

/*!
 在导航开始时使用。
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%s", __func__);
}

/*!
 当接收到主机的服务器重定向时调用。
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%s", __func__);
}

/*!
 当开始加载主框架的数据时发生错误时调用。
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __func__);
}

/*!
 当内容开始到达主帧时使用。
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%s", __func__);
}

/*!
 当主框架导航完成时调用。
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"%s", __func__);
}

/*!
 在提交的主框架导航过程中发生错误时调用。
 */
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"%s", __func__);
}

/*!
 当Web视图需要响应身份验证质询时调用。
 completion handler您必须调用的完成处理程序才能响应。当处置是不可撤销的、合法的、挑战性的、必要的，
 credential参数是要使用的凭证，或者nil表示没有凭证继续。
 如果不实现此方法，Web视图将使用nsurlsessionAuthChallengeRejectProtectionSpace部署响应身份验证质询。
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSLog(@"%s", __func__);
}

/*!
 当Web视图的Web内容进程终止时调用。
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"%s", __func__);
}

// MARK: - WKUIDelegate

/*! @abstract Creates a new web view.
 配置创建新WebView时要使用的配置
 如果不实现此方法，Web视图将取消导航。
 */
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return self.myWebView;
}

/*!
 显示一个javascript警报面板。
 如果不实现此方法，则Web视图的行为将类似于用户选择了“确定”按钮。
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s", __func__);
}

/*! @abstract 显示一个javascript警报面板。
 面板应该有两个按钮，如OK和Cancel。
 如果不实现此方法，则Web视图的行为将类似于用户选择了“取消”按钮。
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
     NSLog(@"%s", __func__);
}

/*! @abstract 显示一个javascript警报面板。
 面板应该有两个按钮，例如“确定”和“取消”，以及 输入文本。
 如果不实现此方法，则Web视图的行为将类似于用户选择了“取消”按钮。
 */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
     NSLog(@"%s", __func__);
}


/*! @abstract 允许应用程序确定给定元素是否应显示预览。
 要完全禁用给定元素的预览，返回编号。返回编号将阻止
 WebView:PreviewingViewControllerForElement:DefaultActions:和WebView:CommitPreviewingViewController:
 不会被调用。
 此方法将仅对WebKit中具有默认预览的元素调用，即仅限于链接。在将来，它可以为其他元素调用。
 */
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
{
    NSLog(@"%s", __func__);
    return NO;
}

/*! @abstract允许您的应用程序提供一个自定义视图控制器，以便在查看给定元素时显示。
 返回视图控制器将导致该视图控制器显示为预览。
 要使用defaultActions，您的应用程序将负责返回希望在您的查看控制器对-previewactionitems的实现。

 返回nil将导致WebKit的默认预览行为。将仅调用WebView:CommitPreviewingViewController:
 */
- (nullable UIViewController *)webView:(WKWebView *)webView previewingViewControllerForElement:(WKPreviewElementInfo *)elementInfo defaultActions:(NSArray<id <WKPreviewActionItem>> *)previewActions
{
    NSLog(@"%s", __func__);
    return nil;
}

/*!
 允许应用程序弹出到它创建的视图控制器。
 */
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
    NSLog(@"%s", __func__);
}


// MARK: - WKScriptMessageHandler

/*!
 从网页接收脚本消息时调用。
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%s", __func__);

}


#pragma mark - KVO

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
        _myProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kStatusBarH, [UIScreen mainScreen].bounds.size.width, 0)];
        _myProgressView.tintColor = [UIColor blueColor];
        _myProgressView.trackTintColor = [UIColor whiteColor];
    }
    return _myProgressView;
}

- (WKWebView *)myWebView
{
    if (!_myWebView) {

        // 偏好设置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
        config.preferences = [[WKPreferences alloc]init];
        config.preferences.minimumFontSize = 10;  // 默认0s

        CGRect frame = CGRectMake(0, kStatusBarH, kScreenWidth, kScreenHeight-kTabBarMargin-kStatusBarH);
        _myWebView = [[WKWebView alloc]initWithFrame:frame configuration:config];

        _myWebView.navigationDelegate = self;
        _myWebView.UIDelegate = self;

        _myWebView.opaque = NO;
        _myWebView.multipleTouchEnabled = YES;
        _myWebView.customUserAgent = @"ios"; // 标识

        [_myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _myWebView;
}

@end



// MARK: - 处理scriptDelegate 设置self不释放问题

@interface YMWeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end


@implementation YMWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}


@end
