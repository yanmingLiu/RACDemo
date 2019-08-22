

#ifndef YMMacro_h
#define YMMacro_h


// MARK: - DEBUG模式下打印日志
//#ifndef __OPTIMIZE__
//#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
//#else
//#define NSLog(...) {}
//#endif


// MARK: - 单利宏
// .h
#define SingletonH + (instancetype)shared;
// .m
#define SingletonM \
static id _instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

// MARK: - 安全线程

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


// MARK: - 从storyboard中取出控制器
#define ViewControllerFromSB(sbName,sbId) [[UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:sbId]

// MARK: - 屏幕尺寸相关

#define KeyWindow  [UIApplication sharedApplication].keyWindow

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** 根据宽度比例计算 */
#define LayoutWH(size) (kScreenWidth * (size) / 375.0)

/* 状态栏高度 */
#define kStatusBarH     CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
/* NavBar高度 */
#define kNavigationBarH CGRectGetHeight(self.navigationController.navigationBar.frame)
/* 导航栏 高度 */
#define kNavigationH    (kStatusBarH + kNavigationBarH)

/** isIPhoneXSeries */
static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

/** TabBar高度 */
#define kTabBarH (isIPhoneXSeries() ? 83.0 : 49.0)

/** TabBar距离屏幕底部距离 */
#define kTabBarMargin safeAreaInsets_bottom()

static inline CGFloat safeAreaInsets_bottom() {
    CGFloat bottom = 0;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        bottom = 0;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        bottom = mainWindow.safeAreaInsets.bottom;
    }
    return bottom;
}

/** 2级页面高度 */
#define kContenViewH (kScreenHeight - kNavigationH - kTabBarMargin)


// MARK: - 颜色
// 十六定制
#define ColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define RGB(__r, __g, __b)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:1.0]

#define RGBA(__r, __g, __b, __a)  [UIColor colorWithRed:(1.0*(__r)/255)\
green:(1.0*(__g)/255)\
blue:(1.0*(__b)/255)\
alpha:__a]

// 随机颜色（RGB）
#define RandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f]

// MARK: - 字体

/**字体比例*/
#define kScaleFont(__VA_ARGS__)  ([UIScreen mainScreen].bounds.size.width/375)*(__VA_ARGS__)

#define FONT(frontSize) [UIFont systemFontOfSize:frontSize]

#define FONTWEIGHT(size, style) [UIFont systemFontOfSize:size weight:style]

#define FONTNAME(name,frontSize) [UIFont fontWithName:name size:frontSize]

// MARK: - 字符串
// 字符串不为空
#define NOTNULL(_str) _str.length ? _str : @""


// MARK: - 手机信息
// 当前应用软件版本
#define GET_APPCURVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 获取手机系统版本
#define GET_iOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// 获取手机序列号
#define GET_UUID [[UIDevice currentDevice] uniqueIdentifier]

// MARK: - 文件目录
#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathSearch                 [kPathDocument stringByAppendingPathComponent:@"Search.plist"]

#define kPathMagazine               [kPathDocument stringByAppendingPathComponent:@"Magazine"]
#define kPathDownloadedMgzs         [kPathMagazine stringByAppendingPathComponent:@"DownloadedMgz.plist"]
#define kPathDownloadURLs           [kPathMagazine stringByAppendingPathComponent:@"DownloadURLs.plist"]
#define kPathOperation              [kPathMagazine stringByAppendingPathComponent:@"Operation.plist"]

#define kPathSplashScreen           [kPathCache stringByAppendingPathComponent:@"splashScreen"]



#endif /* YMMacro_h */
