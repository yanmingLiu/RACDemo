

#ifndef YMMacro_h
#define YMMacro_h


// MARK: - DEBUG模式下打印日志
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(...) {}
#endif

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

// MARK: - 从storyboard中取出控制器
#define ViewControllerFromSB(sbName,sbId) [[UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:sbId]

// MARK: - 屏幕尺寸相关

#define KeyWindow  [UIApplication sharedApplication].keyWindow

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

// MARK: - 导航栏\状态栏\TabBar高度
/* 状态栏高度 */
#define kStatusBarH     CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
/* NavBar高度 */
#define kNavigationBarH CGRectGetHeight(self.navigationController.navigationBar.frame)
/* 导航栏 高度 */
#define kNavigationH    (kStatusBarH + kNavigationBarH)

/** 判断是不否是iPhoneX */
#define Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/** TabBar高度 */
#define kTabBarH (Is_iPhoneX ? 78.0 : 44.0) 
/** TabBar距离屏幕底部距离 */
#define kTabBarMargin (Is_iPhoneX ? 34.0 : 0.0) 

/** 2级页面高度 */
#define kContenViewH (kScreenHeight - kNavigationH - kTabBarMargin) 


/** 比例宽 */
#define LayoutW(w) (kScreenWidth / 375.0 * w)
#define LayoutH(h) (kScreenWidth * h / 375.0)


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
#define RandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];

// MARK: - 字体

#define FONT(frontSize) [UIFont systemFontOfSize:frontSize]

#define FONTWEIGHT(size, weight) [UIFont systemFontOfSize:size weight:weight]

#define FONTNAME(name,frontSize) [UIFont fontWithName:name size:frontSize]

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
