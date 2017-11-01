
//  宏定义

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志
#ifndef __OPTIMIZE__
#define NSLog(fmt,...) NSLog((@"<%s:%d>" fmt), strrchr(__FILE__,'/'), __LINE__, ##__VA_ARGS__);
#else
#define NSLog(...) {}
#endif


/*---------------------------------------------------------*/

// 单例化一个类

// 单例化一个类
// @interface
#define singleton_interface(className) \
+ (className *)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}
/*---------------------------------------------------------*/

//归档到Library/Cache文件夹
#define NSArchiveToFile(obj,fileName) \
NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];\
NSString *guiDangPathStr = [NSString stringWithFormat:@"%@/GuiDangCache", pathDocuments];\
NSFileManager *fileManager = [NSFileManager defaultManager];\
if (![fileManager fileExistsAtPath:guiDangPathStr]) {\
[fileManager createDirectoryAtPath:guiDangPathStr withIntermediateDirectories:YES attributes:nil error:nil];\
}\
NSString *guiDangpath = [guiDangPathStr stringByAppendingPathComponent:fileName];\
[NSKeyedArchiver archiveRootObject:obj toFile:guiDangpath];

//解档
#define NSUnarchiveFromFile(fileName) [NSKeyedUnarchiver unarchiveObjectWithFile: [[NSString stringWithFormat:@"%@/GuiDangCache", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]] stringByAppendingPathComponent:fileName]];

/*---------------------------------------------------------*/

//从storyboard中取出控制器
#define ViewControllerFromSB(sb,ident) [[UIStoryboard storyboardWithName:sb bundle:nil] instantiateViewControllerWithIdentifier:ident]


/*---------------------------------------------------------*/

// 弱引用
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(self) strongSelf = weakSelf 

/*---------------------------------------------------------*/

/* 状态栏高度 */
#define kStatusBarH     CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
/* NavBar高度 */
#define kNavigationBarH CGRectGetHeight(self.navigationController.navigationBar.frame)
/* 导航栏 高度 */
#define kNavigationH   (kStatusBarH + kNavigationBarH)


#define window0  [UIApplication sharedApplication].keyWindow
#define Keywindow  [UIApplication sharedApplication].keyWindow


//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define CONTENT_HEIGHT (SCREEN_HEIGHT - kNavigationH)

//屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

// 比例宽高（适配）6
#define LayoutW(w) [[UIScreen mainScreen] bounds].size.width / 375 * w
#define LayoutH(h)  ([[UIScreen mainScreen] bounds].size.height > 667? [[UIScreen mainScreen] bounds].size.height : 667) / 667 * h


/*---------------------------------------------------------*/

//去掉nsstring的空格
#define NSStringRemoveSpace(string) [string stringByReplacingOccurrencesOfString:@" " withString:@""]

//处理nil
#define NSStringIsNil(STR) STR.length ? STR: @""

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//空值判断
#define checkNull(__X__)        (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

/*---------------------------------------------------------*/

//颜色值
#define COLOR_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

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



/*---------------------------------------------------------*/
// 字体
#define FONT(frontSize) [UIFont systemFontOfSize:frontSize]
#define FRONTWITHSIZE(frontSize) [UIFont fontWithName:@"MicrosoftYaHei" size:frontSize]

#define FONT_NAME_SIZE(name,frontSize) [UIFont fontWithName:name size:frontSize]

/*---------------------------------------------------------*/

//获取系统时间戳
#define GET_CurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

#define MBHiddenTime 1.5
/*---------------------------------------------------------*/

// 当前应用软件版本
#define GET_APPCURVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 获取手机系统版本
#define GET_iOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// 获取手机序列号
#define GET_UUID [[UIDevice currentDevice] uniqueIdentifier]


/*---------------------------------------------------------*/

//文件目录
#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kPathSearch                 [kPathDocument stringByAppendingPathComponent:@"Search.plist"]

#define kPathMagazine               [kPathDocument stringByAppendingPathComponent:@"Magazine"]
#define kPathDownloadedMgzs         [kPathMagazine stringByAppendingPathComponent:@"DownloadedMgz.plist"]
#define kPathDownloadURLs           [kPathMagazine stringByAppendingPathComponent:@"DownloadURLs.plist"]
#define kPathOperation              [kPathMagazine stringByAppendingPathComponent:@"Operation.plist"]

#define kPathSplashScreen           [kPathCache stringByAppendingPathComponent:@"splashScreen"]

/*---------------------------------------------------------*/




























