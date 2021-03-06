//
//  UIView+Frame.m
//  YMTextView
//
//  Created by yons on 15/2/13.
//  Copyright © 2015年 lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface UIImage (YMImg)

/**
 *  加载最原始的图片，没有渲染
 */
+ (instancetype)imageWithOriginalName:(NSString *)imageName;

/**
 *  内容可拉伸，而边角不拉伸的图片、例如聊天气泡
 */
+ (instancetype)imageWithStretchableName:(NSString *)imageName;

/**
 *  根据颜色生成一张尺寸为1*1的相同颜色图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;

/**
 *  绘制圆角图片
 */
- (UIImage *)circleImageWithSize:(CGSize)size;

/**
 *  绘制圆角图片 带边框
 */
- (UIImage *)circleImageWithSize:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 *  异步绘制圆角图片
 */
- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion;

/**
 *  给图片添加文字水印
 */
+ (instancetype)waterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed;

/**
 *  给图片添加图片水印
 */
+(instancetype)waterImageWithBgImageName:(NSString *)bgImageName waterImageName:(NSString *)waterImageName scale:(CGFloat)scale;

/**
 图片压缩
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 生成带logo的二维码图片
 */
+ (UIImage *)qrImageForUrlStr:(NSString *)urlStr imageSize:(CGFloat)imagesize waterimage:(UIImage *)waterimage waterImagesize:(CGFloat)waterImagesize;


/**
 二维码
 */
+ (UIImage *)qrImageForUrlStr:(NSString *)urlStr imageSize:(CGFloat)imagesize;


/**
 保存图片到本地，并读取本地图片信息(名字+路径)
 */
- (void)saveImageToPhotoLibraryCompleted:(void(^)(PHAsset *asset, NSString *imgePath))completed;

/**
 获得刚才添加到【相机胶卷】中的图片 
 
 相当于 - (void)saveImageToPhotoLibraryFinish:(void(^)(PHAsset *asset))finish
 */
- (PHFetchResult<PHAsset *> *)saveImageToPhotoLibrary;


/**
 UIView - 生成图片
 */
+ (UIImage *)getmakeImageWithView:(UIView *)view andWithSize:(CGSize)size;


/**
 UIImage - 生成钉钉名字头像
 */
+ (UIImage *)ym_nameIconWithText:(NSString *)text bgColor:(UIColor *)bgColor size:(CGSize)size;


@end
