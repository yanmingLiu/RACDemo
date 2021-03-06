//
//  UIView+Frame.m
//  YMTextView
//
//  Created by yons on 15/2/13.
//  Copyright © 2015年 lym. All rights reserved.
//

#import "UIImage+YMImg.h"

@implementation UIImage (YMImg)

+ (instancetype)imageWithOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (instancetype)imageWithStretchableName:(NSString *)imageName  {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (instancetype)imageWithColor:(UIColor *)color {
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
    图形上下文：主要是对图片进行处理，操作步骤基本如下，可在 2 之前或者之后对上下文进行处理
 
    1 开启一个图形上下文
    2 绘制图片
    3 从当前上下文获取新的图片
    4 关闭上下文
 */

- (UIImage *)circleImageWithSize:(CGSize)size {
    // 1 开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2 绘制图片
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    // 3 从当前上下文获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)circleImageWithSize:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
  
    // 1 开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2 绘制图片
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    
    // 设置边框的宽度
    CGContextSetLineWidth(ctx, borderWidth);
    // 设置边框的颜色
    [borderColor set];
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextStrokePath(ctx);
    
    // 3 从当前上下文获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor completion:(void (^)(UIImage *image))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 设置背景填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        // Bezier绘制图形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        
        [path addClip];
        [self drawInRect:rect];
        // 获得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭
        UIGraphicsEndImageContext();
        // 到主线程中刷新UI, 完成回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
    });
}

- (void)cornerImageWithSize:(CGSize)size fillColor:(UIColor *)fillColor borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth completion:(void (^)(UIImage *))completion {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        // 设置背景填充颜色
        [fillColor setFill];
        UIRectFill(rect);
        
        // Bezier绘制图形
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        [borderColor setStroke];
        path.lineWidth = borderWidth;
        
        [path addClip];
        [self drawInRect:rect];
        // 获得结果
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        
        // 关闭
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion != nil) {
                completion(result);
            }
        });
        
    });
}

+ (UIImage *)waterImageWithImage:(UIImage *)image text:(NSString *)text textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed {
    //1.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //添加水印文字
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

+(instancetype)waterImageWithBgImageName:(NSString *)bgImageName waterImageName:(NSString *)waterImageName scale:(CGFloat)scale {
    // 生成一张有水印的图片，一定要获取UIImage对象 然后显示在imageView上
    
    //创建一背景图片
    UIImage *bgImage = [UIImage imageNamed:bgImageName];
    //NSLog(@"bgImage Size: %@",NSStringFromCGSize(bgImage.size));
    // 1.创建一个位图【图片】，开启位图上下文
    // size:位图大小
    // opaque: alpha通道 YES:不透明/ NO透明 使用NO,生成的更清析
    // scale 比例 设置0.0为屏幕的比例
    // scale 是用于获取生成图片大小 比如位图大小：20X20 / 生成一张图片：（20 *scale X 20 *scale)
    //NSLog(@"当前屏幕的比例 %f",[UIScreen mainScreen].scale);
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, scale);
    
    // 2.画背景图
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.画水印
    // 算水印的位置和大小
    // 一般会通过一个比例来缩小水印图片
    UIImage *waterImage = [UIImage imageNamed:waterImageName];
    //#warning 水印的比例，根据需求而定
    CGFloat waterScale = 0.4;
    CGFloat waterW = waterImage.size.width * waterScale;
    CGFloat waterH = waterImage.size.height * waterScale;
    CGFloat waterX = bgImage.size.width - waterW;
    CGFloat waterY = bgImage.size.height - waterH;
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    // 4.从位图上下文获取 当前编辑的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.结束当前位置编辑
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 图片压缩
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 生成带logo的二维码图片
 */
+ (UIImage *)qrImageForUrlStr:(NSString *)urlStr imageSize:(CGFloat)imagesize waterimage:(UIImage *)waterimage waterImagesize:(CGFloat)waterImagesize {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:imagesize waterImageSize:waterImagesize waterimage:waterimage];
}

/**
 二维码
 */
+ (UIImage *)qrImageForUrlStr:(NSString *)urlStr imageSize:(CGFloat)Imagesize {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    
    return [self createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:0 waterimage:nil];
}

// 给二维码加Logo
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size waterImageSize:(CGFloat)waterImagesize waterimage:(UIImage *)waterimage{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    
    //给二维码加 logo 图
    if (waterimage && waterImagesize) {
        
        UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
        [outputImage drawInRect:CGRectMake(0,0 , size, size)];
        
        //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
        [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
        
        UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newPic;
    }
    
    return outputImage;
}


/**
 保存图片到本地，并读取本地图片信息(名字+路径)
 */
- (void)saveImageToPhotoLibraryCompleted:(void(^)(PHAsset *asset, NSString *imgePath))completed {

    // 1. 获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    // 2. 判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        __block NSString *createdAssetId = nil;
        // 添加图片到【相机胶卷】
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
        } error:nil];

        if (createdAssetId == nil) {
            !completed ? : completed(nil, nil);
        }

        // 在保存完毕后取出图片信息
        PHFetchResult * result = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
        PHAsset *asset = [result firstObject];

        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            NSString *fileName = [obj valueForKey:@"filename"];
            NSLog(@"%@", fileName); // 能得到名字 IMG_3301.JPG
        }];

        [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput * _Nullable contentEditingInput, NSDictionary * _Nonnull info) {

            NSLog(@"URL: %@",  contentEditingInput.fullSizeImageURL.absoluteString);
            NSString* path = [contentEditingInput.fullSizeImageURL.absoluteString substringFromIndex:7];//screw all the crap of file://
            NSLog(@"path: %@", path);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL isExist = [fileManager fileExistsAtPath:path];
            if (isExist) {
                NSLog(@"oh yeah");
                !completed ? : completed(asset, path);
            }
            else {
                NSLog(@"damn");
                !completed ? : completed(asset, nil);
            }
        }];
    }
    else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 如果用户选择授权, 则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageToPhotoLibraryCompleted:completed];
            }
        }];
    } else {
        NSLog(@"请在设置界面, 授权访问相册");
        completed(nil, nil);
    }
}

/**
 获得刚才添加到【相机胶卷】中的图片 
 
 相当于 - (void)saveImageToPhotoLibraryFinish:(void(^)(PHAsset *asset))finish
 */
- (PHFetchResult<PHAsset *> *)saveImageToPhotoLibrary {
    __block NSString *createdAssetId = nil;
    // 添加图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) return nil;
    // 在保存完毕后取出图片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}


/**
 UIView - 生成图片
 */
+ (UIImage *)getmakeImageWithView:(UIView *)view andWithSize:(CGSize)size;
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

/**
 UIImage - 生成钉钉名字头像
 */
+ (UIImage *)ym_nameIconWithText:(NSString *)text bgColor:(UIColor *)bgColor size:(CGSize)size{

    if (text== nil || text.length == 0) {
        return nil;
    }
    if (text.length >= 3) {
        if (text.length == 4) {
            text = [text substringWithRange:NSMakeRange(2, 2)];
        }else {
            text = [text substringWithRange:NSMakeRange(1, 2)];
        }
    }

    NSDictionary *fontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSForegroundColorAttributeName: [UIColor whiteColor]};

    CGSize textSize = [text sizeWithAttributes:fontAttributes];

    CGPoint drawPoint = CGPointMake((size.width - textSize.width)/2, (size.height - textSize.height)/2);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];

    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);

    [path fill];

    [text drawAtPoint:drawPoint withAttributes:fontAttributes];

    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resultImg;
}

@end
