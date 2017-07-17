//
//  YMNetwork.h
//  RACDemo
//
//  Created by lym on 2017/7/17.
//
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

extern NSString * const kLoading ;
extern NSString * const kLoadError;
extern NSString * const kNetError;
extern NSString * const kSuccessful;
extern NSString * const kNoMoreData;

///  HTTP Request method.
typedef NS_ENUM(NSInteger, YMNetworkMethod) {
    YMKRequestMethodGET = 0,
    YMKRequestMethodPOST,
    YMKRequestMethodHEAD,
    YMKRequestMethodPUT,
    YMKRequestMethodDELETE,
    YMKRequestMethodPATCH,
};

typedef NS_ENUM(NSUInteger, YMRequestSerializer) {
    /// 设置请求数据为JSON格式
    YMRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    YMRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, YMResponseSerializer) {
    /// 设置响应数据为JSON格式
    YMResponseSerializerJSON,
    /// 设置响应数据为二进制格式
    YMResponseSerializerHTTP,
};

/// 请求成功的Block
typedef void(^YMHttpRequestSuccess)(id responseObject);

/// 请求失败的Block
typedef void(^YMHttpRequestFailed)(NSError *error);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^YMHttpProgress)(NSProgress *progress);

@interface YMNetwork : NSObject

/// 取消所有HTTP请求
+ (void)cancelAllRequest;

/// 取消指定URL的HTTP请求
+ (void)cancelRequestWithURL:(NSString *)URL;

/// 开启日志打印 (Debug级别)
+ (void)openLog;

/// 关闭日志打印
+ (void)closeLog;

//https request
+ (__kindof NSURLSessionTask *)requestWithMethod:(YMNetworkMethod)method URL:(NSString *)urlStr parameters:(id)params  success:(YMHttpRequestSuccess)success failure:(YMHttpRequestFailed)failure;


/**
 *  上传单/多张图片
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(YMHttpProgress)progress
                                           success:(YMHttpRequestSuccess)success
                                           failure:(YMHttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(YMHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(YMHttpRequestFailed)failure;



/*
 *******************************  AFHTTPSessionManager相关属性  *************************************
 */

#pragma mark 注意: 因为全局只有一个AFHTTPSessionManager实例,所以以下设置方式全局生效

/// 设置网络请求参数的格式:默认为JSON格式
+ (void)setRequestSerializer:(YMRequestSerializer)requestSerializer;

/// 设置服务器响应数据格式:默认为JSON格式
+ (void)setResponseSerializer:(YMResponseSerializer)responseSerializer;


/// 设置请求头
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;

@end


NS_ASSUME_NONNULL_END
