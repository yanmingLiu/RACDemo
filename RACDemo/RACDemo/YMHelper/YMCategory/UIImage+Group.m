//
//  UIImage+Group.m
//  GroupChatIcon
//
//  Created by lym on 2019/7/19.
//  Copyright © 2019 KH. All rights reserved.
//

#import "UIImage+Group.h"

@implementation UIImage (Group)

+ (void)groupIconWithUrls:(NSArray *)urls size:(CGSize)size padding:(CGFloat)padding bgColor:(UIColor *)bgColor defaultImg:(UIImage *)defaultImg callback:(void(^)(UIImage *image))callback
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSInteger avatarCount = urls.count > 9 ? 9 : urls.count;

        __block NSMutableArray *imageArray = [NSMutableArray array];
        __block NSInteger count = 0;    //下载图片完成的计数

        for (NSInteger i = avatarCount - 1; i >= 0; i--) {

            NSString *avatarUrl = [urls objectAtIndex:i];
            NSURL *URL = [NSURL URLWithString:avatarUrl];
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:(SDWebImageDownloaderLowPriority) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                count ++ ;
                NSLog(@"---%@", error);
                if (finished && image) {
                    [imageArray addObject:image];
                }else {
                    [imageArray addObject:defaultImg];
                }
                if (count == avatarCount) {     //图片全部下载完成
                    UIImage *image = [UIImage groupIconWithImages:imageArray size:size padding:padding bgColor:bgColor];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callback) {
                            callback(image);
                        }
                    });
                }
            }];
        }
    });
}

+ (UIImage *)groupIconWithImages:(NSArray *)images size:(CGSize)size padding:(CGFloat)padding bgColor:(UIColor *)bgColor
{
    CGRect rect = CGRectZero;
    rect.size = size;

    // 图片会模糊
//    UIGraphicsBeginImageContext(finalSize);

    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen]scale]);

    if (bgColor) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, bgColor.CGColor);
        CGContextSetFillColorWithColor(context, bgColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, 100);
        CGContextAddLineToPoint(context, 100, 100);
        CGContextAddLineToPoint(context, 100, 0);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }

    if (images.count >= 2) {

        NSArray *rects = [self eachRectInGroupWithCount2:images.count sizeValue:size.width padding:padding];
        int count = 0;
        for (id obj in images) {
            if (count > rects.count-1) {
                break;
            }

            UIImage *image;

            if ([obj isKindOfClass:[NSString class]]) {
                image = [UIImage imageNamed:(NSString *)obj];
            } else if ([obj isKindOfClass:[UIImage class]]){
                image = (UIImage *)obj;
            } else {
                NSLog(@"%s Unrecognizable class type", __FUNCTION__);
                break;
            }

            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



+ (NSArray *)eachRectInGroupWithCount2:(NSInteger)count sizeValue:(CGFloat)sizeValue padding:(CGFloat)padding  {

    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];

    CGFloat eachWidth;

    if (count <= 4) {
        eachWidth = (sizeValue - padding*3) / 2;
        [self getRects:array padding:padding width:eachWidth count:4];
    } else {
        padding = padding / 2;
        eachWidth = (sizeValue - padding*4) / 3;
        [self getRects:array padding:padding width:eachWidth count:9];
    }

    if (count < 4) {
        [array removeObjectAtIndex:0];
        CGRect rect = CGRectFromString([array objectAtIndex:0]);
        rect.origin.x = (sizeValue - eachWidth) / 2;
        [array replaceObjectAtIndex:0 withObject:NSStringFromCGRect(rect)];
        if (count == 2) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];

            for (NSString *rectStr in array) {
                CGRect rect = CGRectFromString(rectStr);
                rect.origin.y -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array removeAllObjects];
            [array addObjectsFromArray:tempArray];
        }
    } else if (count != 4 && count <= 6) {
        [array removeObjectsInRange:NSMakeRange(0, 3)];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:6];

        for (NSString *rectStr in array) {
            CGRect rect = CGRectFromString(rectStr);
            rect.origin.y -= (padding+eachWidth)/2;
            [tempArray addObject:NSStringFromCGRect(rect)];
        }
        [array removeAllObjects];
        [array addObjectsFromArray:tempArray];

        if (count == 5) {
            [tempArray removeAllObjects];
            [array removeObjectAtIndex:0];

            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        }

    } else if (count != 4 && count < 9) {
        if (count == 8) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        } else {
            [array removeObjectAtIndex:2];
            [array removeObjectAtIndex:0];
        }
    }

    return array;
}


+ (void)getRects:(NSMutableArray *)array padding:(CGFloat)padding width:(CGFloat)eachWidth count:(int)count {

    for (int i=0; i<count; i++) {
        int sqrtInt = (int)sqrt(count);
        int line = i%sqrtInt;
        int row = i/sqrtInt;
        CGRect rect = CGRectMake(padding * (line+1) + eachWidth * line, padding * (row+1) + eachWidth * row, eachWidth, eachWidth);
        [array addObject:NSStringFromCGRect(rect)];
    }
}


@end
