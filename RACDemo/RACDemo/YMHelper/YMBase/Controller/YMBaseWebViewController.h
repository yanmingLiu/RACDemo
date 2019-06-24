

#import <UIKit/UIKit.h>
#import<WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface YMBaseWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *myWebView;

@property (nonatomic, strong) NSString *titleText;

@property (nonatomic, strong) NSString *urlStr;

@end
